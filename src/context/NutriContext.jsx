import React, { createContext, useContext, useState } from 'react';

const NutriContext = createContext();

export const NutriProvider = ({ children }) => {
  const [foodRecords, setFoodRecords] = useState([]);
  const [activeFood, setActiveFood] = useState(null);

  const addFoodRecord = (newRecord) => {
    setFoodRecords((prevRecords) => [...prevRecords, newRecord]);
    setActiveFood(newRecord);
  };

  const updateFoodRecord = (updatedRecord) => {
    setFoodRecords((previous) => previous.map((record) => record.id === updatedRecord.id ? updatedRecord : record));
    setActiveFood(updatedRecord);
  };

  const deleteFoodRecord = (id) => {
    setFoodRecords((previous) => previous.filter((record) => record.id !== id));
    setActiveFood(null);
  };

  return (
    <NutriContext.Provider value={{ foodRecords, activeFood, addFoodRecord, updateFoodRecord, deleteFoodRecord }}>
      {children}
    </NutriContext.Provider>
  );
};

export const useNutriContext = () => useContext(NutriContext);
