#!/bin/bash
# Layer 2 Ops Bench Tools Installation Script
# Installs deployment, CI/CD, and security tools on top of adminbench-base (Layer 1b)

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
curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
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

echo ""
echo "=========================================="
echo "✓ Layer 2 Ops Tools Installation Complete"
echo "=========================================="
