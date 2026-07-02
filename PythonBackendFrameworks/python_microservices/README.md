# Microservices Decomposition

| Service Name         | Responsibility                    | Endpoints Owned                     | Database Owned |
|----------------------|-----------------------------------|-------------------------------------|----------------|
| Auth Service         | Registration, Login, JWT Tokens  | /register, /login                   | auth.db        |
| Course Service       | Course CRUD                       | /api/courses/*                      | courses.db     |
| Student Service      | Student CRUD, Enrollment          | /api/students/*                     | students.db    |
| Notification Service | Email Notifications               | /send-email                         | notification.db|