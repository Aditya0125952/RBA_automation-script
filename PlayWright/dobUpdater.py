import json
import os

def update_dob(dob):
    """
    DOB format: MM/DD/YYYY
    Rules:
    - Increment month by 1
    - Keep day unchanged
    - If month == 12 → reset to 01 and increment year
    """
    try:
        month, day, year = dob.split("/")
        month = int(month)
        year = int(year)

        if month == 12:
            month = 1
            year += 1
        else:
            month += 1

        return f"{month:02d}/{day}/{year}"
    except Exception:
        return dob


def update_userpool_dob_inplace(file_path):
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    # Read JSON
    with open(file_path, "r") as file:
        data = json.load(file)

    # Users are under "Users"
    users = data.get("Users", {})

    for user_data in users.values():
        if isinstance(user_data, dict) and "dob" in user_data:
            user_data["dob"] = update_dob(user_data["dob"])

    # Write back to SAME file
    with open(file_path, "w") as file:
        json.dump(data, file, indent=2)

    print("✅ All DOBs have been updated successfully.")


if __name__ == "__main__":
    FILE_PATH = (
        "C:/Users/AdityaChelluru/Desktop/automation/"
        "RBA_automation-script/PlayWright/TestScenario/userpool.json"
    )

    update_userpool_dob_inplace(FILE_PATH)
