

---

# **Netflix Movies & TV Shows Data Analysis using SQL**

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?logo=postgresql\&logoColor=white)
![Kaggle Dataset](https://img.shields.io/badge/Dataset-Kaggle-blue?logo=kaggle)
![Project Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Made With ❤️](https://img.shields.io/badge/Made%20with-Love-red)
![GitHub Stars](https://img.shields.io/github/stars/mani544/Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL?style=social)
![GitHub Forks](https://img.shields.io/github/forks/mani544/Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL?style=social)

---

![Netflix Logo](https://github.com/mani544/Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL/blob/main/Netflix_logo.png)

## 📌 **Overview**

This project presents an in-depth analysis of **Netflix’s Movies and TV Shows** using SQL.
The goal is to explore the dataset, clean missing values, and derive meaningful business insights.

The queries cover:

* Content distribution
* Ratings
* Country-wise contributions
* Release trends
* Director/Actor analysis
* Keyword-based classification
* Duration-based filtering

This project is ideal for SQL learning, portfolio building, and real-world data analysis practice.

---

## 📁 **Dataset**

Dataset from Kaggle:

🔗 **Netflix Movies & TV Shows Dataset**
[https://www.kaggle.com/datasets/shivamb/netflix-shows](https://www.kaggle.com/datasets/shivamb/netflix-shows)

### **Table Schema**

```sql
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

---

# 🛠️ **Data Cleaning**

Missing values were replaced with `"Unknown"` (or `-1` for numbers):

```sql
UPDATE netflix
SET 
    type        = COALESCE(type, 'Unknown'),
    title       = COALESCE(title, 'Unknown'),
    director    = COALESCE(director, 'Unknown'),
    casts       = COALESCE(casts, 'Unknown'),
    country     = COALESCE(country, 'Unknown'),
    date_added  = COALESCE(date_added, 'Unknown'),
    rating      = COALESCE(rating, 'Unknown'),
    duration    = COALESCE(duration, 'Unknown'),
    listed_in   = COALESCE(listed_in, 'Unknown'),
    description = COALESCE(description, 'Unknown'),
    release_year = COALESCE(release_year, -1);
```

### Null Check

✔ **All NULLs removed**

---

# 🔍 **Business Questions & SQL Solutions**

(Your query list remains exactly the same as you provided — no edits made.)

---

# 📝 **Findings & Conclusion**

* Movies dominate the dataset.
* TV-MA & TV-14 are the most common ratings.
* US, India & UK produce the highest Netflix content.
* Strong year-wise trends for Indian releases.
* Descriptions help classify content tone.
* SQL provides powerful insights from simple text fields.

---

# ⭐ **Thank You!**

If you found this analysis helpful:

⭐ **Star the Repository**
🔗 **Connect on LinkedIn**

---


