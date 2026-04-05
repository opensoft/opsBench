# OpsBench - Layer 2 Operations Bench

## Overview
OpsBench is a Layer 2 container image extending adminbench-base (Layer 1b) with deployment,
CI/CD, and shift-left security tooling.

## Architecture
- **Layer 0**: workbench-base (system tools, AI CLIs)
- **Layer 1b**: adminbench-base (Terraform, kubectl, cloud CLIs, Ansible)
- **Layer 2**: ops-bench (this bench - deployment, CI/CD, security)

## Tool Categories

### Deployment & AI Orchestration
- code-server: Browser-based VS Code with Azure ML, GitHub Copilot, K8s extensions
- Azure ML CLI v2: Model workspace and endpoint management
- act: Local GitHub Actions testing

### CI/CD & Delivery
- ArgoCD: GitOps deployments to Kubernetes
- Flux: GitOps state synchronization
- Tekton (tkn): Cloud-native pipelines
- Skaffold: K8s inner-loop development
- Tilt: Live-reload K8s development

### Security & Secrets
- Vault: Secret management and injection
- Grype: Container image vulnerability scanning
- Snyk: Dependency vulnerability scanning
- Checkov: IaC security scanning (full install only)
- age + SOPS: Git-native secret encryption

## Build
```bash
./build-layer2.sh --user $(whoami)
```

## Testing
```bash
cd devcontainer.test
docker compose up -d
docker compose exec test /test/test.sh
docker compose down
```

## Design Principle
Cloud Bench = "Ground" (infrastructure state), Ops Bench = "Flow" (delivery pipelines).
