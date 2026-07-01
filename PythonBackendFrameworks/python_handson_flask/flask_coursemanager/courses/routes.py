from flask import Blueprint, jsonify, request
from app import db
from courses.models import Course, Student, Enrollment


courses_bp = Blueprint(
    "courses",
    __name__,
    url_prefix="/api/courses"
)


def make_response_json(data, status_code=200):
    return jsonify({
        "status": "success",
        "data": data
    }), status_code


# GET ALL COURSES
@courses_bp.route("/", methods=["GET"])
def get_courses():

    courses = Course.query.all()

    return make_response_json(
        [course.to_dict() for course in courses]
    )


# CREATE COURSE
@courses_bp.route("/", methods=["POST"])
def create_course():

    data = request.get_json()

    if not data:
        return jsonify({
            "error": "JSON data required"
        }), 400

    required_fields = [
        "name",
        "code",
        "credits",
        "department_id"
    ]

    for field in required_fields:
        if field not in data:
            return jsonify({
                "error": f"{field} is required"
            }), 400

    course = Course(
        name=data["name"],
        code=data["code"],
        credits=data["credits"],
        department_id=data["department_id"]
    )

    db.session.add(course)
    db.session.commit()

    return make_response_json(
        course.to_dict(),
        201
    )


# GET COURSE BY ID
@courses_bp.route("/<int:id>", methods=["GET"])
def get_course(id):

    course = Course.query.get_or_404(id)

    return make_response_json(
        course.to_dict()
    )


# UPDATE COURSE
@courses_bp.route("/<int:id>", methods=["PUT"])
def update_course(id):

    course = Course.query.get_or_404(id)

    data = request.get_json()

    course.name = data.get(
        "name",
        course.name
    )

    course.code = data.get(
        "code",
        course.code
    )

    course.credits = data.get(
        "credits",
        course.credits
    )

    db.session.commit()

    return make_response_json(
        course.to_dict()
    )


# DELETE COURSE
@courses_bp.route("/<int:id>", methods=["DELETE"])
def delete_course(id):

    course = Course.query.get_or_404(id)

    db.session.delete(course)
    db.session.commit()

    return jsonify({
        "message": "Course deleted successfully"
    }), 200


# GET STUDENTS ENROLLED IN A COURSE
@courses_bp.route("/<int:id>/students", methods=["GET"])
def get_course_students(id):

    course = Course.query.get_or_404(id)

    enrollments = Enrollment.query.filter_by(
        course_id=id
    ).all()

    students = [
        enrollment.student.to_dict()
        for enrollment in enrollments
    ]

    return make_response_json(students)