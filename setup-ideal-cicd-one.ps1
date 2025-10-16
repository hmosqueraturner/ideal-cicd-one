# ============================================================================
# ACiD - Automatic Continuous Integration and Delivery Suite
# Setup Script for ideal-cicd-one Project
# ============================================================================

$ErrorActionPreference = "Stop"

Write-Host " ACiD Suite - Project Setup Starting..." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

$projectRoot = "D:\code\devops\ideal-cicd-one"

# ============================================================================
# FASE 1: LIMPIEZA DE ARCHIVOS ANTIGUOS (Java)
# ============================================================================
Write-Host "`n FASE 1: Cleaning old Java structure..." -ForegroundColor Yellow

$oldPaths = @(
    "$projectRoot\src\main\java",
    "$projectRoot\src\test\java",
    "$projectRoot\target",
    "$projectRoot\pom.xml"
)

foreach ($path in $oldPaths) {
    if (Test-Path $path) {
        Write-Host "   Removing: $path" -ForegroundColor Red
        Remove-Item -Path $path -Recurse -Force
    }
}

# ============================================================================
# FASE 2: ESTRUCTURA DE DIRECTORIOS
# ============================================================================
Write-Host "`n FASE 2: Creating directory structure..." -ForegroundColor Yellow

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
        Write-Host "   Created: $dir" -ForegroundColor Green
    }
}

# ============================================================================
# FASE 3: APP REACT - ARCHIVOS PRINCIPALES
# ============================================================================
Write-Host "`n  FASE 3: Creating React App files..." -ForegroundColor Yellow

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
Write-Host "   Created: app/package.json" -ForegroundColor Green

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
Write-Host "   Created: app/public/index.html" -ForegroundColor Green

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
Write-Host "   Created: app/src/index.js" -ForegroundColor Green

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
Write-Host "   Created: app/src/App.jsx" -ForegroundColor Green

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
Write-Host "   Created: app/src/components/Header.jsx" -ForegroundColor Green

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
Write-Host "   Created: app/src/components/Counter.jsx" -ForegroundColor Green

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
Write-Host "   Created: app/src/components/SystemStatus.jsx" -ForegroundColor Green

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
Write-Host "   Created: app/src/components/PipelineInfo.jsx" -ForegroundColor Green

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
Write-Host "   Created: app/src/reportWebVitals.js" -ForegroundColor Green

Write-Host "`n Creating CSS files..." -ForegroundColor Cyan

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
Write-Host "   Created: app/src/styles/index.css" -ForegroundColor Green

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
Write-Host "   Created: app/src/styles/App.css" -ForegroundColor Green

Write-Host "`n Creating test files..." -ForegroundColor Cyan

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
Write-Host "   Created: app/src/__tests__/App.test.js" -ForegroundColor Green

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
Write-Host "   Created: app/src/__tests__/Counter.test.js" -ForegroundColor Green

# setupTests.js
$setupTests = @"
import '@testing-library/jest-dom';
"@
Set-Content -Path "$projectRoot\app\src\setupTests.js" -Value $setupTests
Write-Host "   Created: app/src/setupTests.js" -ForegroundColor Green

# ============================================================================
# FASE 4: DOCKER FILES
# ============================================================================
Write-Host "`n FASE 4: Creating Docker files..." -ForegroundColor Yellow

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
Write-Host "   Created: app/Dockerfile" -ForegroundColor Green

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
Write-Host "   Created: app/nginx.conf" -ForegroundColor Green

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
Write-Host "   Created: app/.dockerignore" -ForegroundColor Green

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
Write-Host "   Created: docker-compose.yml" -ForegroundColor Green

# ============================================================================
# FASE 5: GITHUB ACTIONS WORKFLOW
# ============================================================================
Write-Host "`n  FASE 5: Creating GitHub Actions workflow..." -ForegroundColor Yellow

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
    name:  Build and Test
    runs-on: ubuntu-latest
    
    steps:
      - name:  Checkout code
        uses: actions/checkout@v4

      - name:  Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: `${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: ./app/package-lock.json

      - name:  Install dependencies
        working-directory: ./app
        run: npm ci

      - name:  Run linting
        working-directory: ./app
        run: npm run lint || true

      - name:  Run tests
        working-directory: ./app
        run: npm run test

      - name:  Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          files: ./app/coverage/lcov.info
          flags: unittests
          name: codecov-umbrella

      - name:  Build application
        working-directory: ./app
        env:
          REACT_APP_ENV: `${{ github.ref == 'refs/heads/main' && 'production' || 'development' }}
          REACT_APP_BUILD_NUMBER: `${{ github.run_number }}
          REACT_APP_BUILD_DATE: `${{ github.event.head_commit.timestamp }}
        run: npm run build

      - name:  Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-artifacts
          path: ./app/build
          retention-days: 5

  # ============================================================================
  # JOB 2: SONARCLOUD ANALYSIS
  # ============================================================================
  sonarcloud:
    name:  SonarCloud Analysis
    runs-on: ubuntu-latest
    needs: build-and-test
    
    steps:
      - name:  Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name:  Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: `${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: ./app/package-lock.json

      - name:  Install dependencies
        working-directory: ./app
        run: npm ci

      - name:  Run tests with coverage
        working-directory: ./app
        run: npm run test

      - name:  SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: `${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: `${{ secrets.SONAR_TOKEN }}

  # ============================================================================
  # JOB 3: BUILD & PUSH DOCKER IMAGE
  # ============================================================================
  docker:
    name:  Build and Push Docker Image
    runs-on: ubuntu-latest
    needs: [build-and-test, sonarcloud]
    if: github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop')
    
    steps:
      - name:  Checkout code
        uses: actions/checkout@v4

      - name:  Login to Azure Container Registry
        uses: docker/login-action@v3
        with:
          registry: `${{ env.REGISTRY }}
          username: `${{ secrets.AZURE_ACR_USERNAME }}
          password: `${{ secrets.AZURE_ACR_PASSWORD }}

      - name:  Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: `${{ env.REGISTRY }}/`${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=sha,prefix={{branch}}-
            type=raw,value=latest,enable={{is_default_branch}}
            type=raw,value=`${{ github.run_number }}

      - name:  Build and push Docker image
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
    name:  Terraform Infrastructure
    runs-on: ubuntu-latest
    needs: docker
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name:  Checkout code
        uses: actions/checkout@v4

      - name:  Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.5.0

      - name:  Azure Login
        uses: azure/login@v1
        with:
          creds: `${{ secrets.AZURE_CREDENTIALS }}

      - name:  Terraform Init
        working-directory: ./terraform
        run: terraform init

      - name:  Terraform Plan
        working-directory: ./terraform
        run: terraform plan -out=tfplan
        env:
          ARM_CLIENT_ID: `${{ secrets.AZURE_CLIENT_ID }}
          ARM_CLIENT_SECRET: `${{ secrets.AZURE_CLIENT_SECRET }}
          ARM_SUBSCRIPTION_ID: `${{ secrets.AZURE_SUBSCRIPTION_ID }}
          ARM_TENANT_ID: `${{ secrets.AZURE_TENANT_ID }}

      - name:  Terraform Apply
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
    name:  Deploy with Ansible
    runs-on: ubuntu-latest
    needs: terraform
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name:  Checkout code
        uses: actions/checkout@v4

      - name:  Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name:  Install Ansible
        run: |
          python -m pip install --upgrade pip
          pip install ansible azure-cli

      - name:  Azure Login
        uses: azure/login@v1
        with:
          creds: `${{ secrets.AZURE_CREDENTIALS }}

      - name:  Run Ansible Playbook
        working-directory: ./ansible
        run: |
          ansible-playbook deploy.yml \
            -e "image_tag=`${{ github.run_number }}" \
            -e "environment=production" \
            -e "registry=`${{ env.REGISTRY }}" \
            -e "image_name=`${{ env.IMAGE_NAME }}"

      - name:  Deployment Summary
        run: |
          echo "## 🎉 Deployment Successful!" >> `$GITHUB_STEP_SUMMARY
          echo "" >> `$GITHUB_STEP_SUMMARY
          echo "- **Environment:** Production" >> `$GITHUB_STEP_SUMMARY
          echo "- **Image:** `${{ env.REGISTRY }}/`${{ env.IMAGE_NAME }}:`${{ github.run_number }}" >> `$GITHUB_STEP_SUMMARY
          echo "- **Build Number:** `${{ github.run_number }}" >> `$GITHUB_STEP_SUMMARY
          echo "- **Commit:** `${{ github.sha }}" >> `$GITHUB_STEP_SUMMARY
"@
Set-Content -Path "$projectRoot\.github\workflows\ci-cd.yml" -Value $githubWorkflow
Write-Host "   Created: .github/workflows/ci-cd.yml" -ForegroundColor Green

# ============================================================================
# FASE 6: TERRAFORM FILES
# ============================================================================
Write-Host "`n  FASE 6: Creating Terraform configuration..." -ForegroundColor Yellow

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
Write-Host "  Created: terraform/providers.tf" -ForegroundColor Green

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
Write-Host "  Created: terraform/variables.tf" -ForegroundColor Green

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
Write-Host "  Created: terraform/terraform.tfvars.example" -ForegroundColor Green

Write-Host "`n SETUP COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "`n Next Steps:" -ForegroundColor Yellow
Write-Host "  1. cd D:\code\devops\ideal-cicd-one\app" -ForegroundColor White
Write-Host "  2. npm install" -ForegroundColor White
Write-Host "  3. npm start (to run development server)" -ForegroundColor White
Write-Host "  4. npm test (to run tests)" -ForegroundColor White
Write-Host "  5. docker-compose up --build (to test Docker)" -ForegroundColor White
Write-Host "`n Your ACiD Suite project is ready!" -ForegroundColor Green