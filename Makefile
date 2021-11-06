GO_BUILD = GOOS=linux go build
FUNCTIONS_LAMBDAS = $(wildcard lambdas/*/main.go)
FUNCTIONS_DIRS = $(shell ls lambdas)

.PHONY: build/lambdas
build/lambdas:
	mkdir -p dist
	make $(FUNCTIONS_LAMBDAS)

lambdas/%/main.go:
	cd $(subst main.go,,$@) \
	&& $(GO_BUILD) -o lambda ./.\
	&& zip ../../dist/$*.zip lambda \
	&& rm lambda