# OpsBench - Layer 2 Deployment & CI/CD Operations

Operations bench with deployment orchestration, CI/CD pipelines, and shift-left security tools.

## Quick Start

### Build the Image
```bash
./build-layer2.sh --user brett
```

### Create a Workspace
```bash
cp -r devcontainer.example workspaces/my-project
cd workspaces/my-project
code .  # Open in VSCode and reopen in container
```

## What's Included

### Layer 2 Tools (Deliver & Secure)

**Deployment & AI Orchestration**
- **code-server**: VS Code in browser, pre-loaded with extensions
- **Azure ML CLI (v2)**: Manage workspaces and deploy models to endpoints
- **act**: Run and test GitHub Actions locally

**CI/CD & Delivery**
- **ArgoCD CLI**: GitOps-based deployments to Kubernetes
- **Flux CLI**: Alternative GitOps state synchronization
- **Tekton CLI (tkn)**: Cloud-native build pipelines
- **Skaffold**: Inner-loop K8s development
- **Tilt**: Live-reload K8s development

**Security & Secrets Management**
- **Vault CLI**: Application-level secrets and injection
- **Grype**: Container image vulnerability scanning
- **Snyk CLI**: Dependency vulnerability scanning
- **Checkov**: IaC security misconfiguration scanning (full install)
- **age / age-keygen**: File encryption
- **SOPS**: Encrypt secrets directly in Git repositories

### Inherited from Layer 1b (Read-Only)
- Terraform, OpenTofu, kubectl, k9s, stern
- AWS CLI, Azure CLI, gcloud
- Ansible, Helm, promtool, lazydocker

### Inherited from Layer 0 (System)
- zsh with Oh-My-Zsh, tmux, fzf, bat, zoxide
- neovim, jq, yq, tldr
- AI CLIs (Claude Code, Copilot, Codex, Gemini, OpenCode)

## Architecture Philosophy

**Cloud Bench = "Ground"**
- Infrastructure provisioning and state
- Cloud resource management

**Ops Bench = "Flow"**
- Deployment pipelines and delivery
- Security gates and secret management
- Inner-loop development on K8s

## Testing

```bash
cd devcontainer.test
docker compose up -d
docker compose exec test /test/test.sh
docker compose down
```

## Workspace Template

The `devcontainer.example` includes:
- VSCode devcontainer configuration
- Docker compose with host mounts
- Recommended VSCode extensions for ops work

## Version

- Layer: 2
- Type: ops-admin
- Version: 1.0.0
- Base: adminbench-base (Layer 1b)
