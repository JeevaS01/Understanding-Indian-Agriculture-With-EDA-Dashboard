use agriculture;
select * from agri;

#1.Year-wise Trend of Rice Production Across States (Top 3)

select `State Name`,round(sum(`RICE PRODUCTION (1000 tons)`),2)as `Total Rice Production` from agri
group by `State Name`
order by `Total Rice Production` desc
limit 3;

#2.Top 5 Districts by Wheat Yield Increase Over the Last 5 Years
select `Dist Name`,round(sum(`WHEAT YIELD (Kg per ha)`),2) as `Total Wheat Yield` from agri
where `Year`>=2013
group by `Dist Name`
order by `Total Wheat Yield` desc
limit 5;

#3.States with the Highest Growth in Oilseed Production (5-Year Growth Rate)

select `State Name`,round(sum(`OILSEEDS PRODUCTION (1000 tons)`),2) as `Total Production`,
concat(
round(
sum(`OILSEEDS PRODUCTION (1000 tons)`)*100/
(select sum(`OILSEEDS PRODUCTION (1000 tons)`) from agri 
where `Year`>=2013),2),'%') as `Growth Rate`
from agri
where `Year`>=2013
group by`State Name`
order by `Total Production` desc;

#4.District-wise Correlation Between Area and Production for Major Crops (Rice, Wheat, and Maize)
SELECT `Dist Name`,
  ROUND(
    (
      COUNT(*) * SUM(`RICE AREA (1000 ha)` * `RICE PRODUCTION (1000 tons)`) -
      SUM(`RICE AREA (1000 ha)`) * SUM(`RICE PRODUCTION (1000 tons)`)
    ) /
    SQRT(
      (COUNT(*) * SUM(POWER(`RICE AREA (1000 ha)`, 2)) - POWER(SUM(`RICE AREA (1000 ha)`), 2)) *
      (COUNT(*) * SUM(POWER(`RICE PRODUCTION (1000 tons)`, 2)) - POWER(SUM(`RICE PRODUCTION (1000 tons)`), 2))
    ),
    4
  ) AS rice_correlation,

  ROUND(
    (
      COUNT(*) * SUM(`WHEAT AREA (1000 ha)` * `WHEAT PRODUCTION (1000 tons)`) -
      SUM(`WHEAT AREA (1000 ha)`) * SUM(`WHEAT PRODUCTION (1000 tons)`)
    ) /
    SQRT(
      (COUNT(*) * SUM(POWER(`WHEAT AREA (1000 ha)`, 2)) - POWER(SUM(`WHEAT AREA (1000 ha)`), 2)) *
      (COUNT(*) * SUM(POWER(`WHEAT PRODUCTION (1000 tons)`, 2)) - POWER(SUM(`WHEAT PRODUCTION (1000 tons)`), 2))
    ),
    4
  ) AS wheat_correlation,

  ROUND(
    (
      COUNT(*) * SUM(`MAIZE AREA (1000 ha)` * `MAIZE PRODUCTION (1000 tons)`) -
      SUM(`MAIZE AREA (1000 ha)`) * SUM(`MAIZE PRODUCTION (1000 tons)`)
    ) /
    SQRT(
      (COUNT(*) * SUM(POWER(`MAIZE AREA (1000 ha)`, 2)) - POWER(SUM(`MAIZE AREA (1000 ha)`), 2)) *
      (COUNT(*) * SUM(POWER(`MAIZE PRODUCTION (1000 tons)`, 2)) - POWER(SUM(`MAIZE PRODUCTION (1000 tons)`), 2))
    ),
    4
  ) AS maize_correlation
FROM agri
group by `Dist Name`;

#5.Yearly Production Growth of Cotton in Top 5 Cotton Producing States

select `Year`,`State Name`,round(sum(`COTTON PRODUCTION (1000 tons)`),2) `Total Production` from agri
group by `Year`,`State Name`
order by `Total Production` desc
limit 5;

#6.Districts with the Highest Groundnut Production in 2017
select `Dist Name`,sum(`GROUNDNUT PRODUCTION (1000 tons)`) as `Total Production` from agri
where `Year`=2017
group by `Dist Name`
order by `Total Production` desc;

#7.Annual Average Maize Yield Across All States
select `Year`,`State Name`,round(avg(`MAIZE YIELD (Kg per ha)`),2) as `Average Maize Yield` from agri 
group by `Year`,`State Name`;

#8.8.Total Area Cultivated for Oilseeds in Each State
select `State Name`,round(sum(`OILSEEDS AREA (1000 ha)`),2) as `Total Area` from agri 
group by `State Name`;

#9.Districts with the Highest Rice Yield 
select `Dist Name`,round(sum(`RICE YIELD (Kg per ha)`),2) as `Total Rice Yield` from agri 
group by `Dist Name`
order by `Total Rice Yield` desc;

#10.Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years

WITH top_states AS (
    SELECT
        `State Name`,
        SUM(`RICE PRODUCTION (1000 tons)` + `WHEAT PRODUCTION (1000 tons)`) AS total_production
    FROM `agri`
    WHERE `Year` BETWEEN 2008 AND 2017
    GROUP BY `State Name`
    ORDER BY total_production DESC
    LIMIT 5
)
SELECT
        `Year`,
        `State Name`,
        round(SUM(`RICE PRODUCTION (1000 tons)`),2) AS rice_production,
        round(SUM(`WHEAT PRODUCTION (1000 tons)`),2) AS wheat_production
    FROM `agri`
    WHERE `Year` BETWEEN 2008 AND 2017
      AND `State Name` IN (SELECT `State Name` FROM top_states)
    GROUP BY `Year`, `State Name`
    ORDER BY `State Name`, `Year`;


