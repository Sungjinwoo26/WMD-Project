import React from 'react';
import { classifyRisk } from '../data/riskRules';

export default function ProductCard({ product, onEdit, onDelete, isCustomRecord }) {
  const risk = classifyRisk(product);
  return (
    <div className="product-card">
      <div className="image-wrapper">
        <img src={product.imageUrl} alt={product.title} />
        <span className="category-tag">{product.category}</span>
        <span className="risk-tag">{risk.level}</span>
      </div>
      <div className="card-details">
        <h3>{product.title}</h3>
        <div className="card-features">
          <span className="badge">Sugar: {product.sugar ?? 0}g</span>
          <span className="badge">Sodium: {product.sodium ?? 0}mg</span>
          <span className="badge">Fat: {product.fat ?? 0}g</span>
          <span className="badge">Additives: {product.additives || 'Low'}</span>
        </div>
        <p className="risk-reason">{risk.reason}</p>
        {isCustomRecord && <div className="card-actions">
          <button type="button" className="edit-btn" onClick={() => onEdit(product)}>Edit</button>
          <button type="button" className="delete-btn" onClick={() => onDelete(product.id)}>Delete</button>
        </div>}
      </div>
    </div>
  );
}
