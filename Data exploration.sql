Select *
From PortfolioProject.dbo.CovidDeaths
Order by 3,4


Select *
From PortfolioProject.dbo.CovidVaccinations
Order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject.dbo.CovidDeaths
order by 1,2

--looking at Total cases vs Totals Deaths(DeathRate)
--shows the likelihood of dying if you contract covid in your contry

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRate
From PortfolioProject.dbo.CovidDeaths
Where location like '%africa%'
order by 1,2

--looking at total cases vs population
--shows what percentage of population contracted covid

Select location,date,population,total_cases,(total_cases/population)*100 as cases_percentage
From PortfolioProject.dbo.CovidDeaths
Where location like '%africa%'
order by 1,2

--looking at countries with highest infection rate vs the population

Select location, population,
MAX(total_cases)as HighestinfectionCount,
MAX((total_cases/population))*100 as PercentagePopulationInfected
From PortfolioProject.dbo.CovidDeaths
--Where location like '%africa%'
Group by location, population
order by PercentagePopulationInfected DESC

--continet with highest death count per population 
Select continent,
Max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by continent
Order by  HighestDeathCount DESC

--global numbers

Select SUM (new_cases) as Total_Cases,SUM(cast(new_deaths as int)) as Total_Deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage--total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
--Group by date
Order by 1,2 

--covid vacination table
--Looking at Total population vs vaccinated(how many individuals have been vaccinated in the world )
--lets join the two tables first using join

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast (vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date 
Where dea.continent is not null
order by 2, 3


--USE CTE
With PopvsVac(Continent, Location,Date,Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(cast (vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date 
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentageVaccinated
From PopvsVac









