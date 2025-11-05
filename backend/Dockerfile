FROM python:3.11-alpine AS backend-builder
WORKDIR /backend
COPY . .
RUN python3 -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt


FROM python:3.11-alpine 
WORKDIR /backend
COPY --from=backend-builder /usr/local/lib/python3.11-alpine/site-packages/ /usr/local/lib/python3.11-alpine/site-packages/
COPY --from=backend-builder /backend /backend
CMD python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000

