SELECT 	*
FROM	PortfolioProject.CovidVaccinations
ORDER BY 3,4

SELECT location, `date`, total_cases, new_cases, total_deaths, population 
FROM	PortfolioProject.CovidDeaths
ORDER BY 1,2

-- Looking at total cases vs total deaths:
-- Shows the likelihood of dying if youy contract covid in your country
SELECT location, `date`, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'Death(%)' 
FROM	PortfolioProject.CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- Looking at total cases vs population:
-- Shows what precentage of population got COVID
SELECT location, `date`, population, total_cases, (total_cases/population)*100 as 'Infection(%)' 
FROM	PortfolioProject.CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- Looking at Countries with highest infection rate compared to population:
SELECT location, population, MAX(total_cases) AS HighestInfactionCount, MAX(total_cases/population)*100 as 'PopulationInfected(%)' 
FROM		PortfolioProject.CovidDeaths
GROUP BY	1,2
ORDER BY 	4 DESC

-- Looking at Countries with highest infection rate compared to population:
SELECT location, population, MAX(total_cases) AS HighestInfactionCount, MAX(total_cases/population)*100 as 'PopulationInfected(%)' 
FROM		PortfolioProject.CovidDeaths
GROUP BY	1,2
ORDER BY 	4 DESC

-- Showing countries with highest death count per population:
-- SELECT location, population, MAX(total_deaths) AS TotalDeathCount, MAX(total_deaths /population)*100 as 'PopulationDeath(%)' 
SELECT 		location, MAX(total_deaths) AS TotalDeathCount
FROM		PortfolioProject.CovidDeaths
WHERE		continent IS NOT NULL
GROUP BY	1
ORDER BY 	2 DESC

-- Let's break down things down by continent:
-- Showing continents with the highest death count population
SELECT 		continent , MAX(total_deaths) AS TotalDeathCount
FROM		PortfolioProject.CovidDeaths
WHERE		continent IS NOT NULL
GROUP BY	1
ORDER BY 	2 DESC

-- Global numbers:
SELECT 	SUM(new_cases) AS TotalCases, SUM(new_deaths) TotalDeaths, (SUM(new_deaths)/SUM(new_cases)) * 100 as 'Death(%)' 
FROM	PortfolioProject.CovidDeaths
WHERE	continent IS NOT NULL
-- GROUP BY `date` 
ORDER BY 1,2

-- Looking at total population vs vaccinations:
WITH	PopvsVac (continent, location, Date, population, new_vaccinations, RollingpeopleVac) AS
(
SELECT 	cd.continent, cd.location, cd.`date`, cd.population, cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.`date`) AS RollingpeopleVac
FROM 	PortfolioProject.CovidDeaths cd
		JOIN PortfolioProject.CovidVaccinations cv
		ON cd.location = cv.location
		AND cd.`date` = cv.`date`
WHERE	cd.continent IS NOT NULL
)
SELECT *, RollingpeopleVac / population * 100
FROM	PopvsVac