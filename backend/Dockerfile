FROM python:3.11-alpine

RUN apk add --no-cache gcc musl-dev libffi-dev postgresql-dev python3-dev postgresql-client

WORKDIR /backend

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
