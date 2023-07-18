-- Total population vs vaccinations
WITH PopVsVac AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingCountVaccinations
    FROM
        CovidDeaths dea
    JOIN
        CovidVaccinations vac
    ON
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
)



SELECT
    *,
    (RollingCountVaccinations / population) * 100 AS VaccinationPercentage
FROM
    PopVsVac

--TEMP TABLE

Drop table if exists #percentPopulationVaccinated
CREATE TABLE #percentPopulationVaccinated
(
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vaccinations numeric,
  RollingCountVaccinations numeric
)
Insert into #percentPopulationVaccinated
SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingCountVaccinations
    FROM
        CovidDeaths dea
    JOIN
        CovidVaccinations vac
    ON
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL


SELECT
    *,
    (RollingCountVaccinations / population) * 100 AS VaccinationPercentage
FROM
    #percentPopulationVaccinated

--Create view to store data for visualizations
create view PercentPopulationVaccinated as
SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingCountVaccinations
    FROM
        CovidDeaths dea
    JOIN
        CovidVaccinations vac
    ON
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL

***/
