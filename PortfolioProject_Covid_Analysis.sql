/****SELECT * FROM CovidDeaths
ORDER BY 3, 4

SELECT * FROM CovidVaccinations
ORDER BY 3, 4

select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1, 2

-- TotalCases vs TotalDeaths
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS deathPercentage
from CovidDeaths`
where location = 'India'
order by 5
-- The percentage of dying from complications due to COVID was never higher than 3.5% in India

-- Percentage of the population that got COVID-19
select Location, date, total_cases, population, (total_cases/population)*100 AS CasesOverPopulationPercent
from CovidDeaths
where location = 'India'
order by 5 desc
-- The percentage of contracting COVID was never higher than 3.2 % of the Indian population. The Indian population is quit high so that's a large number of people at 44 Million

-- Highest Infections Rate compared to Population per Country
select Location, population, MAX(total_cases) AS HighestInfectedCountry, MAX((total_cases/population))*100 AS PercentagePopulationInfected
from CovidDeaths
--where location = 'India'
group by Location, population
order by 4 desc
-- India is not in the top 50 countries with the highest infection rate

-- TotalDeathCount per Country
select Location, max(cast(Total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by Location
order by 2 desc
-- India is third in TotalDeaths behind USA by a margin of nearly 600,000 people, and Brazil by a margin of nearly 170,000 people

-- TotalDeathCount per Continent
select location, max(cast(Total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is null
group by location
order by 2 desc
-- India is third in TotalDeaths behind USA by a margin of nearly 600,000 people, and Brazil by a margin of nearly 170,000 people

-- Global daily numbers of cases, deaths and death percentage
select date, sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, case when sum(new_cases) <> 0 then (sum(cast(new_deaths as int)) / sum(new_cases)) * 100 else null end as deathPercentage
from CovidDeaths
where continent is not null
group by date
order by 4 desc
-- Global death percentage of people infected vs death was less than 31% each day

-- Global daily numbers of cases, deaths and death percentage
select sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, case when sum(new_cases) <> 0 then (sum(cast(new_deaths as int)) / sum(new_cases)) * 100 else null end as deathPercentage
from CovidDeaths
where continent is not null
order by 3 desc
-- Globally this virus has killed less than 1% of the people(7 milion people) that contracted it
***/

