-- Netflix Project

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

SELECT * FROM netflix;


SELECT COUNT(*) as total_content
FROM netflix;


-- Fill Null values with unknown beacuse the we can't remove or replace with Mean, or some alternative methods because the datatype of columns are text format and also not applicable fot this dataset...

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

-- Now rechecking the dataset 

SELECT * FROM netflix;

-- Count NULLs for all columns 

SELECT
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS type_nulls,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS director_nulls,
    SUM(CASE WHEN casts IS NULL THEN 1 ELSE 0 END) AS casts_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS date_added_nulls,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS release_year_nulls,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS listed_in_nulls,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS description_nulls
FROM netflix;

-- Clearly there is no column and row with null values satisfied



-- Business Problems and Solutions

-- 1. Count the Number of Movies vs TV Shows

SELECT type, COUNT(type) AS Total FROM netflix
GROUP BY type;

-- Objective: Determine the distribution of content types on Netflix.


-- 2. Find the Most Common Rating for Movies and TV Shows

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

-- Objective: Identify the most frequently occurring rating for each type of content.


-- 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT title, release_year FROM netflix
WHERE release_year = 2020;

SELECT COUNT(*) FROM netflix
WHERE release_year = 2020;

-- Total 953 movies are released in 2020 year

-- Objective: Retrieve all movies released in a specific year.

-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT country_clean AS country,
       COUNT(*)        AS total_content
FROM (
  SELECT TRIM(c) AS country_clean
  FROM netflix
  CROSS JOIN LATERAL
    unnest(string_to_array(COALESCE(country, 'Unknown'), ',')) AS c
) t
GROUP BY country_clean
ORDER BY total_content DESC
LIMIT 5;

-- Objective: Identify the top 5 countries with the highest number of content items.

-- 5. Identify the Longest Movie

SELECT show_id, title, duration
FROM netflix
WHERE type = 'Movie'
  AND duration ILIKE '%min%'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;

-- Objective: Find the movie with the longest duration.


-- 6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE type = 'Movie'
  AND TO_DATE(TRIM(date_added), 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- Objective: Retrieve content added to Netflix in the last 5 years.


--  7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- Objective: List all content directed by 'Rajiv Chilaka'.


-- 8. List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND duration ILIKE '%Season%'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

-- Objective: Identify TV shows with more than 5 seasons.


-- 9. Count the Number of Content Items in Each Genre

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

-- Objective: Count the number of content items in each genre.


-- 10. 10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release!

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

-- Objective: Calculate and rank years by the average number of content releases by India.


-- 11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- Objective: Retrieve all movies classified as documentaries.

-- 12. Find All Content Without a Director

SELECT *
FROM netflix
WHERE director = 'Unknown';

-- Objective: List content that does not have a director.


-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years.

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
  
--Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

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
) AS categorized_content
GROUP BY category;

-- Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.


