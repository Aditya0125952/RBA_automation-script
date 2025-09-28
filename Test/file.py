import json

# --- Configuration ---
FILENAME = "InputData/GL_applicants_list.json"
NEW_EMAIL = "aditya.chelluru@finmkt.io"


def update_json_file_in_place():
    """
    Reads a JSON object from a file, processes the list of applicants
    inside it, and overwrites the original file with the updated object.
    """
    try:
        # Step 1: Read the entire JSON object from the file
        with open(FILENAME, 'r') as file:
            data_object = json.load(file)

        # Access the list of applicants to process
        applicants_list = data_object.get("Applicants", [])
        print(f"Read {len(applicants_list)} applicants from '{FILENAME}'.")

        updated_applicants = []
        removed_count = 0

        # Step 2: Process the list of applicants
        for applicant in applicants_list:
            # Condition to KEEP an applicant
            if not (applicant.get("dob") == "" or applicant.get("ssn") == "000000000" or applicant.get("city")==""):
                # Update the email for the applicants we are keeping
                # This field does not exist in your example, but the logic is here if needed.
                applicant["email"] = NEW_EMAIL
                updated_applicants.append(applicant)
            else:
                removed_count += 1

        print(f"Processing complete. Kept {len(updated_applicants)} applicants, removed {removed_count}.")

        # Step 3: Put the updated list back into the main object
        data_object["Applicants"] = updated_applicants

        # Step 4: Re-open the SAME file in write mode ('w') and save the entire object
        with open(FILENAME, 'w') as file:
            json.dump(data_object, file, indent=4)

        print(f"Successfully updated and saved changes back to '{FILENAME}'.")

    except FileNotFoundError:
        print(f"[ERROR] The file '{FILENAME}' was not found.")
    except json.JSONDecodeError:
        print(f"[ERROR] Could not decode JSON. Please check the file format.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


if __name__ == "__main__":
    update_json_file_in_place()