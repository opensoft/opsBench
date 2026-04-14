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
echo "Supply Chain Security:"
check "Syft" "syft version"
check "Cosign" "cosign version"

echo
echo "Policy as Code:"
check "Conftest" "conftest --version"

echo
echo "Load & Performance Testing:"
check "k6" "k6 version"

echo
echo "Container Image Tooling:"
check "crane" "crane version"

echo
echo "K8s Configuration:"
check "Kustomize" "kustomize version"
check "Helmfile" "helmfile version"

echo
echo "K8s Developer Experience:"
check "kubectx" "which kubectx"
check "kubens" "which kubens"
check "pluto" "pluto version"
check "kubeseal" "kubeseal --version"

echo
echo "Local K8s Clusters:"
check "k3d" "k3d version"

echo
echo "Task Runner:"
check "task" "task --version"

echo
echo "Release Management:"
check "semantic-release" "which semantic-release"

echo
echo "Layer 1b Tools (from sys-bench-base):"
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
check "Claude Code" "command -v claude"
check "Codex" "command -v codex"
check "Gemini" "command -v gemini"
check "OpenCode" "command -v opencode"
check "yolo alias" "zsh -ic 'alias yolo' | grep -q 'claude --dangerously-skip-permissions --teammate-mode tmux'"

echo
echo "Environment:"
check "Zsh shell" "[ -f '/bin/zsh' ]"
check "Workspace directory" "[ -d '/workspace' ]"
check "/etc/skel configs" "[ -f '/etc/skel/.zshrc' ]"

echo
echo "=========================================="
echo "Results: ${GREEN}${PASS_COUNT} passed${NC}, ${RED}${FAIL_COUNT} failed${NC}"
echo "=========================================="

exit $FAIL_COUNT
