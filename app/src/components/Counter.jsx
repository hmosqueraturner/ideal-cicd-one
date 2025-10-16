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
