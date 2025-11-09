import csv
import json

STATE_MAPPING = {
    'AL': 'Alabama', 'AK': 'Alaska', 'AZ': 'Arizona', 'AR': 'Arkansas', 'CA': 'California',
    'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware', 'FL': 'Florida', 'GA': 'Georgia',
    'HI': 'Hawaii', 'ID': 'Idaho', 'IL': 'Illinois', 'IN': 'Indiana', 'IA': 'Iowa',
    'KS': 'Kansas', 'KY': 'Kentucky', 'LA': 'Louisiana', 'ME': 'Maine', 'MD': 'Maryland',
    'MA': 'Massachusetts', 'MI': 'Michigan', 'MN': 'Minnesota', 'MS': 'Mississippi', 'MO': 'Missouri',
    'MT': 'Montana', 'NE': 'Nebraska', 'NV': 'Nevada', 'NH': 'New Hampshire', 'NJ': 'New Jersey',
    'NM': 'New Mexico', 'NY': 'New York', 'NC': 'North Carolina', 'ND': 'North Dakota',
    'OH': 'Ohio', 'OK': 'Oklahoma', 'OR': 'Oregon', 'PA': 'Pennsylvania', 'RI': 'Rhode Island',
    'SC': 'South Carolina', 'SD': 'South Dakota', 'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah',
    'VT': 'Vermont', 'VA': 'Virginia', 'WA': 'Washington', 'WV': 'West Virginia', 'WI': 'Wisconsin',
    'WY': 'Wyoming'
}
def readCSVwriteJson (csv_file_path,json_file_path):


    # Create dictionary with column names as keys and first row data as values
    with open(csv_file_path, 'r') as csv_file:
        csv_reader = csv.reader(csv_file)
        headers = next(csv_reader)  # Get the headers (column names)
        first_row_data = next(csv_reader)  # Get the data from the first row
        second_row_data = next(csv_reader) # Get the data from the first row

        # Remove trailing and leading spaces from keys and values
        data_dict_Applicant = {header.strip(): value.strip() for header, value in zip(headers, first_row_data)}
        data_dict_CoApplicant = {header.strip(): value.strip() for header, value in zip(headers, second_row_data)}
        
        
        # house = data_dict_Applicant['House']
        streetname_sheet = data_dict_Applicant['Street Name']
        # streetname_app = house + ' ' + streetname_sheet
        streetname_app = streetname_sheet
        city_app = data_dict_Applicant['City']
        state_app = data_dict_Applicant['State']
        if state_app == 'CA':
            state_app = 'California'
        zipcode_full = data_dict_Applicant['Zip Code']
        split_zipcode = zipcode_full.split('-')
        zipcode_app = split_zipcode[0]
        dob_sheet = data_dict_Applicant['DOB']
        year_dob = dob_sheet[0:4]
        year = int(year_dob) + 5
        dob_app = f'12/01/{year}'
        

        # Applicant data
        applicant_data = {
            'FirstName': data_dict_Applicant['First Name'],
            'LastName': data_dict_Applicant['Last Name'],
            'street_add': streetname_app,
            'city': city_app,
            'state': state_app,
            'zipcode': zipcode_app,
            'Do_you_own_installation_add': 'Yes, I own this property.',
            'Do_you_reside_installation_add': 'Yes, I reside at this address.',
            'mobileNumber': '8888888888',
            'employment_status': 'Employed',
            'occupation': 'business',
            'employer_name': 'ganesh',
            'monthly_mortgage_amount': '500',
            'annual_income': '155000',
            'household_income': '155000',
            'ssn': data_dict_Applicant['SSN'],
            'dob': dob_app,
            'citizenship_status': 'US Citizen'
        }

        # house = data_dict_CoApplicant['House']
        streetname_sheet = data_dict_CoApplicant['Street Name']
        # streetname_Coapp = house + ' ' + streetname_sheet
        streetname_Coapp = streetname_sheet
        city_Coapp = data_dict_CoApplicant['City']
        state_Coapp = data_dict_CoApplicant['State']
        if state_Coapp == 'CA':
            state_Coapp = 'California'
        zipcode_full = data_dict_CoApplicant['Zip Code']
        split_zipcode = zipcode_full.split('-')
        zipcode_Coapp = split_zipcode[0]
        dob_sheet = data_dict_CoApplicant['DOB']
        year_dob = dob_sheet[0:4]
        year = int(year_dob) + 5
        dob_Coapp = f'12/01/{year}'
         
        # Co-Applicant data
        coapplicant_data = {
            'FirstName': data_dict_CoApplicant['First Name'],
            'LastName': data_dict_CoApplicant['Last Name'],
            'street_add': streetname_Coapp,
            'city': city_Coapp,
            'state': state_Coapp,
            'zipcode': zipcode_Coapp,
            'Do_you_own_installation_add': 'Yes, I own this property.',
            'Do_you_reside_installation_add': 'Yes, I reside at this address.',
            'mobileNumber': '6666666987',
            'employment_status': 'Employed',
            'occupation': 'business',
            'employer_name': 'ganesh',
            'monthly_mortgage_amount': '200',
            'annual_income': '145000',
            'household_income': '145000',
            'ssn': data_dict_CoApplicant['SSN'],
            'dob': dob_Coapp,
            'citizenship_status': 'US Citizen'
        
        }

        data_dict_new = {
            "planID" : "S100617",
            "projectCost" : "15000",
            "depositAmount" : "2000",
            "Applicant": applicant_data,
            "Co-Applicant": coapplicant_data,
            "Agretha_Chene": {
                "mobileNumber": "2001001687",
                "ssn": "369956933"
            },
            "Johnnie_Lammiman": {
                "mobileNumber": "2001004004",
                "ssn": "111258802"
            },
            "Sebastian_Limmer": {
                "mobileNumber": "2001004001",
                "ssn": "347465324"
            }
        }

    with open(json_file_path, 'w') as json_file:
        json_file.truncate(0)  # Clear the contents of the file

    # Append dictionary data to JSON file
    with open(json_file_path, 'w') as json_file:
        print("I am here")
        json.dump(data_dict_new, json_file, indent=4)  # Indent for better readability


def delete_first_row_csv(csv_file_path):
    second_row_before_deletion = None
    second_row_after_deletion = None
    # Read the CSV file into a list of rows
    with open(csv_file_path, 'r', newline='', encoding='utf-8') as csv_file:
        csv_reader = csv.reader(csv_file)
        rows = list(csv_reader)

    # Store the header separately
    header = rows[0]
    second_row_before_deletion = rows[1]
    print("second_row_before_deletion : ",second_row_before_deletion)

    # Rewrite the CSV file excluding the first row but keeping the header
    with open(csv_file_path, 'w', newline='', encoding='utf-8') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(header)  # Write the header back
        csv_writer.writerows(rows[2:])
        print("delete first row")

    with open(csv_file_path, 'r', newline='', encoding='utf-8') as csv_file:
        csv_reader = csv.reader(csv_file)
        rows = list(csv_reader)
        second_row_after_deletion = rows[1]
        print("second_row_after_deletion : ",second_row_after_deletion)



def delete_first_two_rows_csv(csv_file_path):
    # Read the CSV file into a list of rows
    with open(csv_file_path, 'r', newline='', encoding='utf-8') as csv_file:
        csv_reader = csv.reader(csv_file)
        rows = list(csv_reader)

    # Store the header separately
    header = rows[0]

    # Rewrite the CSV file excluding the first two rows but keeping the header
    with open(csv_file_path, 'w', newline='', encoding='utf-8') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(header)  # Write the header back
        csv_writer.writerows(rows[3:])  # Write the rest of the rows
        print("delete first two rows")


def UG_readCSVwriteJson(csv_file_path, json_file_path):
    with open(csv_file_path, 'r', newline='', encoding='utf-8') as csv_file:
        csv_reader = csv.reader(csv_file)

        headers = next(csv_reader)  # Read column headers
        headers = [h.strip() for h in headers if h.strip()]  # Remove empty headers and strip spaces

        first_row_data = next(csv_reader, None)  # Read first row of data
        if not first_row_data:
            raise ValueError("CSV file is empty or missing required data.")

        # Map headers to their respective values and strip spaces
        data_dict_Applicant = {header: value.strip() for header, value in zip(headers, first_row_data)}

        # Extract required fields
        first_name = data_dict_Applicant.get('First Name', '')
        last_name = data_dict_Applicant.get('Last Name', '')
        streetname_app = data_dict_Applicant.get('Street Name', '')
        city_app = data_dict_Applicant.get('City', '')
        state_app = data_dict_Applicant.get('State', '')

        # Convert state abbreviation to full name
        state_app = STATE_MAPPING.get(state_app, state_app)  # Default to abbreviation if not found

        zipcode_full = data_dict_Applicant.get('Zip Code', '')
        zipcode_app = zipcode_full.split('-')[0] if zipcode_full else ''

        # Convert DOB from YYYYMMDD to MM/DD/YYYY
        dob_sheet = data_dict_Applicant['DOB']
        year_dob = dob_sheet[0:4]
        year = int(year_dob) + 5
        dob_app = f'12/01/{year}'

        # Construct JSON data
        data_dict_new = {
            "planID": "S100617-UG-AUT",
            "projectCost": "20000",
            "depositAmount": "2000",
            "Applicant": {
                'FirstName': first_name,
                'LastName': last_name,
                'street_add': streetname_app,
                'city': city_app,
                'state': state_app,
                'zipcode': zipcode_app,
                'Do_you_own_installation_add': 'Yes, I own this property.',
                'Do_you_reside_installation_add': 'Yes, I reside at this address.',
                'mobileNumber': '8888888888',
                'employment_status': 'Employed',
                'occupation': 'Business',
                'employer_name': 'Ganesh',
                'monthly_mortgage_amount': '500',
                'annual_income': '155000',
                'household_income': '155000',
                'ssn': data_dict_Applicant.get('SSN', ''),
                'dob': dob_app,
                'citizenship_status': 'US Citizen'
            },
            "Agretha_Chene": {
                "mobileNumber": "2001001687",
                "ssn": "369956933"
            },
            "Johnnie_Lammiman": {
                "mobileNumber": "2001004004",
                "ssn": "111258802"
            },
            "Sebastian_Limmer": {
                "mobileNumber": "2001004001",
                "ssn": "347465324"
            }
        }

    # Write JSON file
    with open(json_file_path, 'w', encoding='utf-8') as json_file:
        json.dump(data_dict_new, json_file, indent=4)

    print(f"JSON file saved at {json_file_path}")





