import os
import zipfile
import urllib.request
import sys
import subprocess

# --- Configuration ---
NODE_VERSION = "v24.11.0"
NODE_FILENAME = f"node-{NODE_VERSION}-win-x64"
ZIP_FILE_NAME = f"{NODE_FILENAME}.zip"
NODE_URL = f"https://nodejs.org/dist/{NODE_VERSION}/{ZIP_FILE_NAME}"

TOOLS_DIR_NAME = "tools"

# --- Dynamic Paths ---
CWD = os.getcwd()
ZIP_FILE_PATH = os.path.join(CWD, ZIP_FILE_NAME)
TOOLS_DIR = os.path.join(CWD, TOOLS_DIR_NAME)
NODE_DIR_PATH = os.path.abspath(os.path.join(TOOLS_DIR, NODE_FILENAME))
PLAYWRIGHT_DIR = os.path.join(CWD, "PlayWright")

NODE_EXE = os.path.join(NODE_DIR_PATH, "node.exe")
NPM_CMD = os.path.join(NODE_DIR_PATH, "npm.cmd")
NPX_CMD = os.path.join(NODE_DIR_PATH, "npx.cmd")


def download_node_zip():
    if os.path.isfile(ZIP_FILE_PATH):
        print("✅ Node ZIP already exists.")
        return

    print("⬇ Downloading Node.js...")
    urllib.request.urlretrieve(NODE_URL, ZIP_FILE_PATH)
    print("✅ Download complete.")


def unzip_node():
    if os.path.isdir(NODE_DIR_PATH):
        print("✅ Node already extracted.")
        return

    os.makedirs(TOOLS_DIR, exist_ok=True)
    print("📦 Extracting Node...")
    with zipfile.ZipFile(ZIP_FILE_PATH, "r") as zip_ref:
        zip_ref.extractall(TOOLS_DIR)
    print("✅ Extraction complete.")


def install_playwright():
    print("📦 Installing npm dependencies...")
    subprocess.run([NPM_CMD, "install"], cwd=PLAYWRIGHT_DIR, check=True)

    print("🌍 Installing Playwright browsers...")
    subprocess.run([NPX_CMD, "playwright", "install", "chromium"], cwd=PLAYWRIGHT_DIR, check=True)

    print("✅ Playwright fully installed.")


def run_setup():
    print("🚀 Starting Automation Setup")

    download_node_zip()
    unzip_node()
    install_playwright()

    print("\n🎉 Setup Complete!")
    print("Now double-click run_tests.bat to execute tests.")


if __name__ == "__main__":
    run_setup()