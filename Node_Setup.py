import os
import zipfile
import urllib.request
import sys
import winreg
import ctypes
import subprocess

# ==============================
# CONFIGURATION
# ==============================

NODE_VERSION = "v20.11.1"  # Use stable LTS version
NODE_FILENAME = f"node-{NODE_VERSION}-win-x64"
ZIP_FILE_NAME = f"{NODE_FILENAME}.zip"
NODE_URL = f"https://nodejs.org/dist/{NODE_VERSION}/{ZIP_FILE_NAME}"

TOOLS_DIR_NAME = "tools"

# ==============================
# PATHS
# ==============================

CWD = os.getcwd()
ZIP_FILE_PATH = os.path.join(CWD, ZIP_FILE_NAME)
TOOLS_DIR = os.path.join(CWD, TOOLS_DIR_NAME)
NODE_DIR_PATH = os.path.abspath(os.path.join(TOOLS_DIR, NODE_FILENAME))


# ==============================
# REGISTRY FUNCTIONS
# ==============================

def get_user_path_from_registry():
    try:
        key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment", 0, winreg.KEY_READ)
        path_value, _ = winreg.QueryValueEx(key, "Path")
        winreg.CloseKey(key)
        return path_value
    except FileNotFoundError:
        return ""
    except Exception as e:
        print(f"Error reading registry: {e}")
        return None


def set_user_path_in_registry(new_path_string):
    try:
        key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment", 0, winreg.KEY_ALL_ACCESS)
        winreg.SetValueEx(key, "Path", 0, winreg.REG_EXPAND_SZ, new_path_string)
        winreg.CloseKey(key)

        # Notify Windows about environment change
        ctypes.windll.user32.SendMessageTimeoutW(
            0xFFFF, 0x001A, 0, "Environment", 0x0002, 5000
        )
        return True
    except Exception as e:
        print(f"ERROR: Failed to update PATH: {e}")
        return False


# ==============================
# DOWNLOAD & EXTRACT
# ==============================

def download_node_zip():
    if os.path.isfile(ZIP_FILE_PATH):
        print(f"✅ Found existing {ZIP_FILE_NAME}")
        return

    print(f"⬇ Downloading Node.js from {NODE_URL}")
    try:
        urllib.request.urlretrieve(NODE_URL, ZIP_FILE_PATH)
        print("✅ Download complete")
    except Exception as e:
        print(f"❌ Download failed: {e}")
        sys.exit(1)


def unzip_node():
    if os.path.isdir(NODE_DIR_PATH):
        print("✅ Node already extracted")
        return

    os.makedirs(TOOLS_DIR, exist_ok=True)

    print("📦 Extracting Node...")
    try:
        with zipfile.ZipFile(ZIP_FILE_PATH, "r") as zip_ref:
            zip_ref.extractall(TOOLS_DIR)
        print("✅ Extraction complete")
    except Exception as e:
        print(f"❌ Extraction failed: {e}")
        sys.exit(1)


# ==============================
# PATH UPDATE
# ==============================

def add_node_to_path():
    print("🔍 Checking PATH...")

    current_path = get_user_path_from_registry()
    if current_path is None:
        sys.exit(1)

    paths = current_path.split(os.pathsep)
    normalized_new_path = os.path.normcase(NODE_DIR_PATH)

    if any(os.path.normcase(p.strip()) == normalized_new_path for p in paths):
        print("✅ Node already in PATH")
        return

    new_path = current_path + os.pathsep + NODE_DIR_PATH

    if not set_user_path_in_registry(new_path):
        sys.exit(1)

    print("✅ PATH updated successfully")


# ==============================
# COMMAND RUNNER
# ==============================

def run_command(command, cwd=None):
    try:
        print(f"\n▶ Running: {command}")
        subprocess.run(command, shell=True, check=True, cwd=cwd)
        print("✅ Success")
    except subprocess.CalledProcessError as e:
        print(f"❌ Command failed: {e}")
        sys.exit(1)


# ==============================
# MAIN SETUP
# ==============================

def run_setup():
    print("======================================")
    print(" Node.js + Playwright Auto Setup ")
    print("======================================")

    download_node_zip()
    unzip_node()
    add_node_to_path()

    # IMPORTANT: Update PATH for current process
    os.environ["PATH"] += os.pathsep + NODE_DIR_PATH

    print("\n🔎 Verifying Node installation...")
    run_command("node -v")
    run_command("npm -v")

    # Initialize npm project if not exists
    if not os.path.exists(os.path.join(CWD, "package.json")):
        print("\n📁 Initializing npm project...")
        run_command("npm init -y", cwd=CWD)

    # Install Playwright
    print("\n📦 Installing Playwright...")
    run_command("npm install playwright", cwd=CWD)

    # Install browsers
    print("\n🌐 Installing Playwright browsers...")
    run_command("npx playwright install", cwd=CWD)

    print("\n🚀 Playwright setup completed successfully!")
    print("You can now run your Playwright scripts.")


if __name__ == "__main__":
    run_setup()