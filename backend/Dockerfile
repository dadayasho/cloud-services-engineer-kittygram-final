FROM python:3.11-alpine

RUN apk add --no-cache gcc musl-dev libffi-dev postgresql-dev python3-dev postgresql-client

WORKDIR /backend

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]