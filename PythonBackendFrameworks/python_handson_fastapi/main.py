from typing import Optional, List

from fastapi import (
    FastAPI,
    Depends,
    HTTPException,
    status,
    BackgroundTasks
)

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from models import Course, Student, Enrollment
from schemas import (
    CourseCreate,
    CourseUpdate,
    CourseResponse,
    EnrollmentCreate
)


app = FastAPI(
    title="Course Management API",
    description="FastAPI application for managing courses, students, and enrollments",
    version="1.0",
    contact={
        "name": "Kaviya Shree",
        "email": "24f1000772@ds.study.iitm.ac.in"
    }
)


def send_confirmation_email(student_email: str):
    print(f"Sending confirmation to {student_email}")


@app.get("/", tags=["Home"])
async def root():
    return {
        "message": "API running"
    }


# -------------------- COURSES --------------------

@app.post(
    "/api/courses/",
    response_model=CourseResponse,
    status_code=status.HTTP_201_CREATED,
    tags=["Courses"],
    summary="Create a new course",
    response_description="Created course details"
)
async def create_course(
    course: CourseCreate,
    db: AsyncSession = Depends(get_db)
):

    new_course = Course(
        name=course.name,
        code=course.code,
        credits=course.credits,
        department_id=course.department_id
    )

    db.add(new_course)

    await db.commit()

    await db.refresh(new_course)

    return new_course


@app.get(
    "/api/courses/",
    response_model=List[CourseResponse],
    tags=["Courses"]
)
async def get_courses(
    skip: int = 0,
    limit: int = 10,
    department_id: Optional[int] = None,
    db: AsyncSession = Depends(get_db)
):

    query = select(Course)

    if department_id:
        query = query.where(
            Course.department_id == department_id
        )

    query = query.offset(skip).limit(limit)

    result = await db.execute(query)

    courses = result.scalars().all()

    return courses


@app.get(
    "/api/courses/{id}",
    response_model=CourseResponse,
    tags=["Courses"]
)
async def get_course(
    id: int,
    db: AsyncSession = Depends(get_db)
):

    result = await db.execute(
        select(Course).where(Course.id == id)
    )

    course = result.scalar_one_or_none()

    if not course:
        raise HTTPException(
            status_code=404,
            detail="Course not found"
        )

    return course


@app.put(
    "/api/courses/{id}",
    response_model=CourseResponse,
    tags=["Courses"]
)
async def update_course(
    id: int,
    course_update: CourseUpdate,
    db: AsyncSession = Depends(get_db)
):

    result = await db.execute(
        select(Course).where(Course.id == id)
    )

    course = result.scalar_one_or_none()

    if not course:
        raise HTTPException(
            status_code=404,
            detail="Course not found"
        )

    if course_update.name is not None:
        course.name = course_update.name

    if course_update.code is not None:
        course.code = course_update.code

    if course_update.credits is not None:
        course.credits = course_update.credits

    if course_update.department_id is not None:
        course.department_id = course_update.department_id

    await db.commit()

    await db.refresh(course)

    return course


@app.delete(
    "/api/courses/{id}",
    status_code=status.HTTP_204_NO_CONTENT,
    tags=["Courses"]
)
async def delete_course(
    id: int,
    db: AsyncSession = Depends(get_db)
):

    result = await db.execute(
        select(Course).where(Course.id == id)
    )

    course = result.scalar_one_or_none()

    if not course:
        raise HTTPException(
            status_code=404,
            detail="Course not found"
        )

    await db.delete(course)

    await db.commit()


@app.get(
    "/api/courses/{id}/students",
    tags=["Courses"]
)
async def get_course_students(
    id: int,
    db: AsyncSession = Depends(get_db)
):

    result = await db.execute(
        select(Student)
        .join(Enrollment)
        .where(Enrollment.course_id == id)
    )

    students = result.scalars().all()

    return students


# -------------------- ENROLLMENTS --------------------

@app.post(
    "/api/enrollments/",
    status_code=status.HTTP_201_CREATED,
    tags=["Enrollments"]
)
async def create_enrollment(
    enrollment: EnrollmentCreate,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db)
):

    new_enrollment = Enrollment(
        student_id=enrollment.student_id,
        course_id=enrollment.course_id
    )

    db.add(new_enrollment)

    await db.commit()

    student = await db.get(
        Student,
        enrollment.student_id
    )

    if student:
        background_tasks.add_task(
            send_confirmation_email,
            student.email
        )

    return {
        "message": "Enrollment created successfully"
    }