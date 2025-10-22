import json
import pathlib
import datetime
from dateutil.relativedelta import relativedelta

# --- Configuration ---
INPUT_DIR = pathlib.Path(__file__).parent / "input"
TRIGGER_DAY = 3  # The day of the month to run the update
DOB_FORMAT = "%m/%d/%Y" # The format of the date string in your JSON

def update_dob_string(dob_str: str) -> str:
    """
    Takes a DOB string, adds one month, and returns the new string.
    
    This function correctly handles all date rollovers, including:
    - "12/01/1945" -> "01/01/1946"
    - "01/31/1945" -> "02/28/1945" (or 29th on a leap year)
    """
    try:
        # 1. Convert the string to a date object
        old_dob = datetime.datetime.strptime(dob_str, DOB_FORMAT).date()
        
        # 2. Add exactly one month
        new_dob = old_dob + relativedelta(months=1)
        
        # 3. Convert back to a string and return
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
        
        data_changed = False # Flag to track if we need to save

        # --- This section finds all possible applicants ---
        # It checks for single applicants, co-applicants,
        # and lists of applicants/co-applicants.

        def update_person(person_obj):
            """A helper to update DOB in a person object."""
            if isinstance(person_obj, dict) and 'dob' in person_obj:
                old_dob = person_obj['dob']
                person_obj['dob'] = update_dob_string(old_dob)
                return True
            return False

        # Check for single 'applicant'
        if 'applicant' in data and update_person(data['applicant']):
            data_changed = True
        
        # Check for single 'co-applicant'
        if 'co-applicant' in data and update_person(data['co-applicant']):
            data_changed = True

        # Check for list of 'applicants'
        if 'applicants' in data and isinstance(data['applicants'], list):
            for person in data['applicants']:
                if update_person(person):
                    data_changed = True

        # Check for list of 'co-applicants'
        if 'co-applicants' in data and isinstance(data['co-applicants'], list):
            for person in data['co-applicants']:
                if update_person(person):
                    data_changed = True
        
        # --- Save the file if any data was changed ---
        if data_changed:
            with open(file_path, 'w') as f:
                json.dump(data, f, indent=2)
            print(f"  [SUCCESS] Updated DOBs in {file_path.name}")
        else:
            print(f"  [INFO] No DOBs found or updated in {file_file.name}")

    except json.JSONDecodeError:
        print(f"  [ERROR] Failed to read {file_path.name}. Invalid JSON.")
    except Exception as e:
        print(f"  [ERROR] An unknown error occurred with {file_path.name}: {e}")


def main():
    """
    Main function to check the date and trigger the update process.
    """
    today = datetime.date.today()
    print(f"--- Running DOB Update Script on {today} ---")
    
    if today.day == TRIGGER_DAY:
        print(f"[TRIGGER] Today is the {TRIGGER_DAY}rd. Starting update process...")
        
        if not INPUT_DIR.is_dir():
            print(f"[ERROR] Input directory not found: {INPUT_DIR}")
            return

        # Find all .json files in the input directory
        json_files = list(INPUT_DIR.glob("*.json"))
        if not json_files:
            print("[WARN] No .json files found in the input directory.")
            return

        for file_path in json_files:
            process_json_file(file_path)
        
        print("\n--- Update process complete. ---")
        
    else:
        print(f"[INFO] Not the {TRIGGER_DAY}rd of the month. No updates will be made.")
        print("--- Script finished. ---")

if __name__ == "__main__":
    main()