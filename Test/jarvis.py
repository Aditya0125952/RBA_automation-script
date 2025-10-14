# Save this as jarvis.py
import argparse
import json
import subprocess
import sys
import torch
from transformers import pipeline
from pathlib import Path
import xml.etree.ElementTree as ET
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from colorama import init, Fore, Style
import logging
import threading
import time
import itertools

# --- Setup ---
init(autoreset=True)
logging.getLogger("transformers").setLevel(logging.ERROR)
MODEL_ID = "Qwen/Qwen2-1.5B-Instruct"
EMBEDDING_MODEL_ID = "all-MiniLM-L6-v2"
INDEX_NAME = "project_knowledge_base"

# --- Animation Logic (This was missing) ---
done = False
def animate():
    for c in itertools.cycle(['.', '..', '...']):
        if done: break
        sys.stdout.write(f"\r{Fore.CYAN}🤖 Jarvis is thinking{c}   {Style.RESET_ALL}")
        sys.stdout.flush(); time.sleep(0.5)
    sys.stdout.write('\r' + ' ' * 40 + '\r'); sys.stdout.flush()

def run_with_animation(func, *args, **kwargs):
    global done; done = False
    animation_thread = threading.Thread(target=animate); animation_thread.start()
    result = func(*args, **kwargs)
    done = True; animation_thread.join()
    return result
# ----------------------------------------

# --- Handler Functions ---
def execute_automation(params: dict):
    # This function needs to be fully implemented with your pabots.py logic
    print(f"\n{Fore.GREEN}✅ Jarvis (Operator): Understood. Preparing automation command...{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}   (Full operator logic would run here with params: {params})")

# --- CORRECTED FUNCTION SIGNATURE ---
def handle_debugging(params: dict, pipe, retriever):
    """Analyzes a failed test run using a hyper-focused RAG prompt."""
    prompt = params.get("query") # Extract the prompt from the parameters dictionary
    print(f"\n{Fore.GREEN}✅ Jarvis (Debugger): Understood. Pinpointing the exact source of the failure...{Style.RESET_ALL}")
    
    try:
        log_files = list(Path('.').glob('output.xml')) + list(Path('Test').glob('output.xml'))
        if not log_files: raise FileNotFoundError("No 'output.xml' file found.")
        
        latest_log = max(log_files, key=lambda p: p.stat().st_mtime)
        print(f"   - Analyzing log file: {latest_log}")
        error_snippet = ET.parse(latest_log).getroot().find('.//status[@status="FAIL"]').text
        if not error_snippet: raise ValueError("No failure message found in log.")
    except Exception as e:
        print(f"{Fore.RED}❌ Jarvis: Could not read a failure from the log file: {e}"); return

    print("   - Searching knowledge base for relevant code...")
    search_query = f"{prompt}\n\nError message: {error_snippet}"
    relevant_docs = retriever.invoke(search_query)
    context = "\n\n".join([f"--- From file: {doc.metadata['source']} ---\n{doc.page_content}" for doc in relevant_docs])

    system_prompt_debugger = """
    You are an expert code debugger... (Your hyper-focused prompt goes here)
    """
    user_prompt_debugger = f"**Error Message:**\n{error_snippet}\n\n**Relevant Code Snippets:**\n{context}"
    messages = [{"role": "system", "content": system_prompt_debugger}, {"role": "user", "content": user_prompt_debugger}]
    
    outputs = run_with_animation(pipe, messages, max_new_tokens=400, do_sample=False)
    
    assistant_response = outputs[0]['generated_text'][-1]['content']
    print(f"\n{Style.BRIGHT}🤖 Jarvis says:{Style.RESET_ALL}")
    print(assistant_response)

# --- NEW FUNCTION: Test Case Generator ---
def generate_test_case(prompt: str, pipe, retriever):
    """Generates a new Robot Framework test case using a Chain of Thought RAG prompt."""
    print(f"\n{Fore.GREEN}✅ Jarvis (Generator): Understood. Generating new test case...{Style.RESET_ALL}")

    print("   - Searching knowledge base for relevant examples...")
    relevant_docs = retriever.invoke(prompt)
    context = "\n\n".join([f"--- From file: {doc.metadata['source']} ---\n{doc.page_content}" for doc in relevant_docs])

    # --- NEW, ADVANCED "CHAIN OF THOUGHT" PROMPT ---
    system_prompt_generator = """
    You are an expert Robot Framework test case writer. Your task is to analyze the user's request and the provided code examples to generate a new test case by following a strict chain of thought.

    **Your Chain of Thought (Internal Steps):**
    1.  **Identify the Template:** Look at the user's request to find which existing test case to use as a template (e.g., "like FFC"). Find this template in the 'Existing Code Examples'.
    2.  **Identify the Modification:** Analyze the user's request for the specific change they want to make (e.g., "add SSN screen before Personal Information page").
    3.  **Construct the New Test Case:** Mentally copy the template test case. Then, apply the modification by adding, removing, or reordering the keywords as requested.
    4.  **Format the Output:** Present the final, modified test case inside a `*** Test Cases ***` block. Ensure the test case is renamed appropriately for the new lender mentioned by the user.

    Your final output must be ONLY the `*** Test Cases ***` block. Do not provide explanations.
    """
    
    user_prompt_generator = f"""
    **Existing Code Examples from the Project:**
    {context}

    **User's Request:**
    "{prompt}"

    Please follow your chain of thought and generate the new test case now.
    """
    
    messages = [{"role": "system", "content": system_prompt_generator}, {"role": "user", "content": user_prompt_generator}]
    
    outputs = run_with_animation(pipe, messages, max_new_tokens=500, do_sample=False)
    
    assistant_response = outputs[0]['generated_text'][-1]['content']
    print(f"\n{Style.BRIGHT}🤖 Jarvis says: Here is the generated test case for you:{Style.RESET_ALL}")
    print(assistant_response)

def main():
    """Main function to orchestrate the AI assistant."""
    parser = argparse.ArgumentParser(description="Jarvis: Your AI Automation Assistant.")
    parser.add_argument("prompt", type=str, help="Your request in plain English.")
    args = parser.parse_args()

    print("🧠 Initializing Jarvis...")
    print("   - Loading AI model...")
    pipe = pipeline("text-generation", model=MODEL_ID, trust_remote_code=True, torch_dtype="auto", device_map="auto")
    
    print("   - Loading project knowledge base (RAG)...")
    try:
        embeddings = HuggingFaceEmbeddings(model_name=EMBEDDING_MODEL_ID)
        db = FAISS.load_local(INDEX_NAME, embeddings, allow_dangerous_deserialization=True)
        # This is the updated line to make retrieval faster
        retriever = db.as_retriever(search_kwargs={'k': 2}) 
    except Exception as e:
        print(f"{Fore.RED}❌ Critical Error: Could not load the knowledge base: {e}"); sys.exit(1)

    print(f"{Fore.GREEN}✅ Jarvis is online and ready.{Style.RESET_ALL}")

    try:
        # This is the corrected, Python-based routing logic.
        prompt_lower = args.prompt.lower()
        if any(word in prompt_lower for word in ['failed', 'fails', 'error', 'debug', 'log']):
            handle_debugging(args.prompt, pipe, retriever)
        elif any(word in prompt_lower for word in ['run', 'execute', 'start']):
            execute_automation(args.prompt, pipe)
        elif any(word in prompt_lower for word in ['generate', 'create', 'write a test']):
            generate_test_case(args.prompt, pipe, retriever)
        else:
            # Fallback to a general conversation handler if you have one
            print(f"\n{Fore.YELLOW}🤔 Jarvis: I'm not sure what to do. Please try rephrasing your request to run, debug, or generate a test.")
            
        print(f"\n{Style.BRIGHT}✨ Task complete.{Style.RESET_ALL}")
    except Exception as e:
        print(f"\n{Fore.RED}❌ A critical error occurred: {e}")

if __name__ == "__main__":
    main()