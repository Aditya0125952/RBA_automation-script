# Save this as jarvis.py
import argparse
import re  # <-- Added for the new generator logic
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

# --- Animation Logic ---
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
    """(Placeholder) Executes the pabots.py script with parsed parameters."""
    print(f"\n{Fore.GREEN}✅ Jarvis (Operator): Understood. Preparing automation command...{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}   (Full operator logic would run here with params: {params})")

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

# --- UPDATED FUNCTION: Test Case Generator ---
def generate_test_case(prompt: str, pipe, retriever):
    """Generates a new Robot Framework test case using a Chain of Thought RAG prompt."""
    print(f"\n{Fore.GREEN}✅ Jarvis (Generator): Understood. Generating new test case...{Style.RESET_ALL}")

    print("   - Searching knowledge base for relevant examples (RAG)...")
    
    print("     - Retrieving context for 'modification' (SSN rekyc)...")
    docs_from_full_prompt = retriever.invoke(prompt)

    template_docs = []
    # --- UPDATED REGEX: More flexible ---
    template_match = re.search(r"(like|same as|same like) (the )?([\w]+) flow", prompt, re.IGNORECASE)
    
    if template_match:
        template_name = template_match.group(3) # This will be "FFC"
        template_query = f"{template_name} happy flow"
        print(f"     - Retrieving context for 'template' ({template_name})...")
        template_docs = retriever.invoke(template_query)
    
    all_docs = docs_from_full_prompt + template_docs
    unique_docs = {doc.page_content: doc for doc in all_docs}.values()
    context = "\n\n".join([f"--- From file: {doc.metadata['source']} ---\n{doc.page_content}" for doc in unique_docs])

    system_prompt_generator = """
    You are an expert Robot Framework test case writer. Your task is to analyze the user's request and the provided code examples to generate a new test case by following a strict chain of thought.

    **Your Chain of Thought (Internal Steps):**
    1.  **Identify the Template:** Look at the user's request to find which existing test case to use as a template (e.g., "like FFC"). Find this template in the 'Existing Code Examples'.
    2.  **Identify the Modification:** Analyze the user's request for the specific change they want to make (e.g., "add SSN screen after the Personal Information page").
    3.  **Identify Modification Context:** Look for keywords related to the modification (e.g., "SSN Re-Kyc Screen") in the 'Existing Code Examples' to see how it's implemented.
    4.  **Construct the New Test Case:** a. Mentally copy the template test case (from step 1).
        b. Rename the test case to match the new lender (e.g., "LPU").
        c. Apply the modification (from step 2) using the keywords from the context (from step 3).
    5.  **Format the Output:** Present the final, modified test case inside a `*** Test Cases ***` block.

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
    
    generation_args = {
        "max_new_tokens": 500,
        "do_sample": False
    }
    
    outputs = run_with_animation(pipe, messages, **generation_args)
    
    assistant_response = outputs[0]['generated_text'][-1]['content']
    print(f"\n{Style.BRIGHT}🤖 Jarvis says: Here is the generated test case for you:{Style.RESET_ALL}")
    print(assistant_response)
# --- NEW: Placeholder for Test Data Generation ---
def generate_test_data(prompt: str, pipe, retriever):
    """(Placeholder) Generates new JSON test data based on a prompt."""
    print(f"\n{Fore.GREEN}✅ Jarvis (Data Generator): Understood. Generating new test data...{Style.RESET_ALL}")
    
    # --- This is where you would build the full function ---
    # 1. Define a system_prompt_data_generator with your JSON schemas
    # 2. Call the LLM (pipe) with the prompt
    # 3. Parse the JSON response
    # 4. Ask the user for a filename (e.g., input("Enter filename: ")) and save it
    # ----------------------------------------------------
    
    print(f"{Fore.YELLOW}   (Test data generation logic is not yet implemented.)")
    print(f"{Fore.YELLOW}   Prompt was: {prompt}")

# --- NEW: The AI Router Function ---
def route_request(prompt: str, pipe) -> dict:
    """
    Uses the LLM to classify the user's intent and return a structured decision.
    """
    print(f"   - AI Router analyzing prompt...")
    
    system_prompt_router = """
    You are a high-level routing assistant for a test automation framework.
    Your job is to classify the user's intent into one of five categories:
    1. "run_test": For executing tests (e.g., "run ffc", "start the pending test").
    2. "debug_test": For analyzing failures (e.g., "why did it fail?", "debug the log").
    3. "generate_test_case": For writing a new .robot test case (e.g., "create a new script", "provide a test for LPU").
    4. "generate_test_data": For creating new JSON test data (e.g., "make test data", "I need a new applicant file").
    5. "unknown": For anything else (e.g., "hello", "what is the weather?").

    You must respond ONLY with a single, valid JSON object with two keys:
    - "intent": The category you chose (e.g., "generate_test_case").
    - "query": The user's original, unmodified prompt.
    """
    
    messages = [
        {"role": "system", "content": system_prompt_router},
        {"role": "user", "content": prompt}
    ]
    
    # --- UPDATED: Added generation_args to silence warnings ---
    generation_args = {
        "max_new_tokens": 150,
        "do_sample": False
    }
    
    outputs = pipe(messages, **generation_args)
    
    try:
        # Extract the JSON part of the response
        response_text = outputs[0]['generated_text'][-1]['content']
        json_str = response_text[response_text.find('{') : response_text.rfind('}')+1]
        
        decision = json.loads(json_str)
        if "intent" not in decision or "query" not in decision:
             raise ValueError("Invalid JSON format from router.")
        
        print(f"   - AI Router decision: {Fore.CYAN}{decision['intent']}{Style.RESET_ALL}")
        return decision
        
    except Exception as e:
        print(f"{Fore.RED}❌ AI Router failed: {e}{Style.RESET_ALL}")
        return {"intent": "unknown", "query": prompt}

# --- REPLACED: The main() function now uses the AI Router ---
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
        retriever = db.as_retriever(search_kwargs={'k': 5}) # Kept 'k=5' from our last fix
    except Exception as e:
        print(f"{Fore.RED}❌ Critical Error: Could not load the knowledge base: {e}"); sys.exit(1)

    print(f"{Fore.GREEN}✅ Jarvis is online and ready.{Style.RESET_ALL}")

    try:
        # --- This is the new AI-powered routing logic ---
        ai_decision = route_request(args.prompt, pipe)
        
        intent = ai_decision.get("intent")
        query = ai_decision.get("query")

        if intent == "generate_test_case":
            generate_test_case(query, pipe, retriever)
        
        elif intent == "debug_test":
            handle_debugging({"query": query}, pipe, retriever)
            
        elif intent == "run_test":
            # (Placeholder) We can build a second AI parser here later
            execute_automation({"query": query})
        
        elif intent == "generate_test_data":
            generate_test_data(query, pipe, retriever)
            
        else: # This handles "unknown"
            print(f"\n{Fore.YELLOW}🤔 Jarvis: I'm not sure what to do. Please try rephrasing your request to run, debug, or generate a test.")
            
        print(f"\n{Style.BRIGHT}✨ Task complete.{Style.RESET_ALL}")

    except Exception as e:
        print(f"\n{Fore.RED}❌ A critical error occurred: {e}")

if __name__ == "__main__":
    main()