-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- This shows us a time period of the layoffs.
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- This shows us the highest total number & percenntage of layoffs.
SELECT MAX(total_laid_off),
MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Table of all the companies that went under ordered by the total number of layoffs in descending order.
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Table of all the companies that went under ordered by the funds raised(i millions) in descending order.
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Sum of total layoffs per company.
SELECT company,industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, industry
ORDER BY 3 DESC;

-- This shows us which industries experienced the most layoffs from greatest to least.
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- This shows us which countries experienced the greatest number of layoffs.
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- A show of total layoffs per year.
-- Note that 2023 only accounts for the first quarter of the year.
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- Rolling total of monthly layoffs.
-- This is a summation/cummulative total of the monthly layoffs that shifts forward by one month.
-- We begin by creating a CTE.

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- This provides the total number of layoffs for the top five companies with the highest annual layoffs.
-- We begin by creating a CTE
SELECT company,YEAR(`date`) AS years, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 1 ASC;

WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company,YEAR(`date`) AS year, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;
