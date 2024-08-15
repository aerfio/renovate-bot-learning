CURRENT_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
export GOBIN=$(CURRENT_DIR)/bin

all: format generate-deep-copy generate-crds

GOFUMPT_VERSION = v0.6.0
GOFUMPT = bin/gofumpt-${GOFUMPT_VERSION}
${GOFUMPT}:
	go install mvdan.cc/gofumpt@$(GOFUMPT_VERSION)
	mv ${GOBIN}/gofumpt ${GOFUMPT}

GCI_VERSION = v0.13.4
GCI = bin/gci-${GCI_VERSION}
${GCI}:
	go install github.com/daixiang0/gci@$(GCI_VERSION)
	mv ${GOBIN}/gci ${GCI}

.PHONY: format
format: ${GCI} ${GOFUMPT}
	$(GCI) write . --skip-generated -s standard -s default -s "Prefix($(shell go list -m))" -s blank -s dot --custom-order --skip-vendor
	$(GOFUMPT) -w -extra -l .

CONTROLLER_TOOLS_VERSION = v0.16.0
CONTROLLER_GEN ?= bin/controller-gen-${CONTROLLER_TOOLS_VERSION}
${CONTROLLER_GEN}:
	go install sigs.k8s.io/controller-tools/cmd/controller-gen@$(CONTROLLER_TOOLS_VERSION)
	mv ${GOBIN}/controller-gen ${CONTROLLER_GEN}

.PHONY: generate-crds
generate-crds: ${CONTROLLER_GEN}
	$(CONTROLLER_GEN) crd paths="./pkg/..." output:crd:artifacts:config=./crds

generate-deep-copy: ${CONTROLLER_GEN}
	$(CONTROLLER_GEN) object paths="./pkg/..."
