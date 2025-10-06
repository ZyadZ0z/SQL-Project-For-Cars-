# 🚗 BMW vs Mercedes — Data Analysis Project (SQL)

## 📖 Overview
This project focuses on a **comparative data analysis** between two of the world’s leading automotive brands — **BMW** and **Mercedes-Benz**.  
The goal was to explore and compare both brands based on key vehicle characteristics such as model, year, price, transmission, mileage, fuel type, tax, mpg, and engine size.

The entire analysis was performed using **SQL**, covering everything from data cleaning to advanced analytical queries and performance optimization.

---

## 🧠 Objectives
- Analyze vehicle data for both BMW and Mercedes to uncover patterns and trends.
- Compare pricing, fuel efficiency, and engine performance across models and years.
- Apply advanced SQL techniques for analytical insights.
- Build a foundation for a Power BI dashboard for visualization.

---

## 🧰 Tech Stack
| Tool / Language | Purpose |
|------------------|----------|
| **SQL (PostgreSQL/MySQL)** | Data cleaning, querying, and analysis |
| **Power BI** | Visualization and interactive dashboards |
| **Excel / CSV** | Initial data preparation |
| **GitHub** | Version control and portfolio hosting |

---

## 📊 Dataset Description
Both datasets contain the same structure and columns:

| Column Name | Description | Example |
|--------------|--------------|----------|
| `model` | Car model name | 3 Series, C-Class |
| `year` | Year of manufacture | 2018 |
| `price` | Vehicle price | 32,000 |
| `transmission` | Type of gearbox | Automatic / Manual |
| `mileage` | Distance driven | 45,000 |
| `fuelType` | Type of fuel used | Petrol / Diesel / Hybrid |
| `tax` | Annual tax | 150 |
| `mpg` | Fuel efficiency (miles per gallon) | 52.3 |
| `engineSize` | Engine displacement (liters) | 2.0 |

---

## 🧩 Project Workflow
### 1️⃣ Data Cleaning & Preparation
- Standardized data types and units (mileage, mpg, engine size).
- Handled missing and outlier values.
- Created structured tables for both brands:
  - `bmw_cars`
  - `mercedes_cars`

### 2️⃣ Exploratory Data Analysis (EDA)
- Summary statistics (count, mean, median, min, max).
- Distribution analysis by year, fuel type, and transmission.
- Identified top-selling models and pricing trends.

### 3️⃣ Comparative Analysis
- Compared **average and median prices** by model and year.
- Evaluated **mileage impact** on pricing between brands.
- Assessed **fuel type distributions** and their evolution over time.

### 4️⃣ Advanced SQL Analytics
- Applied **window functions** for ranking and rolling averages.
- Used **percentile segmentation (NTILE)** to classify car price levels.
- Performed **correlation analysis** between engine size, mileage, and price.
- Implemented **statistical comparisons** using aggregate functions.

### 5️⃣ Performance Optimization
- Added indexes to key columns for faster queries.
- Used CTEs for modular, optimized query structures.

---

## 💡 Key Insights
- 🏷️ **Price Trends:** Mercedes models maintain higher average prices in newer years, while BMW offers wider affordability across model segments.  
- ⛽ **Fuel Evolution:** Diesel dominates earlier years, with petrol and hybrid gaining share post-2018.  
- ⚙️ **Engine Efficiency:** Slight positive correlation between engine size and price in both brands, more pronounced in Mercedes.  
- 📉 **Mileage Effect:** BMW shows a stronger negative correlation between mileage and price — indicating faster depreciation.

---

## 🧮 Example SQL Queries

### Average and Median Price per Year
```sql
SELECT year,
       AVG(price) AS avg_price,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_price
FROM bmw_cars
GROUP BY year
ORDER BY year;
