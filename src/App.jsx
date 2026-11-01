import React, { useState } from 'react';
import { CURRENT_USER, INITIAL_PRODUCTS } from './data/mockData';
import { classifyRisk } from './data/riskRules';
import Header from './components/Header';
import FilterBar from './components/FilterBar';
import ProductGrid from './components/ProductGrid';
import { useNutriContext } from './context/NutriContext';
import './App.css';

const initialForm = { name: '', category: 'Beverage', sugar: '', sodium: '', fat: '', additives: 'Low', servingSize: '' };

export default function App() {
  const { foodRecords, addFoodRecord, updateFoodRecord, deleteFoodRecord } = useNutriContext();
  const [formData, setFormData] = useState(initialForm);
  const [editingId, setEditingId] = useState(null);
  const [error, setError] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [showLowRiskOnly, setShowLowRiskOnly] = useState(false);
  const foodList = [...INITIAL_PRODUCTS, ...foodRecords];
  const categories = [...new Set(foodList.map((food) => food.category))];

  const filteredProducts = foodList.filter((food) => food.title.toLowerCase().includes(searchQuery.toLowerCase())
    && (selectedCategory === 'All' || food.category === selectedCategory)
    && (!showLowRiskOnly || classifyRisk(food).level === 'Low Risk'));
  const riskCounts = ['High Risk', 'Moderate Risk', 'Low Risk'].reduce((counts, level) => {
    counts[level] = foodList.filter((food) => classifyRisk(food).level === level).length;
    return counts;
  }, {});

  const handleChange = ({ target: { name, value } }) => setFormData((previous) => ({ ...previous, [name]: value }));
  const resetForm = () => { setFormData(initialForm); setEditingId(null); setError(''); };

  const handleSubmit = (event) => {
    event.preventDefault();
    const sugar = Number(formData.sugar), sodium = Number(formData.sodium), fat = Number(formData.fat), servingSize = Number(formData.servingSize);
    if (!formData.name.trim() || formData.sugar === '' || formData.sodium === '' || formData.fat === '' || !formData.servingSize || [sugar, sodium, fat, servingSize].some(Number.isNaN)) {
      setError('Please enter the food name and all nutrition values.'); return;
    }
    const record = { id: editingId || Date.now(), title: formData.name.trim(), category: formData.category, sugar, sodium, fat, additives: formData.additives, servingSize, imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80' };
    if (editingId) updateFoodRecord(record); else addFoodRecord(record);
    resetForm();
  };
  const startEdit = (food) => {
    setEditingId(food.id);
    setFormData({ name: food.title, category: food.category, sugar: food.sugar, sodium: food.sodium, fat: food.fat, additives: food.additives || 'Low', servingSize: food.servingSize || 100 });
    setError('');
  };

  return <div className="app-container">
    <Header user={CURRENT_USER} title="Nutritional Risk Classification System" />
    <main className="dashboard-main">
      <section className="hero-panel"><div className="hero-copy"><p className="eyebrow">SDG 3 - Good Health and Well-being</p><h2>Packaged Food Safety Review</h2><p>Classify packaged foods using simple rules for sugar, sodium, fat and artificial additives.</p></div>
        <div className="stats-grid"><div className="stat-card highlight"><span className="stat-number">{riskCounts['High Risk']}</span><span className="stat-label">High Risk</span></div><div className="stat-card"><span className="stat-number">{riskCounts['Moderate Risk']}</span><span className="stat-label">Moderate</span></div><div className="stat-card"><span className="stat-number">{riskCounts['Low Risk']}</span><span className="stat-label">Low Risk</span></div></div>
      </section>
      <div className="content-grid"><div className="left-column">
        <section className="panel"><div className="panel-header"><h3>Packaged Food Catalogue</h3></div><FilterBar searchQuery={searchQuery} setSearchQuery={setSearchQuery} selectedCategory={selectedCategory} setSelectedCategory={setSelectedCategory} onlyInStock={showLowRiskOnly} setOnlyInStock={setShowLowRiskOnly} categories={categories} lowRiskLabel="Low Risk Only" /><ProductGrid products={filteredProducts} onEdit={startEdit} onDelete={deleteFoodRecord} /></section>
        <section className="panel api-panel"><div className="panel-header"><h3>Concepts Demonstrated</h3></div><div className="api-grid"><div className="api-card"><strong>Rule-based classification</strong><p>Simple conditions assign Low, Moderate or High Risk.</p></div><div className="api-card"><strong>CRUD operations</strong><p>Create, read, update and delete custom food records in the interface.</p></div><div className="api-card"><strong>React components and props</strong><p>Food cards, filters and the form are separate reusable components.</p></div></div></section>
      </div><aside className="right-column"><section className="panel form-panel"><div className="panel-header"><h3>{editingId ? 'Update Food Record' : 'Risk Assessment Form'}</h3></div><p className="form-help">Enter values per serving. The risk label is calculated automatically.</p>
        <form onSubmit={handleSubmit} className="risk-form"><div className="form-group"><label htmlFor="name">Food Name</label><input id="name" name="name" value={formData.name} onChange={handleChange} placeholder="e.g. Fruit Drink" /></div><div className="form-group"><label htmlFor="category">Category</label><select id="category" name="category" value={formData.category} onChange={handleChange}><option>Beverage</option><option>Bakery</option><option>Snack</option><option>Dairy</option><option>Ready-to-Eat</option></select></div><div className="form-row"><div className="form-group"><label htmlFor="sugar">Sugar (g)</label><input id="sugar" name="sugar" type="number" min="0" step="0.1" value={formData.sugar} onChange={handleChange} /></div><div className="form-group"><label htmlFor="sodium">Sodium (mg)</label><input id="sodium" name="sodium" type="number" min="0" value={formData.sodium} onChange={handleChange} /></div></div><div className="form-row"><div className="form-group"><label htmlFor="fat">Fat (g)</label><input id="fat" name="fat" type="number" min="0" step="0.1" value={formData.fat} onChange={handleChange} /></div><div className="form-group"><label htmlFor="servingSize">Serving Size (g/ml)</label><input id="servingSize" name="servingSize" type="number" min="1" value={formData.servingSize} onChange={handleChange} /></div></div><div className="form-group"><label htmlFor="additives">Artificial Additives</label><select id="additives" name="additives" value={formData.additives} onChange={handleChange}><option>Low</option><option>Medium</option><option>High</option></select></div>{error && <p className="error-message">{error}</p>}<button type="submit" className="submit-btn">{editingId ? 'Save Changes' : 'Classify Risk'}</button>{editingId && <button type="button" className="cancel-btn" onClick={resetForm}>Cancel</button>}</form>
      </section></aside></div>
    </main>
  </div>;
}
