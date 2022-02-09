/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 2

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
WHERE Continent IS NOT NULL
ORDER BY 3,4

-- Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location like '%states%' AND Continent IS NOT NULL
ORDER BY 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got infected with Covid

SELECT Location, date, Population, total_cases, (total_cases/Population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location = 'Canada' AND Continent IS NOT NULL
ORDER BY 1,2

-- Looking at countries with highest infection rates compared to Population

SELECT Location, MAX(total_cases) AS HighestInfectionCount, Population, MAX((total_cases/Population)*100) AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

-- Showing Countries with Highest Death Count Per Population

SELECT Location, MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- Showing continents with the highest death count per population

SELECT Continent, MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS
-- Global Death Percentage per day

SELECT Date, SUM(new_cases) AS TotalCases, SUM(cast(new_deaths as int)) AS TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--Global Death Percentage as of today

SELECT SUM(new_cases) AS TotalCases, SUM(cast(new_deaths as int)) AS TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1,2



SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS RollingTotalVaccinations
FROM PortfolioProject.dbo.CovidDeaths AS Dea
INNER JOIN PortfolioProject.dbo.CovidVaccinations AS Vac
	ON Dea.Location = Vac.Location
	AND Dea.Date = Vac.Date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3

--- CREATING AND USING A COMMON TABLE EXPRESSION

WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingTotalVaccinations)
AS
(SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS RollingTotalVaccinations
FROM PortfolioProject.dbo.CovidDeaths AS Dea
INNER JOIN PortfolioProject.dbo.CovidVaccinations AS Vac
	ON Dea.Location = Vac.Location
	AND Dea.Date = Vac.Date
WHERE Dea.continent IS NOT NULL
)

SELECT *, (RollingTotalVaccinations/population)*100
FROM PopVsVac

-- CREATING A TEMP TABLE

DROP TABLE IF EXISTS #TotalVaccinations
CREATE TABLE #TotalVaccinations
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
TotalPeopleVaccinated numeric
)

INSERT INTO #TotalVaccinations
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS RollingTotalVaccinations
FROM PortfolioProject.dbo.CovidDeaths AS Dea
INNER JOIN PortfolioProject.dbo.CovidVaccinations AS Vac
	ON Dea.Location = Vac.Location
	AND Dea.Date = Vac.Date
WHERE Dea.continent IS NOT NULL

SELECT *, (TotalPeopleVaccinated/population)*100 AS PercentPeopleVaccinated
FROM #TotalVaccinations
ORDER BY 2,3

-- CREATING A VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW TotalVaccinations AS
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(CONVERT(bigint, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS RollingTotalVaccinations
FROM PortfolioProject.dbo.CovidDeaths AS Dea
INNER JOIN PortfolioProject.dbo.CovidVaccinations AS Vac
	ON Dea.Location = Vac.Location
	AND Dea.Date = Vac.Date
WHERE Dea.continent IS NOT NULL

SELECT *
FROM TotalVaccinations
