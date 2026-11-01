import React from 'react';
import ProductCard from './ProductCard';

export default function ProductGrid({ products, onEdit, onDelete }) {
  if (products.length === 0) {
    return (
      <div className="empty-state">
        <p>No packaged foods match the current filters.</p>
      </div>
    );
  }

  return (
    <div className="product-grid">
      {products.map((product) => (
        <ProductCard key={product.id} product={product} onEdit={onEdit} onDelete={onDelete} isCustomRecord={typeof product.id === 'number'} />
      ))}
    </div>
  );
}
