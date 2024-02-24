CURRENT_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
export GOBIN=$(CURRENT_DIR)/bin

all: format

GOFUMPT_VERSION = v0.6.0
GOFUMPT = bin/gofumpt-${GOFUMPT_VERSION}
${GOFUMPT}:
	go install mvdan.cc/gofumpt@$(GOFUMPT_VERSION)
	mv ${GOBIN}/gofumpt ${GOFUMPT}

GCI_VERSION = v0.12.1
GCI = bin/gci-${GCI_VERSION}
${GCI}:
	go install github.com/daixiang0/gci@$(GCI_VERSION)
	mv ${GOBIN}/gci ${GCI}

.PHONY: format
format: ${GCI} ${GOFUMPT}
	$(GCI) write . --skip-generated -s standard -s default -s "prefix($(shell go list -m))" -s blank -s dot --custom-order --skip-vendor
	$(GOFUMPT) -w -extra -l .
