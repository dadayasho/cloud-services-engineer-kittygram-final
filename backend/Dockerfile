FROM python:3.11-alpine
WORKDIR /backend
COPY . .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

CMD  python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000