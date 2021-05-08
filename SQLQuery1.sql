use PortfolioProject
-- Firstly taking a look at the tables ,
Select * from coviddeaths

Select * from covidvaccinations

-- Checking the new and total cases, and also deaths in countries by ascending date order

Select location,date,new_cases,total_cases,new_deaths,total_deaths,population from coviddeaths
order by location,date

--It can be obtained from the table that in Afghanistan, first case was seen in 24th February,2020 and first death is in 22nd March,2020.
--Let me query for my own country, Turkey.

Select location,date,new_cases,total_cases,new_deaths,total_deaths,population from coviddeaths where location='Turkey'
order by location,date

-- First case in 2020-03-11 whereas first death is in 2020-03-17 just in a week after the first case.
-- In order to see what percentage of the total cases ended up passing away,total_deaths is divided to total_cases.

Select location,date,new_cases,total_cases,new_deaths,total_deaths,round(total_deaths/total_cases*100,2) as DeathPercentage from coviddeaths
order by location,date

--Round function is used to prevent percentage values from looking ugly.
--Let's see the ratio of total cases to the population

Select location,date,total_cases,population,total_cases/population*100 as case_percentage from coviddeaths where location='Turkey'
order by case_percentage desc

--As can be seen, final results show 5.8% of the total population met with covid. This means roughly 1 person out of 20 people got covid in Turkey

select distinct location , 
(select max(total_cases) as max_case from coviddeaths where location=c.location) as max_case, 
population, 
round((select max(total_cases) as max_case from coviddeaths where location=c.location)*100/population,2) as highest_infection_rate
from coviddeaths c
group by location,population,total_cases/population
order by highest_infection_rate desc

-- This query allow us to see which countries have the highest infection rates. To have more meaningful answers, we can limit the query
-- for the countries with at least 10,000,000 population

select distinct location , 
(select max(total_cases) as max_case from coviddeaths where location=c.location) as max_case, 
population, 
round((select max(total_cases) as max_case from coviddeaths where location=c.location)*100/population,2) as highest_infection_rate
from coviddeaths c
group by location,population,total_cases/population
having population>10000000
order by highest_infection_rate desc

--Czehia, United States and Sweden seem to be the top 3 countries with the highest infection rates with at least 10,000,000 population

-- To see the countries with highest death numbers per population, the following query is written

select distinct location,(SELECT max(total_deaths) from coviddeaths where location=c.location) as total_deaths,population,
round((SELECT max(total_deaths) from coviddeaths where location=c.location)*100/population,2) as deaths_per_population
from coviddeaths c
group by location,population
having population>10000000
order by deaths_per_population desc
-- Italy , France  and UK are the countries with highest death per population whose populations are at least 10,000,000
-- Because the query also shows continents, we can eliminate them by the following query

select distinct location,(SELECT max(total_deaths) from coviddeaths where location=c.location) as total_deaths,population,
round((SELECT max(total_deaths) from coviddeaths where location=c.location)*100/population,2) as deaths_per_population
from coviddeaths c
group by location,population,continent
having population>10000000 and continent is not null
order by deaths_per_population desc

-- Great!
-- Time to turn focus on vaccinations
