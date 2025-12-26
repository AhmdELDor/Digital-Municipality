import React from 'react';
import ServiceCard from '../components/ServiceCard';
import '../styles/Services.css';

function Services() {
  const services = [
    {
      title: 'Building Permits',
      description: 'Apply for construction, renovation, and building permits',
      icon: '🏗️'
    },
    {
      title: 'Business Licenses',
      description: 'Register your business and obtain necessary licenses',
      icon: '💼'
    },
    {
      title: 'Property Taxes',
      description: 'View and pay your property tax bills online',
      icon: '🏠'
    },
    {
      title: 'Water & Utilities',
      description: 'Manage water, electricity, and other utility services',
      icon: '💧'
    },
    {
      title: 'Complaints & Requests',
      description: 'Submit and track municipal service requests',
      icon: '📝'
    },
    {
      title: 'Public Records',
      description: 'Access public documents and records',
      icon: '📄'
    }
  ];

  return (
    <div className="services">
      <div className="services-header">
        <h1>Municipal Services</h1>
        <p>Explore all available services and access them instantly</p>
      </div>
      <div className="services-grid">
        {services.map((service, index) => (
          <ServiceCard
            key={index}
            title={service.title}
            description={service.description}
            icon={service.icon}
          />
        ))}
      </div>
    </div>
  );
}

export default Services;
