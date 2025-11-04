FROM python:3.10:slim

WORKDIR /backend

COPY requirements.txt .

RUN python3 -m pip install --upgrade pip && pip install -r requirements.txt

COPY --from=build /root/.local /root/.local

COPY /backend /cats
COPY /backend /kittygram_backend
COPY /backend /manage.py


RUN python3 manage.py migrate

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

