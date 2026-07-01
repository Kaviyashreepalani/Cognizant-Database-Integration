from django.urls import path
from .views import CourseListView, CourseDetailView

urlpatterns = [
    path(
        'courses/',
        CourseListView.as_view()
    ),

    path(
        'courses/<int:pk>/',
        CourseDetailView.as_view()
    ),
]