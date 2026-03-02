import os
import zipfile
import urllib.request
import sys
import winreg
import ctypes

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


def get_user_path_from_registry():
    """Read user PATH from registry."""
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
    """Write user PATH to registry (no admin required)."""
    try:
        key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment", 0, winreg.KEY_ALL_ACCESS)
        winreg.SetValueEx(key, "Path", 0, winreg.REG_EXPAND_SZ, new_path_string)
        winreg.CloseKey(key)

        # Broadcast environment change
        ctypes.windll.user32.SendMessageTimeoutW(
            0xFFFF, 0x001A, 0, "Environment", 0x0002, 5000
        )
        return True
    except Exception as e:
        print(f"--- ERROR ---\nFailed to write to registry: {e}")
        print("Try running your terminal as Administrator and rerun the script.")
        return False


def download_node_zip():
    """Download Node.js portable ZIP if not already present."""
    if os.path.isfile(ZIP_FILE_PATH):
        print(f"✅ Found existing {ZIP_FILE_NAME}")
        return

    print(f"⬇️  Downloading Node.js from {NODE_URL} ...")
    try:
        urllib.request.urlretrieve(NODE_URL, ZIP_FILE_PATH)
        print(f"✅ Download complete: {ZIP_FILE_NAME}")
    except Exception as e:
        print(f"❌ ERROR: Failed to download Node.js. {e}")
        sys.exit(1)


def unzip_node():
    """Unzip the Node.js portable archive."""
    if os.path.isdir(NODE_DIR_PATH):
        print(f"✅ Node.js already extracted at {NODE_DIR_PATH}")
        return

    if not os.path.isfile(ZIP_FILE_PATH):
        print(f"❌ Missing ZIP: {ZIP_FILE_PATH}")
        sys.exit(1)

    os.makedirs(TOOLS_DIR, exist_ok=True)
    print(f"📦 Extracting Node.js to {TOOLS_DIR} ...")
    try:
        with zipfile.ZipFile(ZIP_FILE_PATH, "r") as zip_ref:
            zip_ref.extractall(TOOLS_DIR)
        print("✅ Extraction complete.")
    except Exception as e:
        print(f"❌ ERROR: Failed to unzip Node.js. {e}")
        sys.exit(1)


def add_node_to_path():
    """Add Node.js path to user PATH."""
    print(f"🔍 Checking if {NODE_DIR_PATH} is in PATH...")

    current_path_string = get_user_path_from_registry()
    if current_path_string is None:
        sys.exit(1)

    current_paths = current_path_string.split(os.pathsep)
    normalized_new_path = os.path.normcase(NODE_DIR_PATH)

    if any(os.path.normcase(p.strip()) == normalized_new_path for p in current_paths):
        print("✅ Node.js path already in PATH.")
        return

    print("➕ Adding Node.js to PATH...")
    new_path_string = f"{current_path_string};{NODE_DIR_PATH}"

    if not set_user_path_in_registry(new_path_string):
        sys.exit(1)

    print("✅ PATH updated successfully!")


def run_setup():
    """Main function."""
    print("--- Starting Node.js setup ---")

    download_node_zip()
    unzip_node()
    add_node_to_path()

    print("\n🎉 Setup complete!")
    print("Please CLOSE and REOPEN your terminal or VS Code.")
    print("Then verify with:")
    print("  node -v")
    print("  npm -v")
    print("Please run this command : rfbrowser init")
    print("Please run this command : npm install dotenv")


if __name__ == "__main__":
    run_setup()
