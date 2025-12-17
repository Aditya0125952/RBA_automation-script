# Save this as create_knowledge_base.py
import sys
from pathlib import Path
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from colorama import init, Fore, Style

# --- Configuration ---
init(autoreset=True)
# This will search for .robot files inside the 'Lenders' and 'common_pages' folders
ROBOT_FOLDERS_TO_INDEX = ["Lenders", "common_pages"]
EMBEDDING_MODEL_ID = "all-MiniLM-L6-v2"
INDEX_NAME = "project_knowledge_base"
# ---------------------

def main():
    print("🧠 Starting to build the project knowledge base...")
    
    all_robot_files = []
    for folder in ROBOT_FOLDERS_TO_INDEX:
        folder_path = Path(folder)
        if not folder_path.is_dir():
            print(f"{Fore.YELLOW}Warning: Directory not found, skipping: {folder}{Style.RESET_ALL}")
            continue
        
        files_found = list(folder_path.rglob("*.robot"))
        print(f"   - Found {len(files_found)} .robot files in '{folder}'")
        all_robot_files.extend(files_found)

    if not all_robot_files:
        print(f"{Fore.RED}❌ Error: No .robot files were found in the specified directories. Aborting.")
        sys.exit(1)

    print(f"\n   - Loading content from {len(all_robot_files)} files...")
    all_documents = []
    for file_path in all_robot_files:
        try:
            loader = TextLoader(str(file_path), encoding='utf-8')
            all_documents.extend(loader.load())
        except Exception as e:
            print(f"{Fore.YELLOW}Warning: Could not load file {file_path}: {e}{Style.RESET_ALL}")

    print("   - Splitting documents into chunks...")
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    docs = text_splitter.split_documents(all_documents)

    print(f"   - Embedding {len(docs)} text chunks... (This may take a moment)")
    embeddings = HuggingFaceEmbeddings(model_name=EMBEDDING_MODEL_ID)
    
    db = FAISS.from_documents(docs, embeddings)

    print(f"   - Saving knowledge base to disk as '{INDEX_NAME}'")
    db.save_local(INDEX_NAME)
    
    print(f"\n{Fore.GREEN}✅ Success! The knowledge base is built and ready.{Style.RESET_ALL}")

if __name__ == "__main__":
    main()