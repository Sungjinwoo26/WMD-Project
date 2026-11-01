import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import { NutriProvider } from './context/NutriContext';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <NutriProvider>
      <App />
    </NutriProvider>
  </React.StrictMode>
);
