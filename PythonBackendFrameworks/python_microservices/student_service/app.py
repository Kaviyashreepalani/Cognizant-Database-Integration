from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import requests

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///students.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)


class Student(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))


with app.app_context():
    db.create_all()


@app.route("/api/students", methods=["POST"])
def create_student():

    data = request.json

    student = Student(
        name=data["name"]
    )

    db.session.add(student)
    db.session.commit()

    return jsonify({
        "message": "Student created"
    })


@app.route("/api/students/<int:id>", methods=["GET"])
def get_student(id):

    student = Student.query.get(id)

    if not student:
        return jsonify({
            "message": "Student not found"
        }), 404

    return jsonify({
        "id": student.id,
        "name": student.name
    })


@app.route("/api/students/<int:id>/enroll", methods=["POST"])
def enroll_student(id):

    data = request.json

    course_id = data["course_id"]

    try:

        response = requests.get(
            f"http://localhost:5001/api/courses/{course_id}"
        )

        if response.status_code != 200:

            return jsonify({
                "message": "Course does not exist"
            }), 404

    except requests.exceptions.ConnectionError:

        return jsonify({
            "message": "Course Service unavailable"
        }), 503

    return jsonify({
        "message": f"Student {id} enrolled in course {course_id}"
    })


if __name__ == "__main__":
    app.run(port=5002, debug=True)