from app import app, db
from courses.models import Department, Course

with app.app_context():

    cs = Department(
        name="Computer Science",
        head_of_dept="Dr Kumar",
        budget=100000
    )

    ece = Department(
        name="ECE",
        head_of_dept="Dr Raj",
        budget=80000
    )

    db.session.add_all([cs, ece])
    db.session.commit()

    python_course = Course(
        name="Python",
        code="CS101",
        credits=4,
        department=cs
    )

    java_course = Course(
        name="Java",
        code="CS102",
        credits=3,
        department=cs
    )

    vlsi_course = Course(
        name="VLSI",
        code="EC101",
        credits=4,
        department=ece
    )

    db.session.add_all([
        python_course,
        java_course,
        vlsi_course
    ])

    db.session.commit()

    print("Data inserted successfully!")

    print(Course.query.all())