from flask import Flask, request, jsonify

def calc_age(birth_year: int) -> int:
  current_year = 2026
  return current_year - birth_year

app = Flask(__name__)

@app.route("/", methods=["GET"])
def index():
    if request.method == "GET":
      data = {
          "name": request.args.get('name'),
          "birthYear": request.args.get('birthYear'),
          "age": calc_age(int(request.args.get('birthYear'))) if request.args.get('birthYear') else None
      }
      return jsonify(data)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
