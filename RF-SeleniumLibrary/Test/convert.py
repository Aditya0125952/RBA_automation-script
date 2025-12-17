import json
import pathlib
import datetime
import os  # <-- Make sure this import is here
from dateutil.relativedelta import relativedelta

# --- Configuration ---
# Using the "InputData" folder name you specified
INPUT_DIR = pathlib.Path(__file__).parent / "InputData"
TRIGGER_DAY = 3  # The day of the month to run the update
DOB_FORMAT = "%m/%d/%Y" # The format of the date string in your JSON

def update_dob_string(dob_str: str) -> str:
    """
    Takes a DOB string, adds one month, and returns the new string.
    """
    try:
        old_dob = datetime.datetime.strptime(dob_str, DOB_FORMAT).date()
        new_dob = old_dob + relativedelta(months=1)
        return new_dob.strftime(DOB_FORMAT)
    except ValueError:
        print(f"  [WARN] Skipping invalid date format: '{dob_str}'")
        return dob_str

def process_json_file(file_path: pathlib.Path):
    """
    Opens a single JSON file, updates all DOBs, and saves it.
    """
    print(f"[INFO] Processing file: {file_path.name}")
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)
        
        data_changed = False

        def update_person(person_obj):
            """A helper to update DOB in a person object."""
            if isinstance(person_obj, dict) and 'dob' in person_obj:
                old_dob = person_obj['dob']
                new_dob = update_dob_string(old_dob)
                if old_dob != new_dob:
                    person_obj['dob'] = new_dob
                    return True
            return False

        # Check for all variations of applicant keys
        if 'Applicant' in data and update_person(data['Applicant']):
            data_changed = True
        if 'Co-Applicant' in data and update_person(data['Co-Applicant']):
            data_changed = True
        if 'Applicants' in data and isinstance(data['Applicants'], list):
            for person in data['Applicants']:
                if update_person(person):
                    data_changed = True
        if 'Co-Applicants' in data and isinstance(data['Co-Applicants'], list):
            for person in data['Co-Applicants']:
                if update_person(person):
                    data_changed = True
        
        if data_changed:
            with open(file_path, 'w') as f:
                json.dump(data, f, indent=2)
            print(f"  [SUCCESS] Updated DOBs in {file_path.name}")
        else:
            print(f"  [INFO] No DOBs found or updated in {file_path.name}")

    except json.JSONDecodeError:
        print(f"  [ERROR] Failed to read {file_path.name}. Invalid JSON.")
    except Exception as e:
        print(f"  [ERROR] An unknown error occurred with {file_path.name}: {e}")


def main():
    """
    Main function to check the date and trigger the update process.
    """
    
    # --- "Proof of Life" log for testing the scheduler ---
    # This line runs first, creating a file to prove the task ran.
    log_file_path = pathlib.Path(__file__).parent / "scheduler_test.log"
    with open(log_file_path, "w") as f:
        f.write(f"Scheduler successfully ran this script at: {datetime.datetime.now()}")
    # --- End of test code ---

    
    today = datetime.date.today()
    print(f"--- Running DOB Update Script on {today} ---")
    
    # --- The date check is now RESTORED ---
    if today.day == TRIGGER_DAY:
        print(f"[TRIGGER] Today is the {TRIGGER_DAY}rd. Starting update process...")
        
        # This code is now correctly INDENTED
        if not INPUT_DIR.is_dir():
            print(f"[ERROR] Input directory not found: {INPUT_DIR}")
            return

        json_files = list(INPUT_DIR.glob("*.json"))
        if not json_files:
            print("[WARN] No .json files found in the input directory.")
            return

        for file_path in json_files:
            process_json_file(file_path)
        
        print("\n--- Update process complete. ---")
        
    # --- The 'else' block is now RESTORED ---
    else:
        print(f"[INFO] Not the {TRIGGER_DAY}rd of the month. No updates will be made.")
        print("--- Script finished. ---")

if __name__ == "__main__":
    main()