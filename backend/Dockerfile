FROM python:3.10


WORKDIR /backend


COPY requirements.txt .


RUN python3 -m pip install --upgrade pip && pip install -r requirements.txt

COPY . .

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
