SELECT *
FROM CovidDeaths
Where continent is null
order by 3,4


--SELECT *
--FROM CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
Where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
---Shos likelihood of dying if you contract COVID19 in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
--Where location like '%states%'
Where continent is not null
order by 1,2


-- Looking at Total Cases vs Population
--Shows what percentage of population got COVID19

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationinfected
FROM CovidDeaths
--Where location like '%states%'
Where continent is not null
order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by  location, population
order by PercentagePopulationInfected DESC


--Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount DESC


--Breakdowns by Continent 
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--Where location like '%states%'
Where continent is null
Group by location
order by TotalDeathCount DESC


--Showing Continents with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--Where location like '%states%'
Where continent is null
Group by location
order by TotalDeathCount DESC



--Global Numbers

Select SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)as DeathPercentage
FROM CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1,2


--Total Population vs Vaccinations, Numbers will be skewed due to multiple vaccinations per person

--Using CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinations

FROM CovidDeaths dea
Join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
 )
 Select *, (RollingPeopleVaccinated/Population)*100
 FROM PopvsVac