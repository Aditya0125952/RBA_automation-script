import argparse
import subprocess
import sys

LENDER_DATA = {
    "FFC": {
        "suite": "C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/Lenders/Single_Applicant/FFC.robot",
        "case": "FFC HappyCase"
    },
    "PP": {
        "suite": "C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/Lenders/Single_Applicant/PP.robot",
        "case": "PowerPay Happy Flow"
    },
    "GL": {
        "suite": "C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/Lenders/Single_Applicant/GL.robot",
        "case": "Good Leap HappyCase"
    },
    "GICU": {
        "suite": "C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/Lenders/Single_Applicant/GICU.robot",
        "case": "GICU Happycase"
    },
    "SL": {
        "suite": "C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/Lenders/Single_Applicant/Sunlight.robot",
        "case": "Sunlight HappyCase"
    },
    "CSI":{
        "suite": "C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/Lenders/Pending_Cases/CSI_pend.robot",
        "case": "CSI Pending - Applicant"
    },
    "FFCCO":{
        "suite": "C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/Lenders/Co-Applicant/FFC.robot",
        "case": "FFC HappyCase"
    }
}

def run_tests(lender_code, process_count):
    """Launches parallel Robot Framework tests for a given lender."""
    
    print(f"\n[INFO] Starting {process_count} parallel runs for lender: {lender_code}...")
    
    # Get the test suite and case name from our dictionary
    lender_info = LENDER_DATA[lender_code]
    test_suite = lender_info["suite"]
    test_case = lender_info["case"]

    for i in range(1, process_count + 1):
        output_file = f"{lender_code}_output_{i}.xml"
        
        # Build the command as a list of arguments. This is a best practice.
        command = [
            "robot",
            "--test", test_case,
            "--output", output_file,
            test_suite
        ]
        
        print(f"    -> Starting run {i}...")
        # subprocess.Popen launches the command in a new process and does not wait,
        # achieving the same parallel execution as "start /B".
        subprocess.Popen(command, shell=True)

    print(f"\nAll {process_count} runs for {lender_code} have been started in the background.")


if __name__ == "__main__":
    # Using argparse for robust command-line argument handling
    parser = argparse.ArgumentParser(description="Run Robot Framework tests for specified lenders in parallel.")
    
    # Create a list of choices for the lender argument, including 'ALL'
    lender_choices = list(LENDER_DATA.keys()) + ['ALL']
    
    parser.add_argument(
        "lender_code",
        help="The lender shortcut code (e.g., FFC) or 'ALL' to run all lenders.",
        choices=lender_choices,
        type=str.upper  # Automatically convert input to uppercase
    )
    parser.add_argument(
        "runs",
        type=int,
        nargs='?',  # Make the number of runs optional
        default=1,  # Default to 1 run if not specified
        help="The number of parallel processes to run."
    )
    
    args = parser.parse_args()

    if args.lender_code == "ALL":
        # If 'ALL' is specified, loop through every lender in our data
        for code in LENDER_DATA:
            run_tests(lender_code=code, process_count=args.runs)
    else:
        # Otherwise, just run the single specified lender
        run_tests(lender_code=args.lender_code, process_count=args.runs)