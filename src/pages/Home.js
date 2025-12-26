import React from 'react';
import '../styles/Home.css';

function Home() {
  return (
    <div className="home">
      <section className="hero">
        <div className="hero-content">
          <h1>Welcome to Digital Municipality</h1>
          <p>Access all municipal services from the comfort of your home</p>
          <button className="cta-button">Get Started</button>
        </div>
      </section>

      <section className="features">
        <div className="features-container">
          <div className="feature">
            <h2>🏛️ Building Permits</h2>
            <p>Apply for construction and renovation permits online</p>
          </div>
          <div className="feature">
            <h2>💰 Pay Bills</h2>
            <p>Settle your municipal taxes and utility bills securely</p>
          </div>
          <div className="feature">
            <h2>📋 Submit Requests</h2>
            <p>File complaints and service requests easily</p>
          </div>
          <div className="feature">
            <h2>📊 Track Status</h2>
            <p>Monitor the progress of your applications in real-time</p>
          </div>
        </div>
      </section>

      <section className="info">
        <div className="info-content">
          <h2>Making Municipal Services Accessible</h2>
          <p>
            Our digital platform brings government services to your fingertips.
            No more long queues or complicated paperwork. Everything you need
            is available 24/7, making civic engagement easier than ever.
          </p>
        </div>
      </section>
    </div>
  );
}

export default Home;
