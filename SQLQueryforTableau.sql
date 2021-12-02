-- Queries used for Tableau Project

-- Global Numbers

Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
From [COVID-19 Data].dbo.[covid-data-death]
where continent is not null 
order by 1,2

-- Total Deaths Per Continent
Select continent, SUM(cast(new_deaths as float)) as TotalDeathCount
From [COVID-19 Data].dbo.[owid-covid-vaccination]
Where continent is not null
group by continent
order by TotalDeathCount asc
offset 0 rows
fetch next 6 rows only;


-- Percent Population Infected Per Country

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/NULLIF(population, 0)))*100 as PercentPopulationInfected
From [COVID-19 Data].dbo.[covid-data-death]
Group by Location, Population
order by PercentPopulationInfected desc


-- Percent Population Infected by date


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/NULLIF(population, 0)))*100 as PercentPopulationInfected
From [COVID-19 Data].dbo.[covid-data-death]
Group by Location, Population, date
order by PercentPopulationInfected desc
