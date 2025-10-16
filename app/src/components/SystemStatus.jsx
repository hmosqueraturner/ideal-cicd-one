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
        <div className={status-item  + getStatusClass(status.api)}>
          <span className="status-icon">{getStatusIcon(status.api)}</span>
          <span className="status-label">API Service</span>
          <span className="status-value">{status.api}</span>
        </div>
        <div className={status-item  + getStatusClass(status.database)}>
          <span className="status-icon">{getStatusIcon(status.database)}</span>
          <span className="status-label">Database</span>
          <span className="status-value">{status.database}</span>
        </div>
        <div className={status-item  + getStatusClass(status.cache)}>
          <span className="status-icon">{getStatusIcon(status.cache)}</span>
          <span className="status-label">Cache</span>
          <span className="status-value">{status.cache}</span>
        </div>
      </div>
    </div>
  );
}

export default SystemStatus;
