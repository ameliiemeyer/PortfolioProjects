-- TABLES

SELECT *
FROM PortfolioProject.dbo.SuicideHomicideGDP

SELECT *
FROM PortfolioProject.dbo.CountryRegion

SELECT *
FROM PortfolioProject.dbo.SuicideHomicideGDP AS SHG
JOIN PortfolioProject.dbo.CountryRegion AS CoRe
	ON SHG.country = CoRe.Country
	AND SHG.iso3c = CoRe.iso3c

-- AVERAGE PER COUNTRY
SELECT country, AVG(CAST (homicides AS DECIMAL)) AS avg_homicides, AVG (CAST(suicides AS DECIMAL)) AS avg_suicides
FROM PortfolioProject.dbo.SuicideHomicideGDP
WHERE homicides IS NOT NULL AND suicides IS NOT NULL
GROUP BY country
ORDER BY avg_homicides DESC 
--ORDER BY avg_suicides DESC 

-- AVERAGE PER REGION 
SELECT CoRe.region, AVG(CAST (homicides AS DECIMAL)) AS avg_homicides, AVG (CAST(suicides AS DECIMAL)) AS avg_suicides
FROM PortfolioProject.dbo.SuicideHomicideGDP AS SHG
JOIN PortfolioProject.dbo.CountryRegion AS CoRe
	ON SHG.country = CoRe.Country
	AND SHG.iso3c = CoRe.iso3c
GROUP BY CoRe.region
ORDER BY avg_homicides DESC 
--ORDER BY avg_suicides DESC 

-- AVERAGE PER CONTINENT
SELECT CoRe.continent, AVG(CAST (homicides AS DECIMAL)) AS avg_homicides, AVG (CAST(suicides AS DECIMAL)) AS avg_suicides
FROM PortfolioProject.dbo.SuicideHomicideGDP AS SHG
JOIN PortfolioProject.dbo.CountryRegion AS CoRe
	ON SHG.country = CoRe.Country
	AND SHG.iso3c = CoRe.iso3c
GROUP BY CoRe.continent
ORDER BY avg_homicides DESC 
--ORDER BY avg_suicides DESC 

--AVERAGE GLOBAL PER YEAR
SELECT year, AVG(CAST (homicides AS DECIMAL)) AS avg_homicides, AVG (CAST(suicides AS DECIMAL)) AS avg_suicides
FROM PortfolioProject.dbo.SuicideHomicideGDP
WHERE homicides IS NOT NULL AND suicides IS NOT NULL
GROUP BY year
ORDER BY 1
--ORDER BY avg_homicides DESC 
--ORDER BY avg_suicides DESC 

--INCOMES 
SELECT DISTINCT country, income
FROM PortfolioProject.dbo.SuicideHomicideGDP
ORDER BY 2

--AVERAGE PER COUNTRY VS INCOMES
SELECT country, AVG(CAST (homicides AS DECIMAL)) AS avg_homicides, AVG (CAST(suicides AS DECIMAL)) AS avg_suicides, income
FROM PortfolioProject.dbo.SuicideHomicideGDP
WHERE homicides IS NOT NULL AND suicides IS NOT NULL
GROUP BY country, income
ORDER BY avg_homicides DESC
--ORDER BY avg_suicides DESC 

-- AVERAGE PER CONTINENT VS INCOMES
SELECT CoRe.continent, AVG(CAST (homicides AS DECIMAL)) AS avg_homicides, AVG (CAST(suicides AS DECIMAL)) AS avg_suicides, SHG.income
FROM PortfolioProject.dbo.SuicideHomicideGDP AS SHG
JOIN PortfolioProject.dbo.CountryRegion AS CoRe
	ON SHG.country = CoRe.Country
	AND SHG.iso3c = CoRe.iso3c
--WHERE CoRe.continent = 'Europe'
--WHERE CoRe.continent = 'Asia'
--WHERE SHG.income = 'high income'
GROUP BY CoRe.continent, SHG.income
ORDER BY avg_homicides DESC 
--ORDER BY avg_suicides DESC 

--AVERAGE PER REGION VS INCOMES
SELECT CoRe.region, AVG(CAST (homicides AS DECIMAL)) AS avg_homicides, AVG (CAST(suicides AS DECIMAL)) AS avg_suicides, SHG.income
FROM PortfolioProject.dbo.SuicideHomicideGDP AS SHG
JOIN PortfolioProject.dbo.CountryRegion AS CoRe
	ON SHG.country = CoRe.Country
	AND SHG.iso3c = CoRe.iso3c
GROUP BY CoRe.region, SHG.income
ORDER BY avg_homicides DESC 
--ORDER BY avg_suicides DESC
















