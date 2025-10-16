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
    document.title = ACiD Suite v+ buildInfo.version;
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
