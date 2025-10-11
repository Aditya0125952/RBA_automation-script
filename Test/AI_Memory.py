# build_knowledge_base.py
from pathlib import Path
from langchain_community.document_loaders import TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings

# The main folder containing your code files
SOURCE_DIRECTORY = "."
# The name of the folder where the AI's 'memory' will be saved
INDEX_NAME = "project_knowledge_base"

def build_kb():
    """Scans your project and builds a searchable 'memory' (vector store) for the AI."""
    print(f"Scanning for .py and .robot files in '{SOURCE_DIRECTORY}'...")
    
    # Find all .py and .robot files, excluding the virtual environment
    all_files = list(Path(SOURCE_DIRECTORY).glob("**/*.py")) + list(Path(SOURCE_DIRECTORY).glob("**/*.robot"))
    filtered_files = [path for path in all_files if '.venv' not in path.parts]
    
    if not filtered_files:
        print("No .py or .robot script files found (outside of .venv). Aborting.")
        return

    print(f"Found {len(filtered_files)} relevant files. Loading their content...")
    
    documents = []
    for fp in filtered_files:
        try:
            loader = TextLoader(str(fp), encoding='utf-8', autodetect_encoding=True)
            documents.extend(loader.load())
        except Exception as e:
            print(f"Warning: Skipping file {fp} due to error: {e}")

    # Split the file contents into smaller, manageable chunks
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    chunked_docs = text_splitter.split_documents(documents)
    print(f"Split content into {len(chunked_docs)} chunks.")

    # Load the model that turns text into searchable vectors
    print("Creating text embeddings (this may download a model on the first run)...")
    embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")

    # Build the vector store from the chunks and save it to your disk
    print("Building and saving the knowledge base...")
    db = FAISS.from_documents(chunked_docs, embeddings)
    db.save_local(INDEX_NAME)
    
    print(f"\n✅ Success! Your AI's 'memory' is saved in the '{INDEX_NAME}' folder.")

if __name__ == "__main__":
    build_kb()