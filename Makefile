.PHONY: unit coverage lint nix-tests installation-tests
.PHONY: check coverage-html clean

check: coverage lint
# not nix-tests, not installation-tests because it runs main
# not unit because it's included in coverage

unit:
	PYTHONPATH=. pytest

coverage:
	coverage run -m pytest --doctest-modules project_name tests  # TODO: replace
	coverage report --fail-under=100

coverage-html: coverage
	coverage html
	xdg-open htmlcov/index.html || true

lint:
	flake8
	codespell

installation-tests:
	rm -rf .empty && mkdir .empty
	sh -c 'cd .empty && ../tests/installation/main.sh'

nix-tests:
	nix run .
	nix shell . -c tests/installation/main.sh
	nix flake check

clean:
	rm -rf ./htmlcov .empty
