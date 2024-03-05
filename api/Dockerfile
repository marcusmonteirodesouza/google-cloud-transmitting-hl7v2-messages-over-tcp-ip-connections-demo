FROM python:3.12-slim

ARG POETRY_VERSION=1.6.1

COPY . /app

WORKDIR /app

# Generate requirements.txt
RUN pip install --upgrade pip && \
    pip install poetry==$POETRY_VERSION && \
    poetry export -f requirements.txt --output requirements.txt && \
    pip install -r requirements.txt

CMD uvicorn api:app --host '0.0.0.0' --port "$PORT"