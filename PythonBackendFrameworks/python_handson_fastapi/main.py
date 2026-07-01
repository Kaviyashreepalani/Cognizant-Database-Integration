from typing import Optional

from fastapi import FastAPI, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from database import get_db
from models import Course
from schemas import CourseCreate

app = FastAPI(
    title="Course Management API",
    version="1.0"
)


@app.get("/")
async def root():
    return {
        "message": "API running"
    }


@app.post("/api/courses/")
async def create_course(
    course: CourseCreate
):

    return {
        "message": "Course created",
        "course": course
    }


@app.get("/api/courses/{course_id}")
async def get_course(
    course_id: int
):

    return {
        "course_id": course_id
    }


@app.get("/api/courses/")
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