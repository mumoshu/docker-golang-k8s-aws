.PHONY: build test

build:
	./build mumoshu/golang-k8s-aws:1.9.1

test:
	./test/integration/github-release
	./test/integration/github-deploy
