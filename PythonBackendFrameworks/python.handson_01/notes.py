# REQUEST RESPONSE CYCLE

# Browser sends request
# URL Router receives request
# View processes request
# Model interacts with database
# Response returned to browser

# MIDDLEWARE

# Middleware sits between request and response.

# SecurityMiddleware:
# Adds security headers and protections.

# SessionMiddleware:
# Handles user session management.

# WSGI vs ASGI

# WSGI:
# Handles synchronous requests.

# ASGI:
# Handles asynchronous requests and WebSockets.

# Django uses WSGI by default.
# ASGI is used for chat applications and real-time systems.

# MVC vs MVT

# MVC:
# Model -> Data
# View -> User Interface
# Controller -> Logic

# Django MVT:
# Model -> Model
# View -> Controller
# Template -> View