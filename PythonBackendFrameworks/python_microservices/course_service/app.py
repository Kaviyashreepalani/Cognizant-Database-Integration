from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///courses.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)


class Course(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))


with app.app_context():
    db.create_all()


@app.route("/api/courses", methods=["POST"])
def create_course():

    data = request.json

    course = Course(
        name=data["name"]
    )

    db.session.add(course)
    db.session.commit()

    return jsonify({
        "message": "Course created"
    })


@app.route("/api/courses/<int:id>", methods=["GET"])
def get_course(id):

    course = Course.query.get(id)

    if not course:
        return jsonify({
            "message": "Course not found"
        }), 404

    return jsonify({
        "id": course.id,
        "name": course.name
    })


@app.route("/api/courses", methods=["GET"])
def get_courses():

    courses = Course.query.all()

    result = []

    for course in courses:
        result.append({
            "id": course.id,
            "name": course.name
        })

    return jsonify(result)


if __name__ == "__main__":
    app.run(port=5001, debug=True)