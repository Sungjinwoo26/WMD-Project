# NutriGuard

NutriGuard is a nutritional risk classification platform for packaged foods. It interprets sugar, sodium, fat and artificial additives through a clear product health score and risk label.

## Features

- Product search and quick product selection
- Nutrition profile with values per serving
- Health score out of 100 with Low Risk, Moderate Risk and High Risk labels
- Explainable result summary linked to the classification rules
- Responsive user interface for desktop and mobile use

## Technology Stack

- Frontend: React, Vite, JavaScript and CSS
- Backend service: Spring Boot, Spring Web and Spring Data JPA
- Persistence: H2 database
- Authentication: Flask, password hashing and JSON Web Tokens

## Run Locally

```bash
npm install
npm run dev
```

For the static production interface:

```bash
npm run build
npm run preview
```

## Project Structure

```text
src/        React user interface and classification logic
backend/    Spring Boot product service
python_api/ Authentication service
dist/       Static frontend build
```
