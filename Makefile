-include .makefiles/Makefile
-include .makefiles/pkg/js/v1/Makefile
-include .makefiles/pkg/js/v1/with-npm.mk

.makefiles/%:
	@curl -sfL https://makefiles.dev/v1 | bash /dev/stdin "$@"

################################################################################

.DEFAULT_GOAL := release

.PHONY: release
release: artifacts/branding.zip

################################################################################

artifacts/branding.zip: artifacts/dist
	@mkdir -p "$(@D)"

	cd "$<"; zip -r - . > ../branding.zip

artifacts/dist: artifacts/link-dependencies.touch artifacts/puppeteer-install.touch $(JS_SOURCE_FILES)
	@rm -rf "$@"

	$(JS_EXEC) iconduit src/iconduit.config.json
	touch "$@/.nojekyll"

	@touch "$@"

artifacts/puppeteer-install.touch:
	rm -rf /home/runner/.cache/puppeteer/chrome/linux-127.0.6533.88
	$(JS_EXEC) puppeteer browsers install chrome
	@mkdir -p "$(@D)"
	@touch "$@"
