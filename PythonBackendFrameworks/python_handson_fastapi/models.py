from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import Mapped, mapped_column


class Base(DeclarativeBase):
    pass


class Course(Base):

    __tablename__ = "courses"

    id: Mapped[int] = mapped_column(
        primary_key=True
    )

    name: Mapped[str]

    code: Mapped[str]

    credits: Mapped[int]

    department_id: Mapped[int]