import React from 'react';
import '../styles/Dashboard.css';

function Dashboard() {
  const requests = [
    { id: 1, type: 'Building Permit', status: 'Pending', date: '2024-01-15' },
    { id: 2, type: 'Water Bill', status: 'Paid', date: '2024-01-10' },
    { id: 3, type: 'Service Request', status: 'In Progress', date: '2024-01-12' }
  ];

  return (
    <div className="dashboard">
      <div className="dashboard-header">
        <h1>Welcome to Your Dashboard</h1>
        <p>Manage your municipal services and track requests</p>
      </div>

      <div className="dashboard-content">
        <section className="dashboard-section">
          <h2>Quick Actions</h2>
          <div className="quick-actions">
            <button className="action-btn">New Request</button>
            <button className="action-btn">Pay Bills</button>
            <button className="action-btn">View Documents</button>
            <button className="action-btn">Contact Support</button>
          </div>
        </section>

        <section className="dashboard-section">
          <h2>Recent Activity</h2>
          <div className="activity-list">
            {requests.map((request) => (
              <div key={request.id} className="activity-item">
                <div className="activity-info">
                  <h3>{request.type}</h3>
                  <p>Submitted: {request.date}</p>
                </div>
                <div className={`status ${request.status.toLowerCase().replace(' ', '-')}`}>
                  {request.status}
                </div>
              </div>
            ))}
          </div>
        </section>

        <section className="dashboard-section">
          <h2>Account Overview</h2>
          <div className="account-info">
            <div className="info-item">
              <span className="info-label">Total Requests:</span>
              <span className="info-value">3</span>
            </div>
            <div className="info-item">
              <span className="info-label">Pending Bills:</span>
              <span className="info-value">$0.00</span>
            </div>
            <div className="info-item">
              <span className="info-label">Active Services:</span>
              <span className="info-value">5</span>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}

export default Dashboard;
