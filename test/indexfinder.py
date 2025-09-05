import json

# --- Configuration ---
file_path = 'C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/GL_applicants_list.json'  # 👈 Replace with your file's name
list_key = 'Applicants'
search_key = 'street_add'  # 👈 The field to search for (e.g., 'email', '_id')
search_value = '1812 ELECTRA Avenue'  # 👈 The value to find

# --- Script ---
found_record_details = {}
state_counts = {}

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    records = data[list_key]
    found_record = None
    found_index = -1

    # First, find the specific record and its index
    for index, record in enumerate(records):
        if record.get(search_key) == search_value:
            found_record = record
            found_index = index
            break  # Stop after finding the first match

    # --- Output the results ---
    if found_record:
        found_state = found_record.get('stateName')  # Assuming the state field is 'stateName'

        # Now, count all records with that same state
        state_count = sum(1 for r in records if r.get('stateName') == found_state)

        print(f"✅ Record Found!")
        print(f"   - Index Number in list: {found_index}")
        print(f"   - State Name: {found_state}")
        print(f"   - Total records with state '{found_state}': {state_count}")
    else:
        print(f"❌ Record with '{search_key}: {search_value}' not found in the list '{list_key}'.")

except FileNotFoundError:
    print(f"❌ Error: The file '{file_path}' was not found.")
except KeyError:
    print(f"❌ Error: The key '{list_key}' was not found in the JSON file.")