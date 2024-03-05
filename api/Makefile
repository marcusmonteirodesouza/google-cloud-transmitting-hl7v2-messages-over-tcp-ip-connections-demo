export:
	poetry export -f requirements.txt --output requirements.txt

format:
	poetry run black .

run:
	poetry run uvicorn api:app --reload

up:
	docker compose up