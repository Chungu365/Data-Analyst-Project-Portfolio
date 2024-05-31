-- Data CLeaning
-- We start by exploring our data

SELECT *
FROM layoffs1
ORDER BY company;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or Blank Values
-- 4. Remove Any Irrelevant/Blank Columns 

-- Create Staging Table
-- We then proceed by creating a duplicated (staing table) of our original table that we'll make some modifications to.
-- This is so that we can always refer to our raw(original) data incase of any accidents or mistakes.

CREATE TABLE layoffs_staging
LIKE layoffs1;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs1;

-- Removing Duplicates.
-- Since we do not have any unique identifier, we will use row numbers partitioned by all our fields to identify any duplicated entries.
-- A row number of 2 or greater implies that we have duplicates.

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- We now proceed by creating a CTE and investigating for duplicates.

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Next, we will delete the duplicates
-- Note, we can't update/delete from a CTE in MySQL, so we'll use a different method.
-- We will create another table, filter on the row numbers greater than 1, then delete that column.


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` float DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- When deleting, I recommend writing a SELECT statement to see what you're deleting, then replace SELECT with DELETE.

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizing data
-- This is simply finding issues/inconsistencies with your data anf fixing it.
-- We start by removing any leading/trailing spaces

SELECT DISTINCT company,(TRIM(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'united states%';

-- We change the data type and format of the date column

-- SELECT `date`, STR_tO_DATE( `date`, '%m/%d/%Y')
-- FROM layoffs_staging2;

SELECT `date`, CAST(`date` AS DATE)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = CAST(`date` AS DATE);

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- NULL VALUES AND BLANKS

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;













