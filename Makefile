.PHONY: help test build docs
DOCUMENTATION_PATH?=./docs

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


test: ## Run unit tests
	@swift test

build: ## Build the library
	@swift build

lint: ## Run swift-lint to format and lint the project
	@swift-format format -i --configuration ./.swift-format --recursive ./Sources
	@swift-format format -i --configuration ./.swift-format --recursive ./Tests
	@swift-format format -i --configuration ./.swift-format --recursive ./Examples
	@swift-format lint --configuration ./.swift-format --recursive ./Sources

docs: ## Generate DocC output
	@swift package --allow-writing-to-directory $(DOCUMENTATION_PATH) \
			generate-documentation \
			--disable-indexing \
			--transform-for-static-hosting \
			--hosting-base-path feedbackbulb-swift \
			--target FeedbackBulb.Toolbox --output-path $(DOCUMENTATION_PATH)
