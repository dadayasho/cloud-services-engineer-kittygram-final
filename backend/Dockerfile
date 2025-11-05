FROM python:3.11-alpine AS backend-builder
WORKDIR /backend
COPY . .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.11-alpine
WORKDIR /backend
COPY --from=backend-builder /backend /backend
CMD ["/bin/sh", "-c", "python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000"]

