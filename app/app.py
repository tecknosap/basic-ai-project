from flask import Flask, request, jsonify, render_template
import os
from azure.ai.openai import OpenAIClient
from azure.core.credentials import AzureKeyCredential

app = Flask(__name__, static_folder="static", template_folder="templates")

client = OpenAIClient(
    endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
    credential=AzureKeyCredential(os.getenv("AZURE_OPENAI_API_KEY"))
)
deployment_name = os.getenv("AZURE_OPENAI_DEPLOYMENT")

# Chat API
@app.route("/chat", methods=["POST"])
def chat():
    user_input = request.json.get("message", "")
    if not user_input:
        return jsonify({"error": "Message is required"}), 400

    response = client.get_chat_completions(
        deployment_name=deployment_name,
        messages=[{"role": "user", "content": user_input}]
    )
    answer = response.choices[0].message.content
    return jsonify({"response": answer})

# Frontend
@app.route("/")
def index():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
