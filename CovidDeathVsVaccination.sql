select * from CovidDeath
select * from CovidVaccination

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeath
where where continent is not null
order by 1,2 

--Looking for total Death vs Total Cases

select location,date,total_cases,new_cases,total_deaths,round((total_deaths/total_cases)*100,2) as DeathPercentage
from CovidDeath
where location like '%states' and continent is not null
order by 1,2 

--Looking total cases vs popluation
-- Show what percentage has got covid

select location,date,total_cases,new_cases,population,total_deaths,round((total_cases/population)*100,2) as PopulationPercentage
from CovidDeath
where location like '%India' and total_cases is not null and continent is not null
order by 1,2 

--Country with highest Infection Rate compared to Population

select location,population,max(total_cases) as HighestInfection,max(round((total_cases/population)*100,2)) as PopulationPercentage
from CovidDeath
where continent is not null
group by location, population
order by PopulationPercentage desc

--Country with highest Death Rate compared to Population

select location,max(cast(total_deaths as int)) as TotalDeath
from CovidDeath
where continent is not null
group by location
order by TotalDeath desc

--Breaking on the basis of Continent

select continent,max(cast(total_deaths as int)) as TotalDeath
from CovidDeath
where continent is not null
group by continent
order by TotalDeath desc

--Showing contient with highest death count per population

select continent,max(cast(total_deaths as int)) as TotalDeath
from CovidDeath
where continent is not null
group by continent
order by TotalDeath desc

--Global Number

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_death,sum(cast(new_deaths as int))/sum(new_cases)*100
as DeathPercentage
from CovidDeath
where continent is not null
order by 1,2 

--Looking for total population vs total vacination	

select d.continent,d.location,d.date,d.population,v.new_vaccinations, 
sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from CovidDeath d 
join CovidVaccination v
on d.location=v.location
and d.date=v.date
where new_vaccinations is not null
order by 1,2,3

--Using CTE


Insert into #PercentPeopleVaccianted
With PopvsVac (Continet,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select d.continent,d.location,d.date,d.population,v.new_vaccinations, 
sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from CovidDeath d 
join CovidVaccination v
on d.location=v.location
and d.date=v.date
--order by 1,2,3
)
select * from Popvsvac

--Temp Table

--Create Table #PercentPeopleVaccianted
(
Continet nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPeopleVaccianted
select d.continent,d.location,d.date,d.population,v.new_vaccinations, 
sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from CovidDeath d 
join CovidVaccination v
on d.location=v.location
and d.date=v.date
--order by 1,2,3

--create view for data for later visualization

Create view Globalnumber as 
select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_death,sum(cast(new_deaths as int))/sum(new_cases)*100
as DeathPercentage
from CovidDeath
where continent is not null
--order by 1,2 

