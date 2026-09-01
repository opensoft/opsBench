#!/bin/bash
# Layer 2 Ops Bench Tools Installation Script (Minimal)
# Core deployment, CI/CD, and security tools with pinned versions

set -e

echo "=========================================="
echo "Installing Layer 2 Ops Bench Tools"
echo "=========================================="

# ========================================
# DEPLOYMENT & AI ORCHESTRATION
# ========================================

echo "Installing code-server (VS Code in browser)..."
CODE_SERVER_VERSION="${CODE_SERVER_VERSION:-4.126.0}"
code_server_installer="$(mktemp)"
trap 'rm -f "$code_server_installer"' EXIT
curl -fsSL https://code-server.dev/install.sh -o "$code_server_installer"
sh "$code_server_installer" --version "$CODE_SERVER_VERSION"
rm -f "$code_server_installer"
trap - EXIT
code-server --version

echo "Installing Azure ML CLI (v2)..."
pip3 install --break-system-packages azure-ai-ml azure-identity
echo "Azure ML CLI v2 installed"

echo "Installing act (run GitHub Actions locally)..."
ACT_VERSION="${ACT_VERSION:-0.2.89}"
curl -fL "https://github.com/nektos/act/releases/download/v${ACT_VERSION}/act_Linux_x86_64.tar.gz" -o /tmp/act.tar.gz
tar -xzf /tmp/act.tar.gz -C /usr/local/bin act
rm /tmp/act.tar.gz
chmod +x /usr/local/bin/act
act --version

# ========================================
# CI/CD & DELIVERY
# ========================================

echo "Installing ArgoCD CLI..."
ARGOCD_VERSION="${ARGOCD_VERSION:-3.4.4}"
curl -L "https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64" -o /usr/local/bin/argocd
chmod +x /usr/local/bin/argocd
argocd version --client

echo "Installing Flux CLI..."
curl -s https://fluxcd.io/install.sh | bash
flux --version

echo "Installing Tekton CLI (tkn)..."
TKN_VERSION="${TKN_VERSION:-0.45.0}"
curl -L "https://github.com/tektoncd/cli/releases/download/v${TKN_VERSION}/tkn_${TKN_VERSION}_Linux_x86_64.tar.gz" -o /tmp/tkn.tar.gz
tar -xzf /tmp/tkn.tar.gz -C /usr/local/bin tkn
rm /tmp/tkn.tar.gz
chmod +x /usr/local/bin/tkn
tkn version

echo "Installing Skaffold..."
curl -Lo /usr/local/bin/skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x /usr/local/bin/skaffold
skaffold version

echo "Installing Tilt..."
TILT_VERSION="${TILT_VERSION:-0.37.4}"
curl -L "https://github.com/tilt-dev/tilt/releases/download/v${TILT_VERSION}/tilt.${TILT_VERSION}.linux.x86_64.tar.gz" -o /tmp/tilt.tar.gz
tar -xzf /tmp/tilt.tar.gz -C /usr/local/bin tilt
rm /tmp/tilt.tar.gz
chmod +x /usr/local/bin/tilt
tilt version

# ========================================
# SECURITY & SECRETS MANAGEMENT
# ========================================

echo "Installing Vault CLI..."
VAULT_VERSION="${VAULT_VERSION:-2.0.3}"
curl -L "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -o /tmp/vault.zip
unzip -o /tmp/vault.zip -d /usr/local/bin
rm /tmp/vault.zip
chmod +x /usr/local/bin/vault
vault --version

echo "Installing Grype (container vulnerability scanner)..."
GRYPE_VERSION="${GRYPE_VERSION:-0.115.0}"
curl -L "https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_linux_amd64.tar.gz" -o /tmp/grype.tar.gz
tar -xzf /tmp/grype.tar.gz -C /usr/local/bin grype
rm /tmp/grype.tar.gz
chmod +x /usr/local/bin/grype
grype version

echo "Installing Snyk CLI..."
curl -L "https://static.snyk.io/cli/latest/snyk-linux" -o /usr/local/bin/snyk
chmod +x /usr/local/bin/snyk
snyk --version || echo "Snyk installed (auth required for full version check)"

# Checkov skipped in minimal - large Python dependency
# Install manually if needed: pip3 install --break-system-packages checkov

echo "Installing age (file encryption)..."
AGE_VERSION="${AGE_VERSION:-1.3.1}"
curl -L "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz" -o /tmp/age.tar.gz
tar -xzf /tmp/age.tar.gz -C /tmp
mv /tmp/age/age /usr/local/bin/
mv /tmp/age/age-keygen /usr/local/bin/
rm -rf /tmp/age*
chmod +x /usr/local/bin/age /usr/local/bin/age-keygen
age --version

echo "Installing SOPS (secrets in Git)..."
SOPS_VERSION="${SOPS_VERSION:-3.13.2}"
curl -L "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64" -o /usr/local/bin/sops
chmod +x /usr/local/bin/sops
sops --version

# ========================================
# SUPPLY CHAIN SECURITY
# ========================================

echo "Installing Syft (SBOM generation)..."
SYFT_VERSION="${SYFT_VERSION:-1.46.0}"
curl -L "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_amd64.tar.gz" -o /tmp/syft.tar.gz
tar -xzf /tmp/syft.tar.gz -C /usr/local/bin syft
rm /tmp/syft.tar.gz
chmod +x /usr/local/bin/syft
syft version

echo "Installing Cosign (container image signing)..."
COSIGN_VERSION="${COSIGN_VERSION:-3.1.1}"
curl -L "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64" -o /usr/local/bin/cosign
chmod +x /usr/local/bin/cosign
cosign version

# ========================================
# POLICY AS CODE
# ========================================

echo "Installing Conftest (policy testing)..."
CONFTEST_VERSION="${CONFTEST_VERSION:-0.68.2}"
curl -L "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz
tar -xzf /tmp/conftest.tar.gz -C /usr/local/bin conftest
rm /tmp/conftest.tar.gz
chmod +x /usr/local/bin/conftest
conftest --version

# ========================================
# LOAD & PERFORMANCE TESTING
# ========================================

echo "Installing k6 (load testing)..."
K6_VERSION="${K6_VERSION:-2.1.0}"
curl -L "https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-amd64.tar.gz" -o /tmp/k6.tar.gz
tar -xzf /tmp/k6.tar.gz -C /tmp
mv "/tmp/k6-v${K6_VERSION}-linux-amd64/k6" /usr/local/bin/
rm -rf /tmp/k6*
chmod +x /usr/local/bin/k6
k6 version

# ========================================
# CONTAINER IMAGE TOOLING
# ========================================

echo "Installing crane (image manipulation)..."
CRANE_VERSION="${CRANE_VERSION:-0.21.7}"
curl -L "https://github.com/google/go-containerregistry/releases/download/v${CRANE_VERSION}/go-containerregistry_Linux_x86_64.tar.gz" -o /tmp/crane.tar.gz
tar -xzf /tmp/crane.tar.gz -C /usr/local/bin crane
rm /tmp/crane.tar.gz
chmod +x /usr/local/bin/crane
crane version

# ========================================
# K8S CONFIGURATION FOR DEVELOPERS
# ========================================

echo "Installing Kustomize..."
KUSTOMIZE_VERSION="${KUSTOMIZE_VERSION:-5.8.1}"
curl -L "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" -o /tmp/kustomize.tar.gz
tar -xzf /tmp/kustomize.tar.gz -C /usr/local/bin
rm /tmp/kustomize.tar.gz
chmod +x /usr/local/bin/kustomize
kustomize version

echo "Installing Helmfile..."
HELMFILE_VERSION="${HELMFILE_VERSION:-1.6.0}"
curl -L "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" -o /tmp/helmfile.tar.gz
tar -xzf /tmp/helmfile.tar.gz -C /usr/local/bin helmfile
rm /tmp/helmfile.tar.gz
chmod +x /usr/local/bin/helmfile
helmfile version

# ========================================
# K8S DEVELOPER EXPERIENCE
# ========================================

echo "Installing kubectx and kubens..."
KUBECTX_VERSION="${KUBECTX_VERSION:-0.11.0}"
curl -L "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz" -o /tmp/kubectx.tar.gz
tar -xzf /tmp/kubectx.tar.gz -C /usr/local/bin kubectx
rm /tmp/kubectx.tar.gz
curl -L "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_linux_x86_64.tar.gz" -o /tmp/kubens.tar.gz
tar -xzf /tmp/kubens.tar.gz -C /usr/local/bin kubens
rm /tmp/kubens.tar.gz
chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens
kubectx --version || echo "kubectx installed"
kubens --version || echo "kubens installed"

echo "Installing pluto (K8s API deprecation detector)..."
PLUTO_VERSION="${PLUTO_VERSION:-5.24.0}"
curl -L "https://github.com/FairwindsOps/pluto/releases/download/v${PLUTO_VERSION}/pluto_${PLUTO_VERSION}_linux_amd64.tar.gz" -o /tmp/pluto.tar.gz
tar -xzf /tmp/pluto.tar.gz -C /usr/local/bin pluto
rm /tmp/pluto.tar.gz
chmod +x /usr/local/bin/pluto
pluto version

echo "Installing kubeseal (Sealed Secrets CLI)..."
KUBESEAL_VERSION="${KUBESEAL_VERSION:-0.38.1}"
curl -L "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz" -o /tmp/kubeseal.tar.gz
tar -xzf /tmp/kubeseal.tar.gz -C /usr/local/bin kubeseal
rm /tmp/kubeseal.tar.gz
chmod +x /usr/local/bin/kubeseal
kubeseal --version

# ========================================
# LOCAL K8S CLUSTERS
# ========================================

echo "Installing k3d (local K8s clusters)..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d version

# ========================================
# TASK RUNNER
# ========================================

echo "Installing task (Go Task runner)..."
TASK_VERSION="${TASK_VERSION:-3.51.1}"
curl -L "https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_amd64.tar.gz" -o /tmp/task.tar.gz
tar -xzf /tmp/task.tar.gz -C /usr/local/bin task
rm /tmp/task.tar.gz
chmod +x /usr/local/bin/task
task --version

# ========================================
# RELEASE MANAGEMENT
# ========================================

echo "Installing semantic-release..."
npm install -g semantic-release @semantic-release/changelog @semantic-release/git
semantic-release --version || echo "semantic-release installed"

echo ""
echo "=========================================="
echo "✓ Layer 2 Ops Tools Installation Complete"
echo "=========================================="
echo ""
echo "Core Tools Installed:"
echo "  - code-server, Azure ML CLI, act (Deployment & AI)"
echo "  - ArgoCD, Flux, Tekton, Skaffold, Tilt (CI/CD)"
echo "  - Vault, Grype, Snyk, age, SOPS (Security)"
echo "  - Syft, Cosign (Supply Chain)"
echo "  - Conftest (Policy)"
echo "  - k6 (Load Testing)"
echo "  - crane (Container Images)"
echo "  - Kustomize, Helmfile (K8s Config)"
echo "  - kubectx, kubens, pluto, kubeseal (K8s DX)"
echo "  - k3d (Local K8s Clusters)"
echo "  - task (Task Runner)"
echo "  - semantic-release (Release Management)"
echo ""
echo "Skipped (install manually if needed):"
echo "  - Checkov (large Python deps)"
