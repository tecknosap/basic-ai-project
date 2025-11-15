from flask import Flask, request, jsonify

app = Flask(__name__)

items = [
    {"id": 1, "name": "Apple"},
    {"id": 2, "name": "Banana"},
    {"id": 3, "name": "Orange"},
    {"id": 4, "name": "Grapes"}
]

@app.route("/")
def home():
    return {"message": "Search API is running"}

@app.route("/search")
def search():
    q = request.args.get("q", "").lower()
    results = [i for i in items if q in i["name"].lower()]
    return jsonify(results)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
