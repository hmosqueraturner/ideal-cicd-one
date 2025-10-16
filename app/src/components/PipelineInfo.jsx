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
