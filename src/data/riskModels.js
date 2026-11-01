class FoodProfile {
  constructor({ id, name, category, sugar, sodium, fat, price, rating }) {
    this.id = id;
    this.name = name;
    this.category = category;
    this.sugar = Number(sugar || 0);
    this.sodium = Number(sodium || 0);
    this.fat = Number(fat || 0);
    this.price = Number(price || 0);
    this.rating = Number(rating || 0);
  }

  calculateRisk() {
    if (this.sugar > 12 || this.sodium > 450 || this.fat > 20) return 'High Risk';
    if (this.sugar > 6 || this.sodium > 300) return 'Moderate Risk';
    return 'Low Risk';
  }

  getDetails() {
    return `[${this.id}] ${this.name} | Category: ${this.category} | Risk: ${this.calculateRisk()}`;
  }
}

class BeverageProfile extends FoodProfile {
  calculateRisk() {
    if (this.sugar > 10 || this.sodium > 200 || this.fat > 5) return 'High Risk';
    if (this.sugar > 6 || this.sodium > 120) return 'Moderate Risk';
    return 'Low Risk';
  }
}

class SnackProfile extends FoodProfile {
  calculateRisk() {
    if (this.sodium > 700 || this.fat > 18 || this.sugar > 10) return 'High Risk';
    if (this.sodium > 300 || this.fat > 12) return 'Moderate Risk';
    return 'Low Risk';
  }
}

class BakeryProfile extends FoodProfile {
  calculateRisk() {
    if (this.sugar > 14 || this.sodium > 350 || this.fat > 22) return 'High Risk';
    if (this.sugar > 8 || this.sodium > 250) return 'Moderate Risk';
    return 'Low Risk';
  }
}

export const createFoodProfile = (food) => {
  switch (food.category) {
    case 'Beverage':
      return new BeverageProfile(food);
    case 'Snack':
      return new SnackProfile(food);
    case 'Bakery':
      return new BakeryProfile(food);
    default:
      return new FoodProfile(food);
  }
};

export const buildFoodRegistry = (foods = []) => {
  const registryList = foods.map((food) => createFoodProfile(food));
  const registryMap = Object.fromEntries(registryList.map((item) => [item.id, item]));
  const uniqueCategories = [...new Set(registryList.map((item) => item.category))];
  const uniqueSkills = new Set(registryList.flatMap((item) => [item.category]));

  return {
    registryList,
    registryMap,
    uniqueCategories,
    uniqueSkills,
    totalRiskRevenue: registryList.reduce((sum, item) => sum + Number(item.price || 0), 0)
  };
};
