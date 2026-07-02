from flask import Flask, request, jsonify
import requests

app = Flask(__name__)


@app.route("/api/courses", methods=["GET", "POST"])
def course_service():

    response = requests.request(
        method=request.method,
        url="http://localhost:5001/api/courses",
        json=request.get_json(silent=True)
    )

    return (
        response.content,
        response.status_code,
        response.headers.items()
    )


@app.route("/api/courses/<path:path>", methods=["GET"])
def course_service_path(path):

    response = requests.request(
        method=request.method,
        url=f"http://localhost:5001/api/courses/{path}"
    )

    return (
        response.content,
        response.status_code,
        response.headers.items()
    )


@app.route("/api/students", methods=["GET", "POST"])
def student_service():

    response = requests.request(
        method=request.method,
        url="http://localhost:5002/api/students",
        json=request.get_json(silent=True)
    )

    return (
        response.content,
        response.status_code,
        response.headers.items()
    )


@app.route(
    "/api/students/<path:path>",
    methods=["GET", "POST"]
)
def student_service_path(path):

    response = requests.request(
        method=request.method,
        url=f"http://localhost:5002/api/students/{path}",
        json=request.get_json(silent=True)
    )

    return (
        response.content,
        response.status_code,
        response.headers.items()
    )


if __name__ == "__main__":
    app.run(port=5000, debug=True)