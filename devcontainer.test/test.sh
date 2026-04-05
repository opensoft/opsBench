#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PASS_COUNT=0
FAIL_COUNT=0

check() {
    local name="$1"
    local command="$2"
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $name"
        ((PASS_COUNT++))
    else
        echo -e "${RED}✗${NC} $name"
        ((FAIL_COUNT++))
    fi
}

echo "=========================================="
echo "Layer 2 Ops Bench Test Suite"
echo "=========================================="
echo

echo "Deployment & AI Orchestration:"
check "code-server" "code-server --version"
check "Azure ML CLI" "python3 -c 'import azure.ai.ml'"
check "act" "act --version"

echo
echo "CI/CD & Delivery:"
check "ArgoCD" "argocd version --client"
check "Flux" "flux --version"
check "Tekton (tkn)" "tkn version"
check "Skaffold" "skaffold version"
check "Tilt" "tilt version"

echo
echo "Security & Secrets Management:"
check "Vault" "vault --version"
check "Grype" "grype version"
check "Snyk" "which snyk"
check "age" "age --version"
check "age-keygen" "age-keygen --version"
check "SOPS" "sops --version"

echo
echo "Layer 1b Tools (from adminbench-base):"
check "Terraform" "terraform version"
check "kubectl" "kubectl version --client"
check "Helm" "helm version"
check "AWS CLI" "aws --version"
check "Azure CLI" "az version"
check "gcloud" "gcloud version"

echo
echo "Layer 0 Tools (from workbench-base):"
check "git" "git --version"
check "gh" "gh --version"
check "jq" "jq --version"

echo
echo "User & Environment:"
check "User is brett" "[ \"$(whoami)\" = 'brett' ]"
check "Home directory exists" "[ -d '/home/brett' ]"
check "Zsh shell" "[ -f '/bin/zsh' ]"
check "Workspace directory" "[ -d '/workspace' ]"

echo
echo "=========================================="
echo "Results: ${GREEN}${PASS_COUNT} passed${NC}, ${RED}${FAIL_COUNT} failed${NC}"
echo "=========================================="

exit $FAIL_COUNT
