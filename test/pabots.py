# Save this as the updated pabots.py

import argparse
import subprocess
from pathlib import Path
import sys

# --- Configuration ---
SCRIPT_DIR = Path(__file__).resolve().parent
TEST_BASE_DIR = SCRIPT_DIR / "Lenders"


def discover_tests(base_dir: Path) -> dict:
    if not base_dir.is_dir():
        return {}
    all_tests = {}
    for category_path in base_dir.iterdir():
        if category_path.is_dir():
            category_name = category_path.name
            all_tests[category_name] = {}
            for test_file in category_path.glob("*.robot"):
                lender_code = test_file.stem.upper()
                all_tests[category_name][lender_code] = {"suite": str(test_file)}
    return all_tests


def run_parallel_tests(tests_to_run: list, process_count: int, test_name: str or None, instance: str or None):
    if not tests_to_run:
        print("\n[WARNING] No matching test suites found to execute.")
        return
    print(f"\n[INFO] Starting {process_count} parallel run(s) for {len(tests_to_run)} suite(s)...")
    processes, output_files = [], []
    for test_item in tests_to_run:
        suite_path = Path(test_item['suite_path'])
        category_name = test_item['category']
        suite_name = suite_path.stem
        for i in range(1, process_count + 1):
            output_file = f"{category_name}_{suite_name}_output_{i}.xml"
            output_files.append(output_file)
            # UPDATED: Added --log NONE and --report NONE to individual runs to reduce clutter
            command = [sys.executable, "-m", "robot", "--log", "NONE", "--report", "NONE", "--output", output_file]
            if test_name:
                command.extend(["--test", test_name])
            if instance:
                command.extend(["--variable", f"INSTANCE:{instance}"])
            command.append(str(suite_path))
            print(f"    -> Starting run {i} for {category_name}/{suite_name} on instance {instance or 'default'}...")
            p = subprocess.Popen(command)
            processes.append(p)

    print(f"\n[INFO] Waiting for all {len(processes)} test runs to complete...")
    for p in processes:
        p.wait()
    print("[INFO] All test runs have finished.")

    if output_files:
        print("\n[INFO] Merging results into a single report...")
        try:
            merge_command = [sys.executable, "-m", "rebot", "--name", "Merged Test Results"] + output_files
            subprocess.run(merge_command, check=True)
            print("[SUCCESS] Merged log.html and report.html created successfully.")

            # NEW: Automatically clean up the intermediate XML files
            print("[INFO] Cleaning up intermediate output files...")
            for file_path in output_files:
                try:
                    Path(file_path).unlink()
                except OSError as e:
                    print(f"    [WARN] Could not delete file {file_path}: {e}")
            print("[INFO] Cleanup complete.")

        except subprocess.CalledProcessError:
            print("[ERROR] Failed to merge reports with rebot.")


def main():
    AVAILABLE_TESTS = discover_tests(TEST_BASE_DIR)
    print("[INFO] Test Executor Script Started...")
    test_categories = list(AVAILABLE_TESTS.keys())
    parser = argparse.ArgumentParser(description="Runs Robot Framework tests based on specific arguments.")
    parser.add_argument("category", choices=test_categories + ['ALL'], type=str)
    parser.add_argument("--runs", type=int, default=1)
    parser.add_argument("--lender", type=str.upper)
    parser.add_argument("--test", type=str)
    parser.add_argument("--instance", type=str, help="The instance to run the test against (e.g., rba2, rba6).")
    args = parser.parse_args()
    tests_to_execute = []
    categories_to_search = test_categories if args.category == 'ALL' else [args.category]
    for category_name in categories_to_search:
        tests_in_category = AVAILABLE_TESTS.get(category_name, {})
        if args.lender:
            if args.lender in tests_in_category:
                tests_to_execute.append(
                    {'category': category_name, 'suite_path': tests_in_category[args.lender]['suite']})
        else:
            for test_info in tests_in_category.values():
                tests_to_execute.append({'category': category_name, 'suite_path': test_info['suite']})
    run_parallel_tests(tests_to_run=tests_to_execute, process_count=args.runs, test_name=args.test,
                       instance=args.instance)


if __name__ == "__main__":
    main()