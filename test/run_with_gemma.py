# test_model.py
import torch
from transformers import pipeline
import argparse
import json

parser = argparse.ArgumentParser(description="Interact with your intelligent assistant.")
parser.add_argument("prompt", type=str, help="The question you want to ask the assistant.")
args = parser.parse_args()

model_id = "Qwen/Qwen2-0.5B-Instruct"
pipe = pipeline(
    "text-generation",
    model=model_id,
    torch_dtype=torch.bfloat16, # This helps with memory usage
    device_map="auto", # This automatically uses a GPU if you have one
)

print("✅ Model loaded successfully!")

# Now, let's give the model a task.
# Chat models require a 'messages' list with roles (system, user, assistant).
messages = [
    {
        "role": "system",
        "content": """
           You are a command generation tool. Your sole purpose is to convert a user's request into a JSON object that will be used to run an automation script.

            Analyze the user's text to extract the following arguments: `instance`, `plan` and `lender`.
            You must use the 'Lender Code Mapping' to find the correct lender code.
            
            Respond with ONLY a single, valid JSON object. Do not provide explanations or conversational text.
            
            **Lender Code Mapping:**
                - Foundation Finance: FFC,FF
                - Good Leap: GL, gl,Gl
                - Upgrade: UG
            **Valid Instances:**
                - rba
                - rba2
                - rba3
                - rba4
                - rba5
                - rba6
        """
    },
    {
        "role": "user",
        "content": args.prompt
    }
]

# Run the pipeline with our messages.
outputs = pipe(
    messages,
    max_new_tokens=100
)

# Extract and print just the assistant's reply
raw_response = outputs[0]["generated_text"][-1]["content"]

try:
    # 1. Find the start and end of the JSON in the string
    json_start = raw_response.find('{')
    json_end = raw_response.rfind('}') + 1

    # 2. Extract just the JSON part
    json_str = raw_response[json_start:json_end]

    # 3. Convert the JSON string into a Python dictionary
    parsed_data = json.loads(json_str)

    # Now you can use it like a normal dictionary
    lender = parsed_data.get("lender")
    print(f"\nSuccessfully extracted lender: {lender}")

except Exception as e:
    print(f"Error parsing JSON: {e}")


print("\n🤖 Model Response:")
print(raw_response)