#!/bin/bash
# Layer 2 Ops Bench Tools Installation Script
# Installs deployment, CI/CD, and security tools on top of sys-bench-base (Layer 1b)

set -e

echo "=========================================="
echo "Installing Layer 2 Ops Bench Tools"
echo "=========================================="

# ========================================
# DEPLOYMENT & AI ORCHESTRATION
# ========================================

echo "Installing code-server (VS Code in browser)..."
CODE_SERVER_VERSION=$(curl -s https://api.github.com/repos/coder/code-server/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$CODE_SERVER_VERSION" ]; then
    CODE_SERVER_VERSION="4.100.3"
fi
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version "$CODE_SERVER_VERSION"
code-server --version

echo "Installing Azure ML CLI (v2)..."
pip3 install --break-system-packages azure-ai-ml azure-identity
echo "Azure ML CLI v2 installed"

echo "Installing act (run GitHub Actions locally)..."
ACT_VERSION=$(curl -s https://api.github.com/repos/nektos/act/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$ACT_VERSION" ]; then
    ACT_VERSION="0.2.74"
fi
curl -L "https://github.com/nektos/act/releases/download/v${ACT_VERSION}/act_Linux_x86_64.tar.gz" -o /tmp/act.tar.gz
tar -xzf /tmp/act.tar.gz -C /usr/local/bin act
rm /tmp/act.tar.gz
chmod +x /usr/local/bin/act
act --version

# ========================================
# CI/CD & DELIVERY
# ========================================

echo "Installing ArgoCD CLI..."
ARGOCD_VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$ARGOCD_VERSION" ]; then
    ARGOCD_VERSION="2.14.11"
fi
curl -L "https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64" -o /usr/local/bin/argocd
chmod +x /usr/local/bin/argocd
argocd version --client

echo "Installing Flux CLI..."
curl -s https://fluxcd.io/install.sh | bash
flux --version

echo "Installing Tekton CLI (tkn)..."
TKN_VERSION=$(curl -s https://api.github.com/repos/tektoncd/cli/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$TKN_VERSION" ]; then
    TKN_VERSION="0.40.0"
fi
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
TILT_VERSION=$(curl -s https://api.github.com/repos/tilt-dev/tilt/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$TILT_VERSION" ]; then
    TILT_VERSION="0.33.22"
fi
curl -L "https://github.com/tilt-dev/tilt/releases/download/v${TILT_VERSION}/tilt.${TILT_VERSION}.linux.x86_64.tar.gz" -o /tmp/tilt.tar.gz
tar -xzf /tmp/tilt.tar.gz -C /usr/local/bin tilt
rm /tmp/tilt.tar.gz
chmod +x /usr/local/bin/tilt
tilt version

# ========================================
# SECURITY & SECRETS MANAGEMENT
# ========================================

echo "Installing Vault CLI..."
VAULT_VERSION=$(curl -s https://api.github.com/repos/hashicorp/vault/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
if [ -z "$VAULT_VERSION" ]; then
    VAULT_VERSION="1.19.2"
fi
curl -L "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -o /tmp/vault.zip
unzip -o /tmp/vault.zip -d /usr/local/bin
rm /tmp/vault.zip
chmod +x /usr/local/bin/vault
vault --version

echo "Installing Grype (container vulnerability scanner)..."
GRYPE_VERSION=$(curl -s https://api.github.com/repos/anchore/grype/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$GRYPE_VERSION" ]; then
    GRYPE_VERSION="0.90.0"
fi
curl -L "https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_linux_amd64.tar.gz" -o /tmp/grype.tar.gz
tar -xzf /tmp/grype.tar.gz -C /usr/local/bin grype
rm /tmp/grype.tar.gz
chmod +x /usr/local/bin/grype
grype version

echo "Installing Snyk CLI..."
curl -L "https://static.snyk.io/cli/latest/snyk-linux" -o /usr/local/bin/snyk
chmod +x /usr/local/bin/snyk
snyk --version || echo "Snyk installed (auth required for full version check)"

echo "Installing Checkov..."
pip3 install --break-system-packages checkov
checkov --version

echo "Installing age (file encryption)..."
AGE_VERSION=$(curl -s https://api.github.com/repos/FiloSottile/age/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$AGE_VERSION" ]; then
    AGE_VERSION="1.2.1"
fi
curl -L "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz" -o /tmp/age.tar.gz
tar -xzf /tmp/age.tar.gz -C /tmp
mv /tmp/age/age /usr/local/bin/
mv /tmp/age/age-keygen /usr/local/bin/
rm -rf /tmp/age*
chmod +x /usr/local/bin/age /usr/local/bin/age-keygen
age --version

echo "Installing SOPS (secrets in Git)..."
SOPS_VERSION=$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$SOPS_VERSION" ]; then
    SOPS_VERSION="3.9.4"
fi
curl -L "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64" -o /usr/local/bin/sops
chmod +x /usr/local/bin/sops
sops --version

# ========================================
# SUPPLY CHAIN SECURITY
# ========================================

echo "Installing Syft (SBOM generation)..."
SYFT_VERSION=$(curl -s https://api.github.com/repos/anchore/syft/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$SYFT_VERSION" ]; then
    SYFT_VERSION="1.22.0"
fi
curl -L "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_amd64.tar.gz" -o /tmp/syft.tar.gz
tar -xzf /tmp/syft.tar.gz -C /usr/local/bin syft
rm /tmp/syft.tar.gz
chmod +x /usr/local/bin/syft
syft version

echo "Installing Cosign (container image signing)..."
COSIGN_VERSION=$(curl -s https://api.github.com/repos/sigstore/cosign/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$COSIGN_VERSION" ]; then
    COSIGN_VERSION="2.4.3"
fi
curl -L "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64" -o /usr/local/bin/cosign
chmod +x /usr/local/bin/cosign
cosign version

# ========================================
# POLICY AS CODE
# ========================================

echo "Installing Conftest (policy testing)..."
CONFTEST_VERSION=$(curl -s https://api.github.com/repos/open-policy-agent/conftest/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$CONFTEST_VERSION" ]; then
    CONFTEST_VERSION="0.58.0"
fi
curl -L "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz
tar -xzf /tmp/conftest.tar.gz -C /usr/local/bin conftest
rm /tmp/conftest.tar.gz
chmod +x /usr/local/bin/conftest
conftest --version

# ========================================
# LOAD & PERFORMANCE TESTING
# ========================================

echo "Installing k6 (load testing)..."
K6_VERSION=$(curl -s https://api.github.com/repos/grafana/k6/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$K6_VERSION" ]; then
    K6_VERSION="0.57.0"
fi
curl -L "https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-amd64.tar.gz" -o /tmp/k6.tar.gz
tar -xzf /tmp/k6.tar.gz -C /tmp
mv /tmp/k6-v${K6_VERSION}-linux-amd64/k6 /usr/local/bin/
rm -rf /tmp/k6*
chmod +x /usr/local/bin/k6
k6 version

# ========================================
# CONTAINER IMAGE TOOLING
# ========================================

echo "Installing crane (image manipulation)..."
CRANE_VERSION=$(curl -s https://api.github.com/repos/google/go-containerregistry/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$CRANE_VERSION" ]; then
    CRANE_VERSION="0.20.3"
fi
curl -L "https://github.com/google/go-containerregistry/releases/download/v${CRANE_VERSION}/go-containerregistry_Linux_x86_64.tar.gz" -o /tmp/crane.tar.gz
tar -xzf /tmp/crane.tar.gz -C /usr/local/bin crane
rm /tmp/crane.tar.gz
chmod +x /usr/local/bin/crane
crane version

# ========================================
# K8S CONFIGURATION FOR DEVELOPERS
# ========================================

echo "Installing Kustomize..."
KUSTOMIZE_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | grep '"tag_name": "kustomize/' | head -1 | sed -E 's/.*kustomize\/v([^"]+)".*/\1/')
if [ -z "$KUSTOMIZE_VERSION" ]; then
    KUSTOMIZE_VERSION="5.6.0"
fi
curl -L "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" -o /tmp/kustomize.tar.gz
tar -xzf /tmp/kustomize.tar.gz -C /usr/local/bin
rm /tmp/kustomize.tar.gz
chmod +x /usr/local/bin/kustomize
kustomize version

echo "Installing Helmfile..."
HELMFILE_VERSION=$(curl -s https://api.github.com/repos/helmfile/helmfile/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$HELMFILE_VERSION" ]; then
    HELMFILE_VERSION="0.171.0"
fi
curl -L "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" -o /tmp/helmfile.tar.gz
tar -xzf /tmp/helmfile.tar.gz -C /usr/local/bin helmfile
rm /tmp/helmfile.tar.gz
chmod +x /usr/local/bin/helmfile
helmfile version

# ========================================
# K8S DEVELOPER EXPERIENCE
# ========================================

echo "Installing kubectx and kubens..."
KUBECTX_VERSION=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$KUBECTX_VERSION" ]; then
    KUBECTX_VERSION="0.9.5"
fi
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
PLUTO_VERSION=$(curl -s https://api.github.com/repos/FairwindsOps/pluto/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$PLUTO_VERSION" ]; then
    PLUTO_VERSION="5.21.0"
fi
curl -L "https://github.com/FairwindsOps/pluto/releases/download/v${PLUTO_VERSION}/pluto_${PLUTO_VERSION}_linux_amd64.tar.gz" -o /tmp/pluto.tar.gz
tar -xzf /tmp/pluto.tar.gz -C /usr/local/bin pluto
rm /tmp/pluto.tar.gz
chmod +x /usr/local/bin/pluto
pluto version

echo "Installing kubeseal (Sealed Secrets CLI)..."
KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$KUBESEAL_VERSION" ]; then
    KUBESEAL_VERSION="0.28.0"
fi
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
TASK_VERSION=$(curl -s https://api.github.com/repos/go-task/task/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/' | head -1)
if [ -z "$TASK_VERSION" ]; then
    TASK_VERSION="3.49.1"
fi
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
