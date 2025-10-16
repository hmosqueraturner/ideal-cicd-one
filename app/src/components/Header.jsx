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
