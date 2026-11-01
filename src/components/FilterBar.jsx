import React from 'react';

export default function FilterBar({
  searchQuery,
  setSearchQuery,
  selectedCategory,
  setSelectedCategory,
  onlyInStock,
  setOnlyInStock,
  categories = [],
  lowRiskLabel = 'Low Risk Only'
}) {
  const categoryList = Array.isArray(categories) ? categories : [];

  return (
    <div className="filter-bar">
      <input
        type="text"
        placeholder="Search food products..."
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        className="search-input"
      />

      <select
        value={selectedCategory}
        onChange={(e) => setSelectedCategory(e.target.value)}
        className="category-select"
      >
        <option value="All">All Categories</option>
        {categoryList.map((categoryName) => (
          <option key={categoryName} value={categoryName}>
            {categoryName}
          </option>
        ))}
      </select>

      <label className="checkbox-label">
        <input
          type="checkbox"
          checked={onlyInStock}
          onChange={(e) => setOnlyInStock(e.target.checked)}
        />
        {lowRiskLabel}
      </label>
    </div>
  );
}
