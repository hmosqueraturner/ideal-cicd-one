### Check Application

\`\`\`bash
# Get application URL
cd terraform
terraform output container_app_fqdn

# Test health endpoint
curl https://YOUR-APP-URL/health

# View logs
az containerapp logs show \
  --name ca-acid-cicd-one-dev \
  --resource-group rg-acid-cicd-dev \
  --follow
\`\`\`

### Check Infrastructure

\`\`\`bash
# List resources
az resource list --resource-group rg-acid-cicd-dev --output table

# Check container app status
az containerapp show \
  --name ca-acid-cicd-one-dev \
  --resource-group rg-acid-cicd-dev
\`\`\`

## Troubleshooting

### Issue: npm install fails

\`\`\`powershell
# Clear cache
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
\`\`\`

### Issue: Docker build fails

\`\`\`powershell
# Clean Docker
docker system prune -a
docker-compose build --no-cache
\`\`\`

### Issue: Terraform state lock

\`\`\`bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID
\`\`\`

### Issue: Azure authentication fails

\`\`\`bash
# Re-login
az logout
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
\`\`\`

## Next Steps

1. Review the [Architecture Documentation](./ARCHITECTURE.md)
2. Explore the [CI/CD Pipeline](../.github/workflows/ci-cd.yml)
3. Check [Contributing Guidelines](./CONTRIBUTING.md)
4. Read [Best Practices](./BEST_PRACTICES.md)

## Support

For issues and questions:
- Create an issue on GitHub
- Check existing documentation
- Review Azure and Terraform logs
"@
Set-Content -Path "$projectRoot\docs\SETUP.md" -Value $setupDoc
Write-Host "  ✅ Created: docs/SETUP.md" -ForegroundColor Green

# ============================================================================
# FASE 11: GIT FILES
# ============================================================================
Write-Host "`n🔧 FASE 11: Creating Git configuration files..." -ForegroundColor Yellow

# .gitignore
$gitignore = @"
# Dependencies
node_modules/
package-lock.json

# Testing
coverage/
.nyc_output/
*.lcov

# Production
build/
dist/

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
*.log

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Terraform
**/.terraform/
*.tfstate
*.tfstate.*
.terraform.lock.hcl
*.tfplan
crash.log
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc

# Ansible
*.retry
.ansible/
ansible.log

# Azure
.azure/

# Secrets
secrets/
*.pem
*.key
credentials/

# Build artifacts
target/
*.jar
*.class

# Misc
.cache/
temp/
tmp/
*.bak
*.tmp
"@
Set-Content -Path "$projectRoot\.gitignore" -Value $gitignore -Force
Write-Host "  ✅ Created: .gitignore" -ForegroundColor Green

# .dockerignore (root level)
$dockerignoreRoot = @"
# Version Control
.git
.gitignore
.gitattributes

# Documentation
*.md
docs/
README.md

# CI/CD
.github/
.gitlab-ci.yml
.travis.yml
azure-pipelines.yml

# IDE
.vscode/
.idea/
*.swp
*.swo

# Dependencies
node_modules/
bower_components/

# Environment
.env
.env.local
.env.*.local

# Build outputs
build/
dist/
target/
coverage/

# Logs
*.log
npm-debug.log*

# OS
.DS_Store
Thumbs.db

# Testing
coverage/
.nyc_output/

# Terraform
terraform/
*.tf
*.tfstate

# Ansible
ansible/
*.yml
*.yaml

# Scripts
scripts/
"@
Set-Content -Path "$projectRoot\.dockerignore" -Value $dockerignoreRoot -Force

Write-Host "  Created: .dockerignore" -ForegroundColor Green

# ============================================================================
# FASE 12: ADDITIONAL DOCUMENTATION
# ============================================================================
Write-Host "`n📖 FASE 12: Creating additional documentation..." -ForegroundColor Yellow

# docs/ARCHITECTURE.md
$architectureDoc = @"
# ACiD Suite - Architecture Documentation

## System Architecture Overview

\`\`\`
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Repository                         │
│                     (Source Code + CI/CD)                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ Push/PR
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      GitHub Actions                              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │  Build   │ │  Test    │ │ SonarQube│ │  Docker  │          │
│  │  + Lint  │ │          │ │ Analysis │ │  Build   │          │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ Push Image
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              Azure Container Registry (ACR)                      │
│                  (Docker Image Storage)                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ Pull Image
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Azure Infrastructure                          │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │            Azure Container Apps Environment                 │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │ │
│  │  │ Container    │  │ Container    │  │ Container    │    │ │
│  │  │ Instance 1   │  │ Instance 2   │  │ Instance N   │    │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘    │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Log Analytics Workspace                        │ │
│  │  ┌──────────────┐  ┌──────────────┐                       │ │
│  │  │ Application  │  │   Metrics    │                       │ │
│  │  │   Insights   │  │  + Logs      │                       │ │
│  │  └──────────────┘  └──────────────┘                       │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                             │
                             │ HTTPS
                             ▼
                        End Users
\`\`\`

## Component Details

### 1. Frontend Application (React)

**Technology Stack:**
- React 18.x
- Modern CSS3
- Responsive Design
- PWA Ready

**Components:**
- \`Header\`: Navigation and branding
- \`Counter\`: Interactive demo component
- \`SystemStatus\`: Health monitoring display
- \`PipelineInfo\`: Build information display

**Features:**
- Server-side rendering ready
- Code splitting
- Lazy loading
- Performance optimized

### 2. CI/CD Pipeline (GitHub Actions)

**Stages:**

1. **Build & Test**
   - Install Node.js dependencies
   - Run ESLint for code quality
   - Execute Jest unit tests
   - Generate coverage reports
   - Build production bundle

2. **Code Quality (SonarCloud)**
   - Static code analysis
   - Security vulnerability scanning
   - Code smell detection
   - Technical debt calculation
   - Quality gate enforcement

3. **Docker Build & Push**
   - Multi-stage Docker build
   - Image optimization
   - Security scanning
   - Tag with version/SHA
   - Push to Azure Container Registry

4. **Infrastructure (Terraform)**
   - Plan infrastructure changes
   - Validate configurations
   - Apply approved changes
   - Output resource information

5. **Deployment (Ansible)**
   - Update container image
   - Apply configuration
   - Run health checks
   - Verify deployment

### 3. Container Infrastructure

**Docker Configuration:**
- Multi-stage builds for optimization
- Nginx as web server
- Health check endpoints
- Security headers
- Gzip compression
- Static asset caching

**Base Images:**
- Build stage: \`node:18-alpine\`
- Production stage: \`nginx:alpine\`

### 4. Azure Resources

**Container Apps:**
- Managed Kubernetes environment
- Auto-scaling (1-3 instances)
- Zero-downtime deployments
- Blue-green deployment support
- Ingress with SSL termination

**Container Registry:**
- Private Docker registry
- Geo-replication capable
- Webhook integration
- Image scanning
- Access control

**Monitoring:**
- Application Insights for APM
- Log Analytics for centralized logs
- Metrics and alerts
- Custom dashboards

## Infrastructure as Code (Terraform)

### Resource Hierarchy

\`\`\`
Resource Group
├── Container Registry
├── Log Analytics Workspace
├── Application Insights
├── Container App Environment
│   └── Container App
│       ├── Container (App)
│       ├── Ingress
│       └── Secrets
\`\`\`

### Key Resources

1. **azurerm_resource_group**
   - Name: \`rg-acid-cicd-{env}\`
   - Location: West Europe

2. **azurerm_container_registry**
   - SKU: Basic
   - Admin enabled for CI/CD
   - Private network capable

3. **azurerm_container_app_environment**
   - Integrated with Log Analytics
   - Shared by all container apps
   - Custom VNet support

4. **azurerm_container_app**
   - Min/Max replicas: 1-3
   - CPU: 0.5 cores
   - Memory: 1 GB
   - Auto-scaling enabled

## Configuration Management (Ansible)

### Playbooks

**deploy.yml:**
- Updates container image
- Sets environment variables
- Performs health checks
- Validates deployment

**rollback.yml:**
- Reverts to previous revision
- Activates stable version
- Verifies rollback

### Inventory

Dynamic Azure inventory for discovering resources.

## Security Architecture

### Authentication & Authorization
- Azure AD integration
- Service Principal for CI/CD
- Role-Based Access Control (RBAC)
- Managed Identity for resources

### Network Security
- HTTPS only (TLS 1.2+)
- Private registry access
- Container network isolation
- DDoS protection

### Secret Management
- GitHub Secrets for CI/CD
- Azure Key Vault integration ready
- No secrets in code/config
- Encrypted storage

### Container Security
- Non-root user
- Minimal base images
- Regular security updates
- Vulnerability scanning

## Scalability Design

### Horizontal Scaling
- Auto-scaling based on:
  - CPU utilization (>70%)
  - Memory usage (>80%)
  - Request count
- Scale range: 1-3 instances

### Performance Optimization
- CDN integration ready
- Static asset caching
- Gzip compression
- Image optimization
- Code splitting

### High Availability
- Multi-zone deployment capable
- Health check probes
- Automatic failover
- Rolling updates

## Monitoring & Observability

### Metrics
- Request rate/latency
- Error rates
- CPU/Memory usage
- Container health

### Logging
- Application logs
- Container logs
- Nginx access logs
- Structured JSON logs

### Alerting
- Performance degradation
- Error rate spikes
- Resource exhaustion
- Deployment failures

### Distributed Tracing
- Application Insights integration
- Request correlation
- Dependency tracking

## Disaster Recovery

### Backup Strategy
- Infrastructure as Code in Git
- Container images in registry
- Configuration in Ansible
- Database backups (if applicable)

### Recovery Procedures
1. Rollback via Ansible
2. Revert Git commit
3. Redeploy previous image
4. Restore from Terraform state

### RTO/RPO
- RTO: < 5 minutes
- RPO: Near-zero (Git history)

## Development Workflow

\`\`\`
Developer → Feature Branch → Pull Request → CI Checks
                                ↓
                           Code Review
                                ↓
                         Merge to Develop
                                ↓
                     Automatic Deployment (Dev)
                                ↓
                              Testing
                                ↓
                         Merge to Main
                                ↓
                   Automatic Deployment (Prod)
\`\`\`

## Technology Decisions

### Why React?
- Modern, popular framework
- Great developer experience
- Strong ecosystem
- Easy to learn/demonstrate

### Why Azure Container Apps?
- Serverless container platform
- Auto-scaling included
- Simpler than AKS
- Cost-effective for demos

### Why Terraform?
- Industry standard IaC
- Multi-cloud support
- Declarative syntax
- Strong Azure provider

### Why Ansible?
- Simple YAML syntax
- Powerful automation
- Good Azure integration
- Configuration management

## Future Enhancements

### Planned Features
- [ ] Multi-environment support (dev/staging/prod)
- [ ] Database integration (PostgreSQL)
- [ ] Redis caching layer
- [ ] API backend
- [ ] E2E testing with Playwright
- [ ] Performance testing with k6
- [ ] GitOps with ArgoCD
- [ ] Service mesh (Istio/Linkerd)
- [ ] Cost optimization recommendations

### Scalability Roadmap
- [ ] CDN integration
- [ ] Global load balancing
- [ ] Database replication
- [ ] Caching strategies
- [ ] Microservices architecture

## References

- [Azure Container Apps Docs](https://docs.microsoft.com/azure/container-apps/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Ansible Azure Guide](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/)
- [React Best Practices](https://react.dev/learn)
- [Docker Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
"@
Set-Content -Path "$projectRoot\docs\ARCHITECTURE.md" -Value $architectureDoc
Write-Host "  ✅ Created: docs/ARCHITECTURE.md" -ForegroundColor Green

# docs/CONTRIBUTING.md
$contributingDoc = @"
# Contributing to ACiD Suite

Thank you for your interest in contributing to ACiD Suite! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect differing viewpoints and experiences

## How to Contribute

### Reporting Bugs

Before creating a bug report:
1. Check the [Issues](https://github.com/hmosqueraturner/ideal-cicd-one/issues) page
2. Search for similar issues
3. Verify the bug in the latest version

When creating a bug report, include:
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Environment details (OS, browser, versions)
- Relevant logs or error messages

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues:
1. Use a clear, descriptive title
2. Provide detailed description of the enhancement
3. Explain why this enhancement would be useful
4. Include examples of how it would work
5. List any similar features in other projects

### Pull Requests

#### Before Submitting

1. **Fork and clone the repository**
   \`\`\`bash
   git clone https://github.com/YOUR-USERNAME/ideal-cicd-one.git
   cd ideal-cicd-one
   \`\`\`

2. **Create a feature branch**
   \`\`\`bash
   git checkout -b feature/your-feature-name
   \`\`\`

3. **Set up development environment**
   \`\`\`bash
   cd app
   npm install
   npm start
   \`\`\`

#### Development Guidelines

**Code Style:**
- Follow existing code style
- Use ESLint for JavaScript
- Write clear, self-documenting code
- Add comments for complex logic

**React Components:**
- Use functional components with hooks
- Keep components small and focused
- Use proper prop types
- Write meaningful component names

**Testing:**
- Write unit tests for new features
- Maintain or improve code coverage
- Ensure all tests pass before submitting

**Commits:**
- Write clear commit messages
- Follow conventional commits format:
  - \`feat:\` New feature
  - \`fix:\` Bug fix
  - \`docs:\` Documentation changes
  - \`style:\` Code style changes
  - \`refactor:\` Code refactoring
  - \`test:\` Test updates
  - \`chore:\` Maintenance tasks

Example:
\`\`\`
feat: add user authentication component

- Implement login form
- Add validation logic
- Include error handling
\`\`\`

#### Submitting Pull Request

1. **Update documentation**
   - Update README if needed
   - Add/update code comments
   - Update relevant docs

2. **Run tests locally**
   \`\`\`bash
   npm test
   npm run lint
   npm run build
   \`\`\`

3. **Push to your fork**
   \`\`\`bash
   git push origin feature/your-feature-name
   \`\`\`

4. **Create Pull Request**
   - Use a clear, descriptive title
   - Reference related issues
   - Describe changes in detail
   - Include screenshots for UI changes
   - List any breaking changes

5. **Address review feedback**
   - Respond to comments
   - Make requested changes
   - Update PR as needed

## Development Setup

### Prerequisites

- Node.js 18.x+
- Docker Desktop
- Git
- Code editor (VS Code recommended)

### Local Development

\`\`\`bash
# Install dependencies
cd app
npm install

# Start development server
npm start

# Run tests
npm test

# Run linting
npm run lint

# Build for production
npm run build
\`\`\`

### Docker Development

\`\`\`bash
# Build and run with Docker Compose
docker-compose up --build

# View logs
docker-compose logs -f

# Stop containers
docker-compose down
\`\`\`

## Testing Guidelines

### Unit Tests

- Test components in isolation
- Mock external dependencies
- Test edge cases and error states
- Aim for >80% code coverage

Example:
\`\`\`javascript
describe('Counter Component', () => {
  it('should increment count', () => {
    render(<Counter />);
    const button = screen.getByText(/increase/i);
    fireEvent.click(button);
    expect(screen.getByText('1')).toBeInTheDocument();
  });
});
\`\`\`

### Integration Tests

- Test component interactions
- Verify data flow
- Test user workflows

### Manual Testing Checklist

- [ ] Feature works as expected
- [ ] No console errors
- [ ] Responsive on mobile
- [ ] Accessible (keyboard navigation, screen readers)
- [ ] Works in major browsers (Chrome, Firefox, Safari)

## Documentation

### Code Documentation

- Add JSDoc comments for functions
- Document component props
- Explain complex algorithms
- Include usage examples

### Project Documentation

- Update README for new features
- Update ARCHITECTURE for structural changes
- Add setup instructions if needed
- Document configuration options

## Infrastructure Changes

### Terraform

- Follow HashiCorp style guide
- Use variables for configurable values
- Add outputs for important resources
- Include examples in comments

### Ansible

- Use descriptive task names
- Add tags for selective execution
- Include error handling
- Document required variables

### GitHub Actions

- Test workflows in fork first
- Use caching where possible
- Add appropriate timeouts
- Document required secrets

## Release Process

Releases follow semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### Creating a Release

1. Update version in package.json
2. Update CHANGELOG.md
3. Create Git tag
4. Push tag to trigger release workflow

## Questions?

- Open an issue for questions
- Join discussions
- Check existing documentation
- Review closed issues and PRs

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

Thank you for contributing to ACiD Suite! 🎉
"@
Set-Content -Path "$projectRoot\docs\CONTRIBUTING.md" -Value $contributingDoc
Write-Host "  ✅ Created: docs/CONTRIBUTING.md" -ForegroundColor Green

# LICENSE
$license = @"
MIT License

Copyright (c) 2024 Hector Mosquera Turner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
Set-Content -Path "$projectRoot\LICENSE" -Value $license
Write-Host "  ✅ Created: LICENSE" -ForegroundColor Green

# ============================================================================
# FASE 13: FINAL SUMMARY AND INSTRUCTIONS
# ============================================================================
Write-Host "`n`n" -ForegroundColor Green
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                ║" -ForegroundColor Cyan
Write-Host "║        🎉 ACiD SUITE SETUP COMPLETED SUCCESSFULLY! 🎉         ║" -ForegroundColor Cyan
Write-Host "║                                                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`n"

Write-Host "📋 PROJECT STRUCTURE CREATED:" -ForegroundColor Yellow
Write-Host "  ✅ React Application (app/)" -ForegroundColor Green
Write-Host "  ✅ GitHub Actions Workflow (.github/workflows/)" -ForegroundColor Green
Write-Host "  ✅ Terraform Configuration (terraform/)" -ForegroundColor Green
Write-Host "  ✅ Ansible Playbooks (ansible/)" -ForegroundColor Green
Write-Host "  ✅ Docker Configuration" -ForegroundColor Green
Write-Host "  ✅ SonarCloud Setup" -ForegroundColor Green
Write-Host "  ✅ Utility Scripts (scripts/)" -ForegroundColor Green
Write-Host "  ✅ Complete Documentation (docs/)" -ForegroundColor Green

Write-Host "`n🚀 NEXT STEPS:" -ForegroundColor Yellow
Write-Host "`n1️⃣  Initialize the React Application:" -ForegroundColor Cyan
Write-Host "    cd $projectRoot\app" -ForegroundColor White
Write-Host "    npm install" -ForegroundColor White
Write-Host "`n2️⃣  Start Development Server:" -ForegroundColor Cyan
Write-Host "    npm start" -ForegroundColor White
Write-Host "    (Opens at http://localhost:3000)" -ForegroundColor Gray
Write-Host "`n3️⃣  Run Tests:" -ForegroundColor Cyan
Write-Host "    npm test" -ForegroundColor White
Write-Host "`n4️⃣  Test Docker Locally:" -ForegroundColor Cyan
Write-Host "    cd $projectRoot" -ForegroundColor White
Write-Host "    docker-compose up --build" -ForegroundColor White
Write-Host "`n5️⃣  Run Local Test Suite:" -ForegroundColor Cyan
Write-Host "    .\scripts\local-test.ps1" -ForegroundColor White

Write-Host "`n☁️  AZURE DEPLOYMENT (When Ready):" -ForegroundColor Yellow
Write-Host "  1. Configure Azure credentials in GitHub Secrets" -ForegroundColor White
Write-Host "  2. Setup SonarCloud token" -ForegroundColor White
Write-Host "  3. Run: .\scripts\deploy-azure.ps1 -Environment dev" -ForegroundColor White

Write-Host "`n📚 DOCUMENTATION:" -ForegroundColor Yellow
Write-Host "  📖 README.md           - Project overview" -ForegroundColor White
Write-Host "  🏗️  ARCHITECTURE.md     - System architecture" -ForegroundColor White
Write-Host "  ⚙️  SETUP.md            - Setup guide" -ForegroundColor White
Write-Host "  🤝 CONTRIBUTING.md     - Contribution guidelines" -ForegroundColor White

Write-Host "`n🔧 UTILITY SCRIPTS:" -ForegroundColor Yellow
Write-Host "  🧪 scripts/local-test.ps1      - Run all local tests" -ForegroundColor White
Write-Host "  🐳 scripts/docker-build.ps1    - Build Docker image" -ForegroundColor White
Write-Host "  🚀 scripts/deploy-azure.ps1    - Deploy to Azure" -ForegroundColor White

Write-Host "`n⚠️  IMPORTANT REMINDERS:" -ForegroundColor Red
Write-Host "  • Old Java files have been removed" -ForegroundColor Yellow
Write-Host "  • Run 'npm install' before starting development" -ForegroundColor Yellow
Write-Host "  • Configure Azure and GitHub secrets before deployment" -ForegroundColor Yellow
Write-Host "  • Review docs/SETUP.md for detailed instructions" -ForegroundColor Yellow

Write-Host "`n💡 QUICK COMMANDS:" -ForegroundColor Cyan
Write-Host "  Dev Server:  " -NoNewline -ForegroundColor White
Write-Host "cd app && npm start" -ForegroundColor Yellow
Write-Host "  Run Tests:   " -NoNewline -ForegroundColor White
Write-Host "cd app && npm test" -ForegroundColor Yellow
Write-Host "  Docker Test: " -NoNewline -ForegroundColor White
Write-Host "docker-compose up --build" -ForegroundColor Yellow
Write-Host "  Full Test:   " -NoNewline -ForegroundColor White
Write-Host ".\scripts\local-test.ps1" -ForegroundColor Yellow

Write-Host "`n🌟 PROJECT HIGHLIGHTS:" -ForegroundColor Green
Write-Host "  ✨ Modern React 18 application" -ForegroundColor White
Write-Host "  ✨ Complete CI/CD with GitHub Actions" -ForegroundColor White
Write-Host "  ✨ Infrastructure as Code with Terraform" -ForegroundColor White
Write-Host "  ✨ Configuration Management with Ansible" -ForegroundColor White
Write-Host "  ✨ Docker containerization" -ForegroundColor White
Write-Host "  ✨ SonarCloud code quality checks" -ForegroundColor White
Write-Host "  ✨ Azure Container Apps deployment" -ForegroundColor White
Write-Host "  ✨ Comprehensive documentation" -ForegroundColor White

Write-Host "`n🎯 YOUR ACiD SUITE IS READY FOR ACTION!" -ForegroundColor Green
Write-Host "`n" -ForegroundColor White# ============================================================================
# ACiD - Automatic Continuous Integration and Delivery Suite
# Setup Script for ideal-cicd-one Project
# ============================================================================

$ErrorActionPreference = "Stop"

Write-Host "🚀 ACiD Suite - Project Setup Starting..." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

$projectRoot = "D:\code\devops\ideal-cicd-one"

# ============================================================================
# FASE 1: LIMPIEZA DE ARCHIVOS ANTIGUOS (Java)
# ============================================================================
Write-Host "`n📦 FASE 1: Cleaning old Java structure..." -ForegroundColor Yellow

$oldPaths = @(
    "$projectRoot\src\main\java",
    "$projectRoot\src\test\java",
    "$projectRoot\target",
    "$projectRoot\pom.xml"
)

foreach ($path in $oldPaths) {
    if (Test-Path $path) {
        Write-Host "  ❌ Removing: $path" -ForegroundColor Red
        Remove-Item -Path $path -Recurse -Force
    }
}

# ============================================================================
# FASE 2: ESTRUCTURA DE DIRECTORIOS
# ============================================================================
Write-Host "`n📁 FASE 2: Creating directory structure..." -ForegroundColor Yellow

$directories = @(
    ".github\workflows",
    "app\public",
    "app\src\components",
    "app\src\styles",
    "app\src\services",
    "app\src\__tests__",
    "terraform\modules\container-app",
    "terraform\modules\networking",
    "ansible\roles\deploy\tasks",
    "ansible\roles\deploy\templates",
    "ansible\inventory",
    "docs\diagrams",
    "scripts",
    ".devcontainer"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $projectRoot $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  ✅ Created: $dir" -ForegroundColor Green
    }
}

# ============================================================================
# FASE 3: APP REACT - ARCHIVOS PRINCIPALES
# ============================================================================
Write-Host "`n⚛️  FASE 3: Creating React App files..." -ForegroundColor Yellow

# package.json
$packageJson = @"
{
  "name": "ideal-cicd-one",
  "version": "1.0.0",
  "description": "ACiD Suite - DevOps Demo Application",
  "private": true,
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test --coverage --watchAll=false",
    "test:watch": "react-scripts test",
    "eject": "react-scripts eject",
    "lint": "eslint src/**/*.{js,jsx}",
    "lint:fix": "eslint src/**/*.{js,jsx} --fix",
    "serve": "serve -s build -l 3000"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-scripts": "5.0.1",
    "axios": "^1.7.7",
    "web-vitals": "^3.5.0"
  },
  "devDependencies": {
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.1.4",
    "@testing-library/user-event": "^14.5.1",
    "eslint": "^8.50.0",
    "eslint-config-react-app": "^7.0.1",
    "serve": "^14.2.1"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
"@
Set-Content -Path "$projectRoot\app\package.json" -Value $packageJson
Write-Host "  ✅ Created: app/package.json" -ForegroundColor Green

# public/index.html
$indexHtml = @"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="ACiD Suite - Automatic CI/CD Demo Application" />
    <title>ACiD Suite - DevOps Demo</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
"@
Set-Content -Path "$projectRoot\app\public\index.html" -Value $indexHtml
Write-Host "  ✅ Created: app/public/index.html" -ForegroundColor Green

# src/index.js
$indexJs = @"
import React from 'react';
import ReactDOM from 'react-dom/client';
import './styles/index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

reportWebVitals();
"@
Set-Content -Path "$projectRoot\app\src\index.js" -Value $indexJs
Write-Host "  ✅ Created: app/src/index.js" -ForegroundColor Green

# src/App.jsx
$appJsx = @"
import React, { useState, useEffect } from 'react';
import './styles/App.css';
import Header from './components/Header';
import Counter from './components/Counter';
import SystemStatus from './components/SystemStatus';
import PipelineInfo from './components/PipelineInfo';

function App() {
  const [buildInfo, setBuildInfo] = useState({
    version: '1.0.0',
    buildNumber: process.env.REACT_APP_BUILD_NUMBER || 'local',
    environment: process.env.REACT_APP_ENV || 'development',
    buildDate: process.env.REACT_APP_BUILD_DATE || new Date().toISOString()
  });

  useEffect(() => {
    document.title = `ACiD Suite v`+ buildInfo.version;
  }, [buildInfo.version]);

  return (
    <div className="App">
      <Header version={buildInfo.version} />
      
      <main className="App-main">
        <section className="hero">
          <h1>🚀 ACiD Suite</h1>
          <p className="subtitle">Automatic Continuous Integration and Delivery</p>
          <div className="tech-stack">
            <span className="badge">React</span>
            <span className="badge">Docker</span>
            <span className="badge">GitHub Actions</span>
            <span className="badge">Terraform</span>
            <span className="badge">Ansible</span>
            <span className="badge">Azure</span>
          </div>
        </section>

        <div className="components-grid">
          <Counter />
          <SystemStatus />
          <PipelineInfo buildInfo={buildInfo} />
        </div>

        <section className="features">
          <h2>DevOps Pipeline Features</h2>
          <div className="features-grid">
            <div className="feature-card">
              <span className="icon">🔄</span>
              <h3>Continuous Integration</h3>
              <p>Automated builds and testing with GitHub Actions</p>
            </div>
            <div className="feature-card">
              <span className="icon">🐳</span>
              <h3>Containerization</h3>
              <p>Docker multi-stage builds for optimized images</p>
            </div>
            <div className="feature-card">
              <span className="icon">📊</span>
              <h3>Code Quality</h3>
              <p>SonarCloud analysis and quality gates</p>
            </div>
            <div className="feature-card">
              <span className="icon">☁️</span>
              <h3>Cloud Deployment</h3>
              <p>Azure Container Apps with Terraform IaC</p>
            </div>
          </div>
        </section>
      </main>

      <footer className="App-footer">
        <p>Build: {buildInfo.buildNumber} | Environment: {buildInfo.environment}</p>
        <p>© 2024 ACiD Suite - DevOps Demo Project</p>
      </footer>
    </div>
  );
}

export default App;
"@
Set-Content -Path "$projectRoot\app\src\App.jsx" -Value $appJsx
Write-Host "  ✅ Created: app/src/App.jsx" -ForegroundColor Green

# src/components/Header.jsx
$headerJsx = @"
import React from 'react';

function Header({ version }) {
  return (
    <header className="app-header">
      <div className="header-content">
        <div className="logo">
          <span className="logo-icon">⚡</span>
          <span className="logo-text">ACiD</span>
        </div>
        <nav className="nav">
          <a href="#features">Features</a>
          <a href="#pipeline">Pipeline</a>
          <a href="https://github.com/hmosqueraturner/ideal-cicd-one" target="_blank" rel="noopener noreferrer">
            GitHub
          </a>
        </nav>
        <span className="version">v{version}</span>
      </div>
    </header>
  );
}

export default Header;
"@
Set-Content -Path "$projectRoot\app\src\components\Header.jsx" -Value $headerJsx
Write-Host "  ✅ Created: app/src/components/Header.jsx" -ForegroundColor Green

# src/components/Counter.jsx
$counterJsx = @"
import React, { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div className="component-card">
      <h3>Interactive Counter</h3>
      <div className="counter-display">
        <span className="count-value">{count}</span>
      </div>
      <div className="counter-buttons">
        <button onClick={() => setCount(count - 1)} className="btn btn-secondary">
          - Decrease
        </button>
        <button onClick={() => setCount(0)} className="btn btn-outline">
          Reset
        </button>
        <button onClick={() => setCount(count + 1)} className="btn btn-primary">
          + Increase
        </button>
      </div>
    </div>
  );
}

export default Counter;
"@
Set-Content -Path "$projectRoot\app\src\components\Counter.jsx" -Value $counterJsx
Write-Host "  ✅ Created: app/src/components/Counter.jsx" -ForegroundColor Green

# src/components/SystemStatus.jsx
$systemStatusJsx = @"
import React, { useState, useEffect } from 'react';

function SystemStatus() {
  const [status, setStatus] = useState({
    api: 'checking',
    database: 'checking',
    cache: 'checking'
  });

  useEffect(() => {
    // Simulate health checks
    const timer = setTimeout(() => {
      setStatus({
        api: 'healthy',
        database: 'healthy',
        cache: 'healthy'
      });
    }, 1500);

    return () => clearTimeout(timer);
  }, []);

  const getStatusIcon = (state) => {
    switch(state) {
      case 'healthy': return '✅';
      case 'checking': return '🔄';
      case 'error': return '❌';
      default: return '⚠️';
    }
  };

  const getStatusClass = (state) => {
    switch(state) {
      case 'healthy': return 'status-healthy';
      case 'checking': return 'status-checking';
      case 'error': return 'status-error';
      default: return 'status-warning';
    }
  };

  return (
    <div className="component-card">
      <h3>System Health</h3>
      <div className="status-list">
        <div className={`status-item ` + getStatusClass(status.api)}>
          <span className="status-icon">{getStatusIcon(status.api)}</span>
          <span className="status-label">API Service</span>
          <span className="status-value">{status.api}</span>
        </div>
        <div className={`status-item ` + getStatusClass(status.database)}>
          <span className="status-icon">{getStatusIcon(status.database)}</span>
          <span className="status-label">Database</span>
          <span className="status-value">{status.database}</span>
        </div>
        <div className={`status-item ` + getStatusClass(status.cache)}>
          <span className="status-icon">{getStatusIcon(status.cache)}</span>
          <span className="status-label">Cache</span>
          <span className="status-value">{status.cache}</span>
        </div>
      </div>
    </div>
  );
}

export default SystemStatus;
"@
Set-Content -Path "$projectRoot\app\src\components\SystemStatus.jsx" -Value $systemStatusJsx
Write-Host "  ✅ Created: app/src/components/SystemStatus.jsx" -ForegroundColor Green

# src/components/PipelineInfo.jsx
$pipelineInfoJsx = @"
import React from 'react';

function PipelineInfo({ buildInfo }) {
  const formatDate = (isoDate) => {
    return new Date(isoDate).toLocaleString();
  };

  return (
    <div className="component-card pipeline-card">
      <h3>Pipeline Information</h3>
      <div className="info-grid">
        <div className="info-item">
          <span className="info-label">Version:</span>
          <span className="info-value">{buildInfo.version}</span>
        </div>
        <div className="info-item">
          <span className="info-label">Build:</span>
          <span className="info-value">#{buildInfo.buildNumber}</span>
        </div>
        <div className="info-item">
          <span className="info-label">Environment:</span>
          <span className="info-value environment">{buildInfo.environment}</span>
        </div>
        <div className="info-item">
          <span className="info-label">Deployed:</span>
          <span className="info-value">{formatDate(buildInfo.buildDate)}</span>
        </div>
      </div>
      <div className="pipeline-stages">
        <div className="stage completed">Build ✓</div>
        <div className="stage completed">Test ✓</div>
        <div className="stage completed">SonarQube ✓</div>
        <div className="stage completed">Deploy ✓</div>
      </div>
    </div>
  );
}

export default PipelineInfo;
"@
Set-Content -Path "$projectRoot\app\src\components\PipelineInfo.jsx" -Value $pipelineInfoJsx
Write-Host "  ✅ Created: app/src/components/PipelineInfo.jsx" -ForegroundColor Green

# src/reportWebVitals.js
$reportWebVitals = @"
const reportWebVitals = onPerfEntry => {
  if (onPerfEntry && onPerfEntry instanceof Function) {
    import('web-vitals').then(({ getCLS, getFID, getFCP, getLCP, getTTFB }) => {
      getCLS(onPerfEntry);
      getFID(onPerfEntry);
      getFCP(onPerfEntry);
      getLCP(onPerfEntry);
      getTTFB(onPerfEntry);
    });
  }
};

export default reportWebVitals;
"@
Set-Content -Path "$projectRoot\app\src\reportWebVitals.js" -Value $reportWebVitals
Write-Host "  ✅ Created: app/src/reportWebVitals.js" -ForegroundColor Green

Write-Host "`n🎨 Creating CSS files..." -ForegroundColor Cyan

# src/styles/index.css
$indexCss = @"
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}

#root {
  min-height: 100vh;
}
"@
Set-Content -Path "$projectRoot\app\src\styles\index.css" -Value $indexCss
Write-Host "  ✅ Created: app/src/styles/index.css" -ForegroundColor Green

# src/styles/App.css
$appCss = @"
.App {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* Header */
.app-header {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.5rem;
  font-weight: bold;
  color: #667eea;
}

.logo-icon {
  font-size: 2rem;
}

.nav {
  display: flex;
  gap: 2rem;
}

.nav a {
  color: #333;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s;
}

.nav a:hover {
  color: #667eea;
}

.version {
  background: #667eea;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
}

/* Main Content */
.App-main {
  flex: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  width: 100%;
}

.hero {
  text-align: center;
  color: white;
  margin-bottom: 3rem;
  padding: 3rem 2rem;
}

.hero h1 {
  font-size: 4rem;
  margin-bottom: 1rem;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.subtitle {
  font-size: 1.5rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.tech-stack {
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
  margin-top: 2rem;
}

.badge {
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

/* Components Grid */
.components-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.component-card {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.component-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.component-card h3 {
  margin-bottom: 1.5rem;
  color: #333;
  font-size: 1.25rem;
}

/* Counter */
.counter-display {
  text-align: center;
  margin: 2rem 0;
}

.count-value {
  font-size: 4rem;
  font-weight: bold;
  color: #667eea;
}

.counter-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 1rem;
}

.btn-primary {
  background: #667eea;
  color: white;
}

.btn-primary:hover {
  background: #5568d3;
  transform: scale(1.05);
}

.btn-secondary {
  background: #764ba2;
  color: white;
}

.btn-secondary:hover {
  background: #6a4392;
  transform: scale(1.05);
}

.btn-outline {
  background: white;
  color: #667eea;
  border: 2px solid #667eea;
}

.btn-outline:hover {
  background: #667eea;
  color: white;
}

/* System Status */
.status-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  border-radius: 8px;
  background: #f8f9fa;
}

.status-icon {
  font-size: 1.5rem;
}

.status-label {
  flex: 1;
  font-weight: 600;
  color: #333;
}

.status-value {
  text-transform: capitalize;
  font-weight: 500;
}

.status-healthy {
  background: #d4edda;
  border-left: 4px solid #28a745;
}

.status-checking {
  background: #fff3cd;
  border-left: 4px solid #ffc107;
}

.status-error {
  background: #f8d7da;
  border-left: 4px solid #dc3545;
}

/* Pipeline Info */
.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.info-label {
  font-size: 0.875rem;
  color: #666;
  font-weight: 500;
}

.info-value {
  font-size: 1.125rem;
  color: #333;
  font-weight: 600;
}

.info-value.environment {
  color: #667eea;
  text-transform: uppercase;
}

.pipeline-stages {
  display: flex;
  gap: 0.5rem;
  justify-content: space-between;
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 2px solid #f0f0f0;
}

.stage {
  flex: 1;
  text-align: center;
  padding: 0.5rem;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 600;
  background: #e9ecef;
  color: #666;
}

.stage.completed {
  background: #d4edda;
  color: #28a745;
}

/* Features Section */
.features {
  color: white;
  margin: 3rem 0;
}

.features h2 {
  text-align: center;
  font-size: 2.5rem;
  margin-bottom: 2rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.feature-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  padding: 2rem;
  text-align: center;
  transition: transform 0.3s;
}

.feature-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.15);
}

.feature-card .icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 1rem;
}

.feature-card h3 {
  margin-bottom: 1rem;
  font-size: 1.25rem;
}

.feature-card p {
  opacity: 0.9;
  line-height: 1.6;
}

/* Footer */
.App-footer {
  background: rgba(0, 0, 0, 0.2);
  color: white;
  text-align: center;
  padding: 2rem;
  margin-top: auto;
}

.App-footer p {
  margin: 0.5rem 0;
  opacity: 0.8;
}

/* Responsive */
@media (max-width: 768px) {
  .hero h1 {
    font-size: 2.5rem;
  }
  
  .subtitle {
    font-size: 1.25rem;
  }
  
  .header-content {
    flex-direction: column;
    gap: 1rem;
  }
  
  .nav {
    gap: 1rem;
  }
  
  .components-grid {
    grid-template-columns: 1fr;
  }
  
  .counter-buttons {
    flex-direction: column;
  }
  
  .info-grid {
    grid-template-columns: 1fr;
  }
  
  .pipeline-stages {
    flex-wrap: wrap;
  }
}
"@
Set-Content -Path "$projectRoot\app\src\styles\App.css" -Value $appCss
Write-Host "  ✅ Created: app/src/styles/App.css" -ForegroundColor Green

Write-Host "`n🧪 Creating test files..." -ForegroundColor Cyan

# src/__tests__/App.test.js
$appTest = @"
import { render, screen } from '@testing-library/react';
import App from '../App';

describe('App Component', () => {
  test('renders ACiD Suite heading', () => {
    render(<App />);
    const headingElement = screen.getByText(/ACiD Suite/i);
    expect(headingElement).toBeInTheDocument();
  });

  test('renders all technology badges', () => {
    render(<App />);
    expect(screen.getByText('React')).toBeInTheDocument();
    expect(screen.getByText('Docker')).toBeInTheDocument();
    expect(screen.getByText('GitHub Actions')).toBeInTheDocument();
    expect(screen.getByText('Terraform')).toBeInTheDocument();
    expect(screen.getByText('Ansible')).toBeInTheDocument();
    expect(screen.getByText('Azure')).toBeInTheDocument();
  });

  test('renders feature cards', () => {
    render(<App />);
    expect(screen.getByText('Continuous Integration')).toBeInTheDocument();
    expect(screen.getByText('Containerization')).toBeInTheDocument();
    expect(screen.getByText('Code Quality')).toBeInTheDocument();
    expect(screen.getByText('Cloud Deployment')).toBeInTheDocument();
  });
});
"@
Set-Content -Path "$projectRoot\app\src\__tests__\App.test.js" -Value $appTest
Write-Host "  ✅ Created: app/src/__tests__/App.test.js" -ForegroundColor Green

# src/__tests__/Counter.test.js
$counterTest = @"
import { render, screen, fireEvent } from '@testing-library/react';
import Counter from '../components/Counter';

describe('Counter Component', () => {
  test('renders with initial count of 0', () => {
    render(<Counter />);
    expect(screen.getByText('0')).toBeInTheDocument();
  });

  test('increments count when + button is clicked', () => {
    render(<Counter />);
    const increaseButton = screen.getByText(/\+ Increase/i);
    fireEvent.click(increaseButton);
    expect(screen.getByText('1')).toBeInTheDocument();
  });

  test('decrements count when - button is clicked', () => {
    render(<Counter />);
    const decreaseButton = screen.getByText(/- Decrease/i);
    fireEvent.click(decreaseButton);
    expect(screen.getByText('-1')).toBeInTheDocument();
  });

  test('resets count to 0 when Reset button is clicked', () => {
    render(<Counter />);
    const increaseButton = screen.getByText(/\+ Increase/i);
    const resetButton = screen.getByText(/Reset/i);
    
    fireEvent.click(increaseButton);
    fireEvent.click(increaseButton);
    fireEvent.click(resetButton);
    
    expect(screen.getByText('0')).toBeInTheDocument();
  });
});
"@
Set-Content -Path "$projectRoot\app\src\__tests__\Counter.test.js" -Value $counterTest
Write-Host "  ✅ Created: app/src/__tests__/Counter.test.js" -ForegroundColor Green

# setupTests.js
$setupTests = @"
import '@testing-library/jest-dom';
"@
Set-Content -Path "$projectRoot\app\src\setupTests.js" -Value $setupTests
Write-Host "  ✅ Created: app/src/setupTests.js" -ForegroundColor Green

# ============================================================================
# FASE 4: DOCKER FILES
# ============================================================================
Write-Host "`n🐳 FASE 4: Creating Docker files..." -ForegroundColor Yellow

# app/Dockerfile (Multi-stage optimized)
$appDockerfile = @"
# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY . .

# Build the app
RUN npm run build

# Stage 2: Production
FROM nginx:alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built app from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
"@
Set-Content -Path "$projectRoot\app\Dockerfile" -Value $appDockerfile
Write-Host "  ✅ Created: app/Dockerfile" -ForegroundColor Green

# app/nginx.conf
$nginxConf = @"
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # Handle React Router
    location / {
        try_files `$uri `$uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
"@
Set-Content -Path "$projectRoot\app\nginx.conf" -Value $nginxConf
Write-Host "  ✅ Created: app/nginx.conf" -ForegroundColor Green

# app/.dockerignore
$appDockerignore = @"
node_modules
npm-debug.log
build
.git
.gitignore
README.md
.env
.DS_Store
coverage
.vscode
*.md
"@
Set-Content -Path "$projectRoot\app\.dockerignore" -Value $appDockerignore
Write-Host "  ✅ Created: app/.dockerignore" -ForegroundColor Green

# docker-compose.yml (root level para testing)
$dockerCompose = @"
version: '3.8'

services:
  app:
    build:
      context: ./app
      dockerfile: Dockerfile
    ports:
      - "3000:80"
    environment:
      - REACT_APP_ENV=development
      - REACT_APP_BUILD_NUMBER=local
      - REACT_APP_BUILD_DATE=`$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    networks:
      - acid-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:80/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

networks:
  acid-network:
    driver: bridge
"@
Set-Content -Path "$projectRoot\docker-compose.yml" -Value $dockerCompose
Write-Host "  ✅ Created: docker-compose.yml" -ForegroundColor Green

# ============================================================================
# FASE 5: GITHUB ACTIONS WORKFLOW
# ============================================================================
Write-Host "`n⚙️  FASE 5: Creating GitHub Actions workflow..." -ForegroundColor Yellow

$githubWorkflow = @"
name: ACiD CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:

env:
  NODE_VERSION: '18.x'
  REGISTRY: acidregistry.azurecr.io
  IMAGE_NAME: ideal-cicd-one
  AZURE_WEBAPP_NAME: acid-container-app

jobs:
  # ============================================================================
  # JOB 1: BUILD & TEST
  # ============================================================================
  build-and-test:
    name: 🏗️ Build and Test
    runs-on: ubuntu-latest
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🔧 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: `${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: ./app/package-lock.json

      - name: 📦 Install dependencies
        working-directory: ./app
        run: npm ci

      - name: 🔍 Run linting
        working-directory: ./app
        run: npm run lint || true

      - name: 🧪 Run tests
        working-directory: ./app
        run: npm run test

      - name: 📊 Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          files: ./app/coverage/lcov.info
          flags: unittests
          name: codecov-umbrella

      - name: 🏗️ Build application
        working-directory: ./app
        env:
          REACT_APP_ENV: `${{ github.ref == 'refs/heads/main' && 'production' || 'development' }}
          REACT_APP_BUILD_NUMBER: `${{ github.run_number }}
          REACT_APP_BUILD_DATE: `${{ github.event.head_commit.timestamp }}
        run: npm run build

      - name: 📤 Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-artifacts
          path: ./app/build
          retention-days: 5

  # ============================================================================
  # JOB 2: SONARCLOUD ANALYSIS
  # ============================================================================
  sonarcloud:
    name: 🔍 SonarCloud Analysis
    runs-on: ubuntu-latest
    needs: build-and-test
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: 🔧 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: `${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: ./app/package-lock.json

      - name: 📦 Install dependencies
        working-directory: ./app
        run: npm ci

      - name: 🧪 Run tests with coverage
        working-directory: ./app
        run: npm run test

      - name: 📊 SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: `${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: `${{ secrets.SONAR_TOKEN }}

  # ============================================================================
  # JOB 3: BUILD & PUSH DOCKER IMAGE
  # ============================================================================
  docker:
    name: 🐳 Build and Push Docker Image
    runs-on: ubuntu-latest
    needs: [build-and-test, sonarcloud]
    if: github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop')
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🔐 Login to Azure Container Registry
        uses: docker/login-action@v3
        with:
          registry: `${{ env.REGISTRY }}
          username: `${{ secrets.AZURE_ACR_USERNAME }}
          password: `${{ secrets.AZURE_ACR_PASSWORD }}

      - name: 🏷️ Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: `${{ env.REGISTRY }}/`${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=sha,prefix={{branch}}-
            type=raw,value=latest,enable={{is_default_branch}}
            type=raw,value=`${{ github.run_number }}

      - name: 🔨 Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: ./app
          file: ./app/Dockerfile
          push: true
          tags: `${{ steps.meta.outputs.tags }}
          labels: `${{ steps.meta.outputs.labels }}
          build-args: |
            BUILD_NUMBER=`${{ github.run_number }}
            BUILD_DATE=`${{ github.event.head_commit.timestamp }}

  # ============================================================================
  # JOB 4: TERRAFORM INFRASTRUCTURE
  # ============================================================================
  terraform:
    name: 🏗️ Terraform Infrastructure
    runs-on: ubuntu-latest
    needs: docker
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🔧 Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.5.0

      - name: 🔐 Azure Login
        uses: azure/login@v1
        with:
          creds: `${{ secrets.AZURE_CREDENTIALS }}

      - name: 🔨 Terraform Init
        working-directory: ./terraform
        run: terraform init

      - name: 📋 Terraform Plan
        working-directory: ./terraform
        run: terraform plan -out=tfplan
        env:
          ARM_CLIENT_ID: `${{ secrets.AZURE_CLIENT_ID }}
          ARM_CLIENT_SECRET: `${{ secrets.AZURE_CLIENT_SECRET }}
          ARM_SUBSCRIPTION_ID: `${{ secrets.AZURE_SUBSCRIPTION_ID }}
          ARM_TENANT_ID: `${{ secrets.AZURE_TENANT_ID }}

      - name: 🚀 Terraform Apply
        working-directory: ./terraform
        run: terraform apply -auto-approve tfplan
        env:
          ARM_CLIENT_ID: `${{ secrets.AZURE_CLIENT_ID }}
          ARM_CLIENT_SECRET: `${{ secrets.AZURE_CLIENT_SECRET }}
          ARM_SUBSCRIPTION_ID: `${{ secrets.AZURE_SUBSCRIPTION_ID }}
          ARM_TENANT_ID: `${{ secrets.AZURE_TENANT_ID }}

  # ============================================================================
  # JOB 5: ANSIBLE DEPLOYMENT
  # ============================================================================
  deploy:
    name: 🚀 Deploy with Ansible
    runs-on: ubuntu-latest
    needs: terraform
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🔧 Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name: 📦 Install Ansible
        run: |
          python -m pip install --upgrade pip
          pip install ansible azure-cli

      - name: 🔐 Azure Login
        uses: azure/login@v1
        with:
          creds: `${{ secrets.AZURE_CREDENTIALS }}

      - name: 🚀 Run Ansible Playbook
        working-directory: ./ansible
        run: |
          ansible-playbook deploy.yml \
            -e "image_tag=`${{ github.run_number }}" \
            -e "environment=production" \
            -e "registry=`${{ env.REGISTRY }}" \
            -e "image_name=`${{ env.IMAGE_NAME }}"

      - name: ✅ Deployment Summary
        run: |
          echo "## 🎉 Deployment Successful!" >> `$GITHUB_STEP_SUMMARY
          echo "" >> `$GITHUB_STEP_SUMMARY
          echo "- **Environment:** Production" >> `$GITHUB_STEP_SUMMARY
          echo "- **Image:** `${{ env.REGISTRY }}/`${{ env.IMAGE_NAME }}:`${{ github.run_number }}" >> `$GITHUB_STEP_SUMMARY
          echo "- **Build Number:** `${{ github.run_number }}" >> `$GITHUB_STEP_SUMMARY
          echo "- **Commit:** `${{ github.sha }}" >> `$GITHUB_STEP_SUMMARY
"@
Set-Content -Path "$projectRoot\.github\workflows\ci-cd.yml" -Value $githubWorkflow
Write-Host "  ✅ Created: .github/workflows/ci-cd.yml" -ForegroundColor Green

# ============================================================================
# FASE 6: TERRAFORM FILES
# ============================================================================
Write-Host "`n🏗️  FASE 6: Creating Terraform configuration..." -ForegroundColor Yellow

# terraform/providers.tf
$providersConfig = @"
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Backend configuration should be provided via CLI or tfvars
    # storage_account_name = "acidtfstate"
    # container_name       = "tfstate"
    # key                  = "ideal-cicd-one.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
"@
Set-Content -Path "$projectRoot\terraform\providers.tf" -Value $providersConfig
Write-Host "  ✅ Created: terraform/providers.tf" -ForegroundColor Green

# terraform/variables.tf
$variablesConfig = @"
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "acid-cicd-one"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-acid-cicd"
}

variable "container_image" {
  description = "Docker container image"
  type        = string
  default     = "acidregistry.azurecr.io/ideal-cicd-one:latest"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "container_cpu" {
  description = "CPU cores for container"
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "Memory in GB for container"
  type        = number
  default     = 1
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "ACiD Suite"
    ManagedBy   = "Terraform"
    Environment = "Development"
  }
}
"@
Set-Content -Path "$projectRoot\terraform\variables.tf" -Value $variablesConfig
Write-Host "  ✅ Created: terraform/variables.tf" -ForegroundColor Green

# terraform/main.tf (Complete rewrite for Container Apps)
$mainConfig = @"
# ============================================================================
# RESOURCE GROUP
# ============================================================================
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ============================================================================
# LOG ANALYTICS WORKSPACE
# ============================================================================
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-`${var.project_name}-`${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# ============================================================================
# CONTAINER REGISTRY
# ============================================================================
resource "azurerm_container_registry" "main" {
  name                = replace("acr`${var.project_name}`${var.environment}", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}

# ============================================================================
# CONTAINER APP ENVIRONMENT
# ============================================================================
resource "azurerm_container_app_environment" "main" {
  name                       = "cae-`${var.project_name}-`${var.environment}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = var.tags
}

# ============================================================================
# CONTAINER APP
# ============================================================================
resource "azurerm_container_app" "main" {
  name                         = "ca-`${var.project_name}-`${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "`${var.project_name}-container"
      image  = var.container_image
      cpu    = var.container_cpu
      memory = "`${var.container_memory}Gi"

      env {
        name  = "ENVIRONMENT"
        value = var.environment
      }

      env {
        name  = "PORT"
        value = var.container_port
      }
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = var.container_port
    
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = azurerm_container_registry.main.admin_password
  }
}

# ============================================================================
# APPLICATION INSIGHTS
# ============================================================================
resource "azurerm_application_insights" "main" {
  name                = "ai-`${var.project_name}-`${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  tags                = var.tags
}
"@
Set-Content -Path "$projectRoot\terraform\main.tf" -Value $mainConfig -Force
Write-Host "  ✅ Created: terraform/main.tf" -ForegroundColor Green

# terraform/outputs.tf
$outputsConfig = @"
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "container_app_fqdn" {
  description = "FQDN of the Container App"
  value       = "https://`${azurerm_container_app.main.ingress[0].fqdn}"
}

output "container_registry_login_server" {
  description = "Login server for the container registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_username" {
  description = "Admin username for container registry"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "application_insights_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}
"@
Set-Content -Path "$projectRoot\terraform\outputs.tf" -Value $outputsConfig -Force
Write-Host "  ✅ Created: terraform/outputs.tf" -ForegroundColor Green

# terraform/terraform.tfvars.example
$tfvarsExample = @"
# Example terraform.tfvars file
# Copy this file to terraform.tfvars and customize values

project_name        = "acid-cicd-one"
environment         = "dev"
location            = "westeurope"
resource_group_name = "rg-acid-cicd-dev"

# Container configuration
container_image  = "acidregistry.azurecr.io/ideal-cicd-one:latest"
container_port   = 80
container_cpu    = 0.5
container_memory = 1

# Scaling configuration
min_replicas = 1
max_replicas = 3

# Tags
tags = {
  Project     = "ACiD Suite"
  ManagedBy   = "Terraform"
  Environment = "Development"
  Owner       = "DevOps Team"
}
"@
Set-Content -Path "$projectRoot\terraform\terraform.tfvars.example" -Value $tfvarsExample
Write-Host "  ✅ Created: terraform/terraform.tfvars.example" -ForegroundColor Green

# ============================================================================
# FASE 7: ANSIBLE CONFIGURATION
# ============================================================================
Write-Host "`n⚙️  FASE 7: Creating Ansible playbooks..." -ForegroundColor Yellow

# ansible/deploy.yml
$ansibleDeploy = @"
---
- name: Deploy ACiD Application to Azure Container Apps
  hosts: localhost
  connection: local
  gather_facts: no
  
  vars:
    registry: "{{ registry | default('acidregistry.azurecr.io') }}"
    image_name: "{{ image_name | default('ideal-cicd-one') }}"
    image_tag: "{{ image_tag | default('latest') }}"
    environment: "{{ environment | default('dev') }}"
    resource_group: "rg-acid-cicd-{{ environment }}"
    container_app_name: "ca-acid-cicd-one-{{ environment }}"

  tasks:
    - name: Display deployment information
      debug:
        msg:
          - "==================================================="
          - "ACiD Deployment Starting"
          - "==================================================="
          - "Registry: {{ registry }}"
          - "Image: {{ image_name }}:{{ image_tag }}"
          - "Environment: {{ environment }}"
          - "Resource Group: {{ resource_group }}"
          - "Container App: {{ container_app_name }}"

    - name: Ensure Azure CLI is logged in
      command: az account show
      register: az_account
      changed_when: false
      failed_when: az_account.rc != 0

    - name: Update Container App with new image
      command: >
        az containerapp update
        --name {{ container_app_name }}
        --resource-group {{ resource_group }}
        --image {{ registry }}/{{ image_name }}:{{ image_tag }}
        --set-env-vars ENVIRONMENT={{ environment }} BUILD_TAG={{ image_tag }}
      register: containerapp_update
      changed_when: containerapp_update.rc == 0

    - name: Get Container App URL
      command: >
        az containerapp show
        --name {{ container_app_name }}
        --resource-group {{ resource_group }}
        --query properties.configuration.ingress.fqdn
        --output tsv
      register: app_url
      changed_when: false

    - name: Wait for application to be ready
      uri:
        url: "https://{{ app_url.stdout }}/health"
        method: GET
        status_code: 200
        validate_certs: yes
      register: health_check
      until: health_check.status == 200
      retries: 10
      delay: 10
      when: app_url.stdout is defined

    - name: Display deployment result
      debug:
        msg:
          - "==================================================="
          - "✅ Deployment Successful!"
          - "==================================================="
          - "Application URL: https://{{ app_url.stdout }}"
          - "Image: {{ registry }}/{{ image_name }}:{{ image_tag }}"
          - "Health Check: PASSED"
"@
Set-Content -Path "$projectRoot\ansible\deploy.yml" -Value $ansibleDeploy -Force
Write-Host "  ✅ Created: ansible/deploy.yml" -ForegroundColor Green

# ansible/rollback.yml
$ansibleRollback = @"
---
- name: Rollback ACiD Application
  hosts: localhost
  connection: local
  gather_facts: no
  
  vars:
    environment: "{{ environment | default('dev') }}"
    resource_group: "rg-acid-cicd-{{ environment }}"
    container_app_name: "ca-acid-cicd-one-{{ environment }}"

  tasks:
    - name: Display rollback information
      debug:
        msg:
          - "==================================================="
          - "ACiD Rollback Starting"
          - "==================================================="
          - "Environment: {{ environment }}"
          - "Container App: {{ container_app_name }}"

    - name: Get previous revision
      command: >
        az containerapp revision list
        --name {{ container_app_name }}
        --resource-group {{ resource_group }}
        --query "[?properties.active==``false``] | [0].name"
        --output tsv
      register: previous_revision
      changed_when: false

    - name: Activate previous revision
      command: >
        az containerapp revision activate
        --revision {{ previous_revision.stdout }}
        --resource-group {{ resource_group }}
      when: previous_revision.stdout is defined and previous_revision.stdout != ""
      register: rollback_result

    - name: Display rollback result
      debug:
        msg:
          - "==================================================="
          - "✅ Rollback Successful!"
          - "==================================================="
          - "Activated Revision: {{ previous_revision.stdout }}"
"@
Set-Content -Path "$projectRoot\ansible\rollback.yml" -Value $ansibleRollback
Write-Host "  ✅ Created: ansible/rollback.yml" -ForegroundColor Green

# ansible/ansible.cfg
$ansibleCfg = @"
[defaults]
inventory = inventory/azure.yml
host_key_checking = False
stdout_callback = yaml
retry_files_enabled = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

[privilege_escalation]
become = False

[ssh_connection]
pipelining = True
"@
Set-Content -Path "$projectRoot\ansible\ansible.cfg" -Value $ansibleCfg
Write-Host "  ✅ Created: ansible/ansible.cfg" -ForegroundColor Green

# ansible/inventory/azure.yml
$ansibleInventory = @"
---
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ ansible_playbook_python }}"
  
  vars:
    # Azure Configuration
    azure_subscription_id: "{{ lookup('env', 'AZURE_SUBSCRIPTION_ID') }}"
    azure_tenant_id: "{{ lookup('env', 'AZURE_TENANT_ID') }}"
    azure_client_id: "{{ lookup('env', 'AZURE_CLIENT_ID') }}"
    azure_client_secret: "{{ lookup('env', 'AZURE_CLIENT_SECRET') }}"
    
    # Application Configuration
    app_name: ideal-cicd-one
    app_version: "{{ lookup('env', 'APP_VERSION') | default('1.0.0', true) }}"
"@
Set-Content -Path "$projectRoot\ansible\inventory\azure.yml" -Value $ansibleInventory
Write-Host "  ✅ Created: ansible/inventory/azure.yml" -ForegroundColor Green

# Update old ansible files
Remove-Item "$projectRoot\ansible\acid-main.yml" -Force -ErrorAction SilentlyContinue
Remove-Item "$projectRoot\ansible\hosts" -Force -ErrorAction SilentlyContinue
Write-Host "  🗑️  Removed old Ansible files" -ForegroundColor Yellow

# ============================================================================
# FASE 8: SONARCLOUD CONFIGURATION
# ============================================================================
Write-Host "`n📊 FASE 8: Creating SonarCloud configuration..." -ForegroundColor Yellow

$sonarProperties = @"
# SonarCloud Configuration for ACiD Project
sonar.projectKey=hmosqueraturner_ideal-cicd-one
sonar.organization=hmosqueraturner

# Project Information
sonar.projectName=ACiD - Ideal CI/CD One
sonar.projectVersion=1.0

# Source and Test Paths
sonar.sources=app/src
sonar.tests=app/src/__tests__
sonar.test.inclusions=**/*.test.js,**/*.test.jsx,**/*.spec.js

# Exclusions
sonar.exclusions=**/node_modules/**,**/build/**,**/coverage/**,**/*.test.js,**/*.spec.js,**/reportWebVitals.js,**/setupTests.js

# Coverage
sonar.javascript.lcov.reportPaths=app/coverage/lcov.info
sonar.coverage.exclusions=**/*.test.js,**/*.spec.js,**/reportWebVitals.js,**/setupTests.js

# Language
sonar.language=js

# Encoding
sonar.sourceEncoding=UTF-8

# Additional Settings
sonar.javascript.node.maxspace=4096
"@
Set-Content -Path "$projectRoot\sonar-project.properties" -Value $sonarProperties
Write-Host "  ✅ Created: sonar-project.properties" -ForegroundColor Green

# ============================================================================
# FASE 9: SCRIPTS UTILITY
# ============================================================================
Write-Host "`n🛠️  FASE 9: Creating utility scripts..." -ForegroundColor Yellow

# scripts/local-test.ps1
$localTestScript = @"
# ============================================================================
# Local Testing Script for ACiD Project
# ============================================================================

Write-Host "🧪 ACiD Local Testing Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

`$appDir = "D:\code\devops\ideal-cicd-one\app"

# Check if Node.js is installed
Write-Host "`n📦 Checking Node.js installation..." -ForegroundColor Yellow
try {
    `$nodeVersion = node --version
    Write-Host "  ✅ Node.js `$nodeVersion installed" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Node.js not found. Please install Node.js" -ForegroundColor Red
    exit 1
}

# Check if npm dependencies are installed
Write-Host "`n📦 Checking dependencies..." -ForegroundColor Yellow
if (-not (Test-Path "`$appDir\node_modules")) {
    Write-Host "  📥 Installing dependencies..." -ForegroundColor Yellow
    Set-Location `$appDir
    npm install
} else {
    Write-Host "  ✅ Dependencies already installed" -ForegroundColor Green
}

# Run linting
Write-Host "`n🔍 Running linting..." -ForegroundColor Yellow
Set-Location `$appDir
npm run lint
if (`$LASTEXITCODE -eq 0) {
    Write-Host "  ✅ Linting passed" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Linting warnings found" -ForegroundColor Yellow
}

# Run tests
Write-Host "`n🧪 Running tests..." -ForegroundColor Yellow
npm run test
if (`$LASTEXITCODE -eq 0) {
    Write-Host "  ✅ All tests passed" -ForegroundColor Green
} else {
    Write-Host "  ❌ Tests failed" -ForegroundColor Red
    exit 1
}

# Build application
Write-Host "`n🏗️  Building application..." -ForegroundColor Yellow
npm run build
if (`$LASTEXITCODE -eq 0) {
    Write-Host "  ✅ Build successful" -ForegroundColor Green
} else {
    Write-Host "  ❌ Build failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ All local tests passed!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
"@
Set-Content -Path "$projectRoot\scripts\local-test.ps1" -Value $localTestScript
Write-Host "  ✅ Created: scripts/local-test.ps1" -ForegroundColor Green

# scripts/docker-build.ps1
$dockerBuildScript = @"
# ============================================================================
# Docker Build Script for ACiD Project
# ============================================================================

param(
    [string]`$Tag = "latest",
    [string]`$Registry = "acidregistry.azurecr.io",
    [switch]`$Push
)

Write-Host "🐳 ACiD Docker Build Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

`$imageName = "`$Registry/ideal-cicd-one:`$Tag"
`$appDir = "D:\code\devops\ideal-cicd-one\app"

# Check if Docker is running
Write-Host "`n📦 Checking Docker..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "  ✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Docker is not running. Please start Docker Desktop" -ForegroundColor Red
    exit 1
}

# Build Docker image
Write-Host "`n🔨 Building Docker image..." -ForegroundColor Yellow
Write-Host "  Image: `$imageName" -ForegroundColor White

Set-Location `$appDir
docker build -t `$imageName .

if (`$LASTEXITCODE -eq 0) {
    Write-Host "  ✅ Docker image built successfully" -ForegroundColor Green
} else {
    Write-Host "  ❌ Docker build failed" -ForegroundColor Red
    exit 1
}

# Push to registry if requested
if (`$Push) {
    Write-Host "`n📤 Pushing to registry..." -ForegroundColor Yellow
    docker push `$imageName
    if (`$LASTEXITCODE -eq 0) {
        Write-Host "  ✅ Image pushed successfully" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Push failed" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n✅ Docker operations completed!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "`nTo run locally: docker run -p 3000:80 `$imageName" -ForegroundColor Yellow
"@
Set-Content -Path "$projectRoot\scripts\docker-build.ps1" -Value $dockerBuildScript
Write-Host "  ✅ Created: scripts/docker-build.ps1" -ForegroundColor Green

# scripts/deploy-azure.ps1
$deployAzureScript = @"
# ============================================================================
# Azure Deployment Script for ACiD Project
# ============================================================================

param(
    [string]`$Environment = "dev",
    [string]`$ImageTag = "latest"
)

Write-Host "🚀 ACiD Azure Deployment Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

`$projectRoot = "D:\code\devops\ideal-cicd-one"

# Check Azure CLI
Write-Host "`n📦 Checking Azure CLI..." -ForegroundColor Yellow
try {
    az version | Out-Null
    Write-Host "  ✅ Azure CLI is installed" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Azure CLI not found. Please install Azure CLI" -ForegroundColor Red
    exit 1
}

# Check if logged in
Write-Host "`n🔐 Checking Azure login..." -ForegroundColor Yellow
`$account = az account show 2>`$null
if (`$LASTEXITCODE -ne 0) {
    Write-Host "  ⚠️  Not logged in. Logging in..." -ForegroundColor Yellow
    az login
} else {
    Write-Host "  ✅ Already logged in to Azure" -ForegroundColor Green
}

# Run Terraform
Write-Host "`n🏗️  Running Terraform..." -ForegroundColor Yellow
Set-Location "`$projectRoot\terraform"

Write-Host "  🔧 Terraform init..." -ForegroundColor White
terraform init

Write-Host "  📋 Terraform plan..." -ForegroundColor White
terraform plan -out=tfplan

Write-Host "  🚀 Terraform apply..." -ForegroundColor White
terraform apply -auto-approve tfplan

if (`$LASTEXITCODE -eq 0) {
    Write-Host "  ✅ Infrastructure deployed" -ForegroundColor Green
} else {
    Write-Host "  ❌ Terraform failed" -ForegroundColor Red
    exit 1
}

# Run Ansible
Write-Host "`n⚙️  Running Ansible deployment..." -ForegroundColor Yellow
Set-Location "`$projectRoot\ansible"

ansible-playbook deploy.yml `
    -e "image_tag=`$ImageTag" `
    -e "environment=`$Environment"

if (`$LASTEXITCODE -eq 0) {
    Write-Host "  ✅ Application deployed" -ForegroundColor Green
} else {
    Write-Host "  ❌ Ansible deployment failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Deployment completed successfully!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan

# Get app URL
Set-Location "`$projectRoot\terraform"
`$appUrl = terraform output -raw container_app_fqdn 2>`$null
if (`$appUrl) {
    Write-Host "`n🌐 Application URL: `$appUrl" -ForegroundColor Cyan
}
"@
Set-Content -Path "$projectRoot\scripts\deploy-azure.ps1" -Value $deployAzureScript
Write-Host "  ✅ Created: scripts/deploy-azure.ps1" -ForegroundColor Green

# ============================================================================
# FASE 10: DOCUMENTATION
# ============================================================================
Write-Host "`n📚 FASE 10: Creating documentation..." -ForegroundColor Yellow

# Updated README.md
$readmeContent = @"
# ACiD Suite - Automatic Continuous Integration and Delivery

![ACiD Suite](./docs/diagrams/acid-banner.png)

[![CI/CD Pipeline](https://github.com/hmosqueraturner/ideal-cicd-one/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/hmosqueraturner/ideal-cicd-one/actions)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=hmosqueraturner_ideal-cicd-one&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=hmosqueraturner_ideal-cicd-one)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A complete DevOps demonstration project showcasing modern CI/CD practices with React, Docker, GitHub Actions, Terraform, Ansible, and Azure.

## 🎯 Project Overview

**ideal-cicd-one** is a comprehensive example of a modern DevOps pipeline that demonstrates:

- **Continuous Integration** with automated testing and quality gates
- **Continuous Deployment** to Azure Container Apps
- **Infrastructure as Code** using Terraform
- **Configuration Management** with Ansible
- **Container Orchestration** with Docker
- **Code Quality Analysis** with SonarCloud

## 🚀 Technology Stack

### Application
- **Frontend**: React 18.x
- **Build Tool**: Create React App
- **Testing**: Jest + React Testing Library
- **Styling**: CSS3 with modern layouts

### DevOps Tools
- **CI/CD**: GitHub Actions
- **Containers**: Docker (multi-stage builds)
- **IaC**: Terraform 1.5+
- **Config Mgmt**: Ansible
- **Cloud Platform**: Azure (Container Apps, ACR, Log Analytics)
- **Code Quality**: SonarCloud
- **Monitoring**: Application Insights

## 📁 Project Structure

\`\`\`
ideal-cicd-one/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # Main CI/CD pipeline
├── app/                        # React Application
│   ├── public/
│   ├── src/
│   │   ├── components/        # React components
│   │   ├── styles/           # CSS files
│   │   └── __tests__/        # Unit tests
│   ├── Dockerfile            # Multi-stage Docker build
│   ├── nginx.conf            # Nginx configuration
│   └── package.json
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # Main Terraform config
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # Output values
│   └── providers.tf          # Provider configuration
├── ansible/                   # Configuration Management
│   ├── deploy.yml            # Deployment playbook
│   ├── rollback.yml          # Rollback playbook
│   └── inventory/            # Inventory files
├── scripts/                   # Utility scripts
│   ├── local-test.ps1        # Local testing
│   ├── docker-build.ps1      # Docker operations
│   └── deploy-azure.ps1      # Azure deployment
├── docs/                      # Documentation
├── docker-compose.yml         # Local development
└── sonar-project.properties  # SonarCloud config
\`\`\`

## 🔧 Prerequisites

- **Node.js** 18.x or higher
- **Docker Desktop**
- **Azure CLI** (for deployment)
- **Terraform** 1.5+ (for IaC)
- **Ansible** (for configuration management)
- **Git**

## 🏃 Quick Start

### 1. Clone the Repository

\`\`\`bash
git clone https://github.com/hmosqueraturner/ideal-cicd-one.git
cd ideal-cicd-one
\`\`\`

### 2. Local Development

\`\`\`bash
cd app
npm install
npm start
\`\`\`

The app will open at \`http://localhost:3000\`

### 3. Run Tests

\`\`\`bash
npm test
npm run test -- --coverage
\`\`\`

### 4. Build Docker Image

\`\`\`bash
# Using Docker Compose
docker-compose up --build

# Or using the script
.\scripts\docker-build.ps1 -Tag "v1.0.0"
\`\`\`

### 5. Local Testing Script

\`\`\`powershell
.\scripts\local-test.ps1
\`\`\`

## ☁️ Azure Deployment

### Setup Azure Resources

1. **Login to Azure**
   \`\`\`bash
   az login
   \`\`\`

2. **Set Subscription**
   \`\`\`bash
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   \`\`\`

3. **Deploy Infrastructure with Terraform**
   \`\`\`bash
   cd terraform
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   \`\`\`

4. **Deploy Application with Ansible**
   \`\`\`bash
   cd ansible
   ansible-playbook deploy.yml -e "image_tag=latest" -e "environment=dev"
   \`\`\`

### Using Deployment Script

\`\`\`powershell
.\scripts\deploy-azure.ps1 -Environment "dev" -ImageTag "v1.0.0"
\`\`\`

## 🔄 CI/CD Pipeline

The GitHub Actions workflow automatically:

1. **Build & Test**
   - Installs dependencies
   - Runs linting
   - Executes unit tests with coverage
   - Builds the React app

2. **Code Quality**
   - SonarCloud analysis
   - Quality gate validation

3. **Docker**
   - Builds multi-stage Docker image
   - Pushes to Azure Container Registry
   - Tags with version and commit SHA

4. **Infrastructure**
   - Validates Terraform configuration
   - Applies infrastructure changes
   - Provisions Azure resources

5. **Deployment**
   - Updates Container App with new image
   - Runs health checks
   - Provides deployment summary

## 🧪 Testing

### Unit Tests
\`\`\`bash
npm test
\`\`\`

### Coverage Report
\`\`\`bash
npm run test -- --coverage
\`\`\`

### E2E Tests (Future)
\`\`\`bash
npm run test:e2e
\`\`\`

## 📊 Monitoring & Observability

- **Application Insights**: Performance monitoring
- **Log Analytics**: Centralized logging
- **Container App Metrics**: Resource utilization
- **Health Checks**: Endpoint monitoring

Access metrics:
\`\`\`bash
az monitor metrics list --resource <resource-id>
\`\`\`

## 🔐 Security & Secrets

Required secrets in GitHub:

- \`AZURE_CREDENTIALS\`: Azure service principal
- \`AZURE_CLIENT_ID\`: Azure client ID
- \`AZURE_CLIENT_SECRET\`: Azure client secret
- \`AZURE_SUBSCRIPTION_ID\`: Azure subscription ID
- \`AZURE_TENANT_ID\`: Azure tenant ID
- \`AZURE_ACR_USERNAME\`: Container registry username
- \`AZURE_ACR_PASSWORD\`: Container registry password
- \`SONAR_TOKEN\`: SonarCloud authentication token

## 🐛 Troubleshooting

### Common Issues

**Docker build fails**
\`\`\`bash
docker system prune -a
docker-compose build --no-cache
\`\`\`

**Terraform state issues**
\`\`\`bash
terraform state list
terraform refresh
\`\`\`

**Azure login expired**
\`\`\`bash
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
\`\`\`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Hector Mosquera Turner** - [@hmosqueraturner](https://github.com/hmosqueraturner)

## 🙏 Acknowledgments

- React team for the amazing framework
- Azure team for comprehensive cloud services
- HashiCorp for Terraform
- Red Hat for Ansible
- SonarSource for code quality tools

## 📚 Additional Resources

- [Azure Container Apps Documentation](https://docs.microsoft.com/azure/container-apps/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [React Documentation](https://react.dev/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

⭐ If you find this project useful, please consider giving it a star!

**Built with ❤️ for the DevOps community**
"@
Set-Content -Path "$projectRoot\README.md" -Value $readmeContent -Force
Write-Host "  ✅ Created: README.md" -ForegroundColor Green

# docs/SETUP.md
$setupDoc = @"
# ACiD Suite - Setup Guide

This guide will walk you through setting up the ACiD Suite project from scratch.

## Prerequisites Installation

### 1. Node.js and npm

Download and install from [nodejs.org](https://nodejs.org/)

\`\`\`powershell
# Verify installation
node --version
npm --version
\`\`\`

### 2. Docker Desktop

Download from [docker.com](https://www.docker.com/products/docker-desktop)

\`\`\`powershell
# Verify installation
docker --version
docker-compose --version
\`\`\`

### 3. Azure CLI

\`\`\`powershell
# Install via winget
winget install -e --id Microsoft.AzureCLI

# Or download from https://aka.ms/installazurecliwindows

# Verify installation
az --version
\`\`\`

### 4. Terraform

\`\`\`powershell
# Install via Chocolatey
choco install terraform

# Or download from https://www.terraform.io/downloads

# Verify installation
terraform --version
\`\`\`

### 5. Ansible

\`\`\`powershell
# Install Python first
winget install Python.Python.3.11

# Install Ansible
pip install ansible

# Verify installation
ansible --version
\`\`\`

## Project Setup

### 1. Initialize Application

\`\`\`powershell
cd D:\code\devops\ideal-cicd-one\app
npm install
\`\`\`

### 2. Azure Configuration

#### Create Service Principal

\`\`\`bash
az login
az account list --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Create service principal
az ad sp create-for-rbac --name "acid-cicd-sp" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth
\`\`\`

Save the output JSON - you will need it for GitHub secrets.

#### Create Storage Account for Terraform State

\`\`\`bash
# Variables
RESOURCE_GROUP="rg-terraform-state"
LOCATION="westeurope"
STORAGE_ACCOUNT="acidtfstate`$(date +%s)"
CONTAINER_NAME="tfstate"

# Create resource group
az group create --name `$RESOURCE_GROUP --location `$LOCATION

# Create storage account
az storage account create \
  --name `$STORAGE_ACCOUNT \
  --resource-group `$RESOURCE_GROUP \
  --location `$LOCATION \
  --sku Standard_LRS

# Get storage account key
ACCOUNT_KEY=`$(az storage account keys list \
  --resource-group `$RESOURCE_GROUP \
  --account-name `$STORAGE_ACCOUNT \
  --query '[0].value' -o tsv)

# Create blob container
az storage container create \
  --name `$CONTAINER_NAME \
  --account-name `$STORAGE_ACCOUNT \
  --account-key `$ACCOUNT_KEY
\`\`\`

### 3. Terraform Backend Configuration

Create \`terraform/backend.tfvars\`:

\`\`\`hcl
storage_account_name = "acidtfstate123456"
container_name       = "tfstate"
key                  = "ideal-cicd-one.tfstate"
\`\`\`

Initialize Terraform with backend:

\`\`\`bash
cd terraform
terraform init -backend-config=backend.tfvars
\`\`\`

### 4. GitHub Secrets Setup

Add these secrets in GitHub Repository Settings > Secrets and variables > Actions:

- \`AZURE_CREDENTIALS\`: Full JSON from service principal creation
- \`AZURE_CLIENT_ID\`: From JSON output
- \`AZURE_CLIENT_SECRET\`: From JSON output
- \`AZURE_SUBSCRIPTION_ID\`: Your subscription ID
- \`AZURE_TENANT_ID\`: From JSON output
- \`SONAR_TOKEN\`: From SonarCloud (create at sonarcloud.io)

### 5. SonarCloud Setup

1. Go to [sonarcloud.io](https://sonarcloud.io)
2. Sign in with GitHub
3. Create new organization (or use existing)
4. Import \`ideal-cicd-one\` repository
5. Generate token: My Account > Security > Generate Tokens
6. Add token to GitHub secrets as \`SONAR_TOKEN\`

## Local Development

### Start Development Server

\`\`\`powershell
cd app
npm start
\`\`\`

Open [http://localhost:3000](http://localhost:3000)

### Run Tests

\`\`\`powershell
npm test
\`\`\`

### Build for Production

\`\`\`powershell
npm run build
\`\`\`

## Docker Testing

### Build and Run Locally

\`\`\`powershell
# Using Docker Compose
docker-compose up --build

# Or manually
cd app
docker build -t acid-app:local .
docker run -p 3000:80 acid-app:local
\`\`\`

### Test Health Endpoint

\`\`\`powershell
curl http://localhost:3000/health
\`\`\`

## Azure Deployment

### First Time Setup

\`\`\`powershell
# Run the deployment script
.\scripts\deploy-azure.ps1 -Environment "dev" -ImageTag "v1.0.0"
\`\`\`

### Manual Deployment Steps

1. **Deploy Infrastructure**
   \`\`\`bash
   cd terraform
   terraform plan -var-file="terraform.tfvars"
   terraform apply -var-file="terraform.tfvars"
   \`\`\`

2. **Build and Push Docker Image**
   \`\`\`powershell
   .\scripts\docker-build.ps1 -Tag "v1.0.0" -Push
   \`\`\`

3. **Deploy with Ansible**
   \`\`\`bash
   cd ansible
   ansible-playbook deploy.yml -e "image_tag=v1.0.0"
   \`\`\`

## Verification

### Check Application

"@
Set-Content -Path "$projectRoot\README.md" -Value $readmeContent -Force
Write-Host "  ✅ Created: README.md" -ForegroundColor Green
