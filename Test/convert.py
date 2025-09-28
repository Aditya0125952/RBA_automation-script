import json

# Load the original JSON file
with open("InputData/GL_applicants_list.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# Check if Applicants list exists and is not empty
if "Applicants" in data and isinstance(data["Applicants"], list):
    for applicant in data["Applicants"]:
        if "dob" in applicant and isinstance(applicant["dob"], str):
            dob_parts = applicant["dob"].split("/")
            if len(dob_parts) == 3:
                dob_parts[0] = "04"  # change month to March
                applicant["dob"] = "/".join(dob_parts)

# Save updated file
with open("InputData/GL_applicants_list.json", "w", encoding="utf-8") as f:
    json.dump(data, f, indent=4)

print("✅ DOB month updated where applicable.")
