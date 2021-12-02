-- Select Data that we are going to be starting with

Select Location,continent, date, total_cases, new_cases, total_deaths, population
From [COVID-19 Data].dbo.[covid-data-death]
Where continent is not null
order by date


-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [COVID-19 Data].dbo.[covid-data-death]
Where location like 'France'
and continent is not null 
order by 1,2


-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/NULLIF(population, 0))*100 as PercentPopulationInfected
From [COVID-19 Data].dbo.[covid-data-death]
Where location like 'France'
AND continent is not null 
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/NULLIF(population, 0)))*100 as PercentPopulationInfected
From [COVID-19 Data].dbo.[covid-data-death]
Where continent is not null 
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [COVID-19 Data].dbo.[covid-data-death]
Where continent is not null
AND iso_code not like location
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [COVID-19 Data].dbo.[covid-data-death]
Where continent is not null 
Group by continent
order by TotalDeathCount desc




-- GLOBAL NUMBERS

Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
From [COVID-19 Data].dbo.[covid-data-death]
--Where location like 'France'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [COVID-19 Data].dbo.[covid-data-death] dea
Join [COVID-19 Data].dbo.[owid-covid-vaccination] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- AND dea.location like 'France'
order by 2,3


/*
-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [COVID-19 Data].dbo.[covid-data-death] dea
Join [COVID-19 Data].dbo.[owid-covid-vaccination] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
AND dea.location like 'France'
--order by 2,3
)
Select *, (RollingPeopleVaccinated/NULLIF(Population, 0))*100 as PercentPopulationVaccinated
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [COVID-19 Data].dbo.[covid-data-death] dea
Join [COVID-19 Data].dbo.[owid-covid-vaccination] vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/NULLIF(Population, 0))*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

CREATE VIEW WorkRollingPeopleVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [COVID-19 Data].dbo.[covid-data-death] dea
Join [COVID-19 Data].dbo.[owid-covid-vaccination] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
AND dea.location like 'France'



-- View of likelihood of dying if you contract covid in your country

CREATE VIEW WorkGlobalNumbers AS
Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
From [COVID-19 Data].dbo.[covid-data-death]
--Where location like 'France'
where continent is not null 
--Group By date
order by 1,2


-- View of what percentage of population infected with Covid

CREATE VIEW WorkPerncentPopulationInfectedByCountries AS
Select Location, date, Population, total_cases,  (total_cases/NULLIF(population, 0))*100 as PercentPopulationInfected
From [COVID-19 Data].dbo.[covid-data-death]
Where continent is not null 
order by 1,2

*/

