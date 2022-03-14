--TABLES


--CovidDeaths
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--CovidVaccinations
SELECT *
FROM PortfolioProject.dbo.CovidVaccination
ORDER BY 3,4

--Join Tables
SELECT *
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
	

-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2


--COUNTRIES

-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract Covid19
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases*100) AS percentage_death
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Total Cases vs Population
-- Shows the proportion of people who got Covid 

SELECT location, date, total_cases, population, (total_cases/population*100) AS infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2 

-- Contries with Highest Infection Rate compared to Population

SELECT location, population,  MAX(total_cases) AS highest_infection_count, MAX((total_cases/population*100)) AS highest_infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY population, location
ORDER BY highest_infection_rate desc

-- Contries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int)) AS total_death_count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count desc


--CONTINENTS

-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract Covid19
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases*100) AS percentage_death
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is  null
ORDER BY 1,2

-- Total Cases vs Continent Population

SELECT location, date, total_cases, population, (total_cases/population*100) AS continent_infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is null
ORDER BY 1,2 

-- Continent with Highest Infection rate compared to Contient's Population

SELECT location, population,  MAX(total_cases) AS continent_highest_infection_count, MAX((total_cases/population*100)) AS continent_highest_infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is  null
GROUP BY population, location
ORDER BY continent_highest_infection_rate desc

-- Continent with Highest Death Count per Contient's Population

SELECT location, MAX(cast(total_deaths as int)) AS total_death_count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is  null
GROUP BY location
ORDER BY total_death_count desc



-- GLOBAL NUMBERS

--Global numbers throughout the pandemic

SELECT SUM(new_cases) AS global_cases, SUM(cast(new_deaths AS int)) AS global_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS percentage_death
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Daily global numbers throughout the pandemic

SELECT date, SUM(new_cases) AS global_cases, SUM(cast(new_deaths AS int)) AS global_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS percentage_death
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


-- Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
COUNT(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_Vaccinations
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- CTE 

WITH Pop_Vs_Vac (continent, location, date, population, new_vaccinations, rolling_vaccinations) 
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
COUNT(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_Vaccinations
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (rolling_vaccinations/population*100) AS percentage_population_vaccineted
FROM Pop_Vs_Vac 


-- TEMP TABLE

CREATE TABLE #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_vaccinations numeric
)

INSERT INTO  #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
COUNT(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_Vaccinations
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (rolling_vaccinations/population*100) AS percentage_population_vaccineted
FROM #PercentagePopulationVaccinated 


--View to store data

CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
COUNT(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_Vaccinations
FROM PortfolioProject.dbo.CovidDeaths AS dea
JOIN PortfolioProject.dbo.CovidVaccination AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null