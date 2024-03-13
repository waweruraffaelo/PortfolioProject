--- use pf CTE

with PopvsVac (continent,location,date,population,new_vaccinations,DailyPeopleVaccinated)
as
(
select d.continent,d.location,d.date,d.population,
v.new_vaccinations,
SUM(cast(v.new_vaccinations as int)) OVER (Partition by d.location order by d.location,
d.date) as DailyPeopleVaccinated
from CovidDeaths d
join CovidVaccines v
	on d.location  = v.location and
	   d.date = v.date
where d.continent is  not null
--order by 2,3
)

select * ,( DailyPeopleVaccinated/population)*100 as PopulationVaccinated
from PopvsVac


----TEMP TABLE
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
DailyPeopleVaccinated numeric)


Insert into #PercentPopulationVaccinated
select d.continent,d.location,d.date,d.population,
v.new_vaccinations,
SUM(cast(v.new_vaccinations as int)) OVER (Partition by d.location order by d.location,
d.date) as DailyPeopleVaccinated
from CovidDeaths d
join CovidVaccines v
	on d.location  = v.location and
	   d.date = v.date
--where d.continent is  not null
--order by 2,3
select * ,( DailyPeopleVaccinated/population)*100 as PopulationVaccinated
from #PercentPopulationVaccinated

---create view 

create  View PercentPopulationVaccinated as
select d.continent,d.location,d.date,d.population,
v.new_vaccinations,
SUM(cast(v.new_vaccinations as int)) OVER (Partition by d.location order by d.location,
d.date) as DailyPeopleVaccinated
from CovidDeaths d
join CovidVaccines v
	on d.location  = v.location and
	   d.date = v.date
where d.continent is  not null
--order by 2,3