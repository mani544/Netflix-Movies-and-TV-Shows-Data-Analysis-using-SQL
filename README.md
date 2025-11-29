

---

#  **Netflix Movies & TV Shows Data Analysis using SQL**

![Netflix Logo](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

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

The dataset is sourced from Kaggle:

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

Since most columns are in **text format**, missing values were replaced with `"Unknown"` (or `-1` for numeric columns).

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

### ✅ **Null Check After Cleaning**

```sql
SELECT
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS type_nulls,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    ...
FROM netflix;
```

✔ Result: **0 NULLs remain**
The dataset is clean & ready for analysis.

---

# 🔍 **Business Questions & SQL Solutions**

## **1️⃣ Count the Number of Movies vs TV Shows**

```sql
SELECT type, COUNT(*) AS total
FROM netflix
GROUP BY type;
```

---

## **2️⃣ Most Common Rating for Movies and TV Shows**

```sql
SELECT type, rating, rating_count
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM netflix
    GROUP BY type, rating
) t
WHERE rn = 1;
```

---

## **3️⃣ Movies Released in 2020**

```sql
SELECT title, release_year 
FROM netflix
WHERE release_year = 2020;
```

📌 Total Movies in 2020: **953**

---

## **4️⃣ Top 5 Countries with the Most Content**

```sql
SELECT country_clean AS country,
       COUNT(*) AS total_content
FROM (
  SELECT TRIM(c) AS country_clean
  FROM netflix
  CROSS JOIN LATERAL
    unnest(string_to_array(COALESCE(country, 'Unknown'), ',')) AS c
) t
GROUP BY country_clean
ORDER BY total_content DESC
LIMIT 5;
```

---

## **5️⃣ Identify the Longest Movie**

```sql
SELECT show_id, title, duration
FROM netflix
WHERE type = 'Movie'
  AND duration ILIKE '%min%'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;
```

---

## **6️⃣ Content Added in the Last 5 Years**

```sql
SELECT *
FROM netflix
WHERE TO_DATE(TRIM(date_added), 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

---

## **7️⃣ All Content by Director “Rajiv Chilaka”**

```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

---

## **8️⃣ TV Shows with More Than 5 Seasons**

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND duration ILIKE '%Season%'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

---

## **9️⃣ Count of Content per Genre**

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

---

## 🔟 Top 5 Years with Highest Content Release in India

```sql
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```

---

## **1️⃣1️⃣ List All Documentary Movies**

```sql
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

---

## **1️⃣2️⃣ Content Without a Director**

```sql
SELECT *
FROM netflix
WHERE director = 'Unknown';
```

---

## **1️⃣3️⃣ Salman Khan Movies in Last 10 Years**

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

---

## **1️⃣4️⃣ Top 10 Actors in Indian Content**

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

---

## **1️⃣5️⃣ Categorize Content as “Good” or “Bad”**

```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) t
GROUP BY category;
```

---

# 📝 **Findings & Conclusion**

* **Movies dominate** the dataset with diverse genres and ratings.
* **TV-MA** and **TV-14** appear as the most common ratings.
* **The US, India, and UK** produce the most Netflix content.
* **India’s content output varies year-to-year**, with identifiable peak years.
* Keyword analysis shows how descriptions can determine content tone.
* SQL queries reveal strong insights into content type, geography, actor involvement, and more.

---

#  **Thank You!**

If you found this analysis helpful, feel free to ⭐ the repo and connect!

---


