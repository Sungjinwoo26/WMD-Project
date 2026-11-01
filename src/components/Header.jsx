import React from 'react';

export default function Header({ user, title }) {
  return (
    <header className="navbar">
      <div className="brand">
        <h1>{title || 'NutriGuard'}</h1>
      </div>

      <div className="user-cart-section">
        <div className="user-profile">
          <img src={user.avatar} alt={user.name} className="avatar" />
          <div className="user-details">
            <p className="user-name">{user.name}</p>
            <span className="user-role">{user.role}</span>
          </div>
        </div>
      </div>
    </header>
  );
}
