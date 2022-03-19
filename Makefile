CC=poetry
ACTIONS=.github/workflows/cicd.yml
PYTHONFILES=kiva_ayiti
GIT=git


install:
	$(CC) install

lint: $(PYTHONFILES)
	$(CC) run black $(PYTHONFILES)
	$(CC) run pylint $(PYTHONFILES)

build: $(PYTHONFILES) lint
	$(CC) update
	$(CC) export --format requirements.txt --without-hashes --output requirements.txt
	$(CC) build

test: lint
	poetry run pytest -vv

jupyterlab:
	poetry run jupyter-lab

coverage:
	poetry run pytest -vv --cov=$(PYTHONFILES) --cov-report=term --cov-report=html

mfini: build
	$(GIT) add -A
	$(GIT) commit -m "$(MSG)"
	$(GIT) push origin

ajour:
	$(GIT) pull origin
	poetry update

.PHONY: lint build
