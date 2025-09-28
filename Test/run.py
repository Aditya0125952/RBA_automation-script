import spacy
from spacy.matcher import Matcher
import sys
import subprocess
from pathlib import Path
import re

# Import the discovery function from your pabots.py script
from pabots import discover_tests

# --- 1. Setup ---
nlp = spacy.load("en_core_web_sm")
matcher = Matcher(nlp.vocab)

# --- 2. Configuration & Dictionaries ---
LENDER_ALIASES = {
    "FFC": ["ffc", "foundation", "foundation finance"],
    "GL": ["gl", "good leap"],
    "PP": ["pp","powerpay"],
    "GICU":["gicu","GICU"],
    "Upgrade":["UG","Upgrade"]
}
KNOWN_FLOWS = {"happy": "HappyCase", "pending": "Pending"}
CATEGORY_MAP = {
    "single": "Single_Applicant", "single applicant": "Single_Applicant",
    "co": "Co-Applicant", "co-applicant": "Co-Applicant", "co-app": "Co-Applicant"
}
WORD_TO_DIGIT = {"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "twice": 2}


def setup_matcher(matcher, known_lenders, aliases, categories, flows, numbers):
    """Dynamically creates and adds all SpaCy patterns to the matcher."""
    alias_to_official_code = {
        alias.lower(): official for official, alias_list in aliases.items() for alias in alias_list
    }
    for lender in known_lenders:
        if lender.lower() not in alias_to_official_code:
            alias_to_official_code[lender.lower()] = lender

    lender_patterns = [[{"LOWER": word} for word in alias.split()] for alias in alias_to_official_code.keys()]
    matcher.add("Lender", lender_patterns)
    category_patterns = [[{"LOWER": word} for word in phrase.split()] for phrase in categories.keys()]
    matcher.add("Category", category_patterns)
    flow_patterns = [[{"LOWER": key}] for key in flows.keys()]
    matcher.add("Flow", flow_patterns)
    runs_patterns = [[{"IS_DIGIT": True}], [{"LOWER": {"IN": list(numbers.keys())}}]]
    matcher.add("Run", runs_patterns)
    instance_pattern = [[{"LOWER": {"REGEX": "^rba\\d+$"}}]]
    matcher.add("Instance", instance_pattern)
    return alias_to_official_code


def parse_single_command(command_text, alias_map):
    """Uses SpaCy to parse a single test command and returns a params dictionary."""
    doc = nlp(command_text)
    matches = matcher(doc)
    params = {"lender": None, "flow": "HappyCase", "runs": 1, "category": "Single_Applicant", "instance": None}
    for match_id, start, end in matches:
        pattern_name = nlp.vocab.strings[match_id]
        matched_text = doc[start:end].text.lower()
        if pattern_name == "Lender":
            params["lender"] = alias_map.get(matched_text)
        elif pattern_name == "Category":
            params["category"] = CATEGORY_MAP.get(matched_text)
        elif pattern_name == "Flow":
            params["flow"] = KNOWN_FLOWS.get(matched_text, "HappyCase")
        elif pattern_name == "Run":
            # This is the robust way to handle the conversion
            cleaned_text = matched_text.strip()
            if cleaned_text in WORD_TO_DIGIT:
                params["runs"] = WORD_TO_DIGIT[cleaned_text]
            elif cleaned_text.isdigit():
                params["runs"] = int(cleaned_text)
            else:
                print(f"[ERROR] Could not convert '{cleaned_text}' to a number.")
        elif pattern_name == "Instance":
            params["instance"] = matched_text
    if not params["lender"]:
        return None
    return params


# --- 3. Core Logic ---
def main():
    # --- Discover and Set up Patterns ---
    SCRIPT_DIR = Path(__file__).resolve().parent
    TEST_BASE_DIR = SCRIPT_DIR / "Lenders"
    print("[INFO] Dynamically discovering available lenders...")
    AVAILABLE_TESTS = discover_tests(TEST_BASE_DIR)
    discovered_lenders = {key for cat in AVAILABLE_TESTS.values() for key in cat.keys()}
    print(f"[INFO] Found lenders: {', '.join(discovered_lenders)}")
    alias_map = setup_matcher(matcher, discovered_lenders, LENDER_ALIASES, CATEGORY_MAP, KNOWN_FLOWS, WORD_TO_DIGIT)

    # --- Parse User Command ---
    user_input = " ".join(sys.argv[1:])
    if not user_input:
        print("Usage: python run.py <multi-part command in plain english>")
        return

    # UPDATED: Find a global instance to use as a default
    global_instance = None
    instance_match = re.search(r'rba\d+', user_input, re.IGNORECASE)
    if instance_match:
        global_instance = instance_match.group(0).lower()

    sub_commands = re.split(r'\s+and\s+|,', user_input, flags=re.IGNORECASE)
    tests_to_run = []
    print("\n[INFO] Parsing your command for individual test runs...")

    for sub_cmd in sub_commands:
        if not sub_cmd.strip(): continue
        params = parse_single_command(sub_cmd, alias_map)
        if params:
            # UPDATED: If a local instance wasn't found in this part of the command,
            # use the global one we found earlier.
            if not params.get("instance"):
                params["instance"] = global_instance

            tests_to_run.append(params)
            print(f"  -> Found test: {params}")

    if not tests_to_run:
        print("\n[ERROR] Could not find any valid test commands to run.")
        return

    # --- Build and Execute multiple Commands ---
    print(f"\n[INFO] Preparing to launch {len(tests_to_run)} different test execution(s)...")
    processes = []
    for params in tests_to_run:
        test_name = f"{params['lender']} {params['flow']}".replace("_PEND ", " ")
        final_command = [
            sys.executable, "pabots.py", params['category'],
            "--lender", params['lender'], "--test", test_name, "--runs", str(params['runs'])
        ]
        if params["instance"]:
            final_command.extend(["--instance", params["instance"]])

        print(f"  -> Launching: {' '.join(final_command)}")
        p = subprocess.Popen(final_command)
        processes.append(p)

    print(f"\n[INFO] Waiting for all {len(processes)} test executions to complete...")
    for p in processes:
        p.wait()

    print("\n[INFO] All test executions have finished.")


if __name__ == "__main__":
    main()