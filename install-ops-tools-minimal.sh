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
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.100.3
code-server --version

echo "Installing Azure ML CLI (v2)..."
pip3 install --break-system-packages azure-ai-ml azure-identity
echo "Azure ML CLI v2 installed"

echo "Installing act (run GitHub Actions locally)..."
curl -L "https://github.com/nektos/act/releases/download/v0.2.74/act_Linux_x86_64.tar.gz" -o /tmp/act.tar.gz
tar -xzf /tmp/act.tar.gz -C /usr/local/bin act
rm /tmp/act.tar.gz
chmod +x /usr/local/bin/act
act --version

# ========================================
# CI/CD & DELIVERY
# ========================================

echo "Installing ArgoCD CLI..."
curl -L "https://github.com/argoproj/argo-cd/releases/download/v2.14.11/argocd-linux-amd64" -o /usr/local/bin/argocd
chmod +x /usr/local/bin/argocd
argocd version --client

echo "Installing Flux CLI..."
curl -s https://fluxcd.io/install.sh | bash
flux --version

echo "Installing Tekton CLI (tkn)..."
curl -L "https://github.com/tektoncd/cli/releases/download/v0.40.0/tkn_0.40.0_Linux_x86_64.tar.gz" -o /tmp/tkn.tar.gz
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
curl -L "https://releases.hashicorp.com/vault/1.19.2/vault_1.19.2_linux_amd64.zip" -o /tmp/vault.zip
unzip -o /tmp/vault.zip -d /usr/local/bin
rm /tmp/vault.zip
chmod +x /usr/local/bin/vault
vault --version

echo "Installing Grype (container vulnerability scanner)..."
curl -L "https://github.com/anchore/grype/releases/download/v0.90.0/grype_0.90.0_linux_amd64.tar.gz" -o /tmp/grype.tar.gz
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
curl -L "https://github.com/FiloSottile/age/releases/download/v1.2.1/age-v1.2.1-linux-amd64.tar.gz" -o /tmp/age.tar.gz
tar -xzf /tmp/age.tar.gz -C /tmp
mv /tmp/age/age /usr/local/bin/
mv /tmp/age/age-keygen /usr/local/bin/
rm -rf /tmp/age*
chmod +x /usr/local/bin/age /usr/local/bin/age-keygen
age --version

echo "Installing SOPS (secrets in Git)..."
curl -L "https://github.com/getsops/sops/releases/download/v3.9.4/sops-v3.9.4.linux.amd64" -o /usr/local/bin/sops
chmod +x /usr/local/bin/sops
sops --version

echo ""
echo "=========================================="
echo "✓ Layer 2 Ops Tools Installation Complete"
echo "=========================================="
echo ""
echo "Core Tools Installed:"
echo "  - code-server, Azure ML CLI, act (Deployment & AI)"
echo "  - ArgoCD, Flux, Tekton, Skaffold, Tilt (CI/CD)"
echo "  - Vault, Grype, Snyk, age, SOPS (Security)"
echo ""
echo "Skipped (install manually if needed):"
echo "  - Checkov (large Python deps)"
