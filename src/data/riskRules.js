export const classifyRisk = (food) => {
  const sugar = Number(food.sugar || 0);
  const sodium = Number(food.sodium || 0);
  const fat = Number(food.fat || 0);
  const additives = food.additives || 'Low';
  if (sugar > 12 || sodium > 450 || fat > 20 || additives === 'High') return { level: 'High Risk', reason: 'One or more nutrient values are high.' };
  if (sugar > 6 || sodium > 300 || fat > 12 || additives === 'Medium') return { level: 'Moderate Risk', reason: 'Some nutrient values need monitoring.' };
  return { level: 'Low Risk', reason: 'Nutrient values are within the basic limits.' };
};
