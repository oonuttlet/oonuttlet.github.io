# Equitable Access to Dockless Vehicles in Baltimore City

## Introduction

In 2019, Baltimore City officially adopted its [**Dockless Vehicle Program**](https://transportation.baltimorecity.gov/bike-baltimore/dockless-vehicles), granting permits to micromobility companies Link, Lime, and Spin. The goal of this program was to supplement existing public transit networks, to provide a sustainable alternative for small-scale commuting, and, according to the Baltimore DOT, to be ridden just "for fun!" 

As the 'dockless' name implies, these scooters have nowhere to call home: they're placed down by local employees of the scooter vendor, remain out for up to weeks at a time, then recollected for maintenance and recharging before being placed out again. Baltimore City lays out clear Deployment Zones and Deployment Equity Zones, in which a certain amount of scooters must remain for the vendors to continue operation in the city. 

These zones are relatively small compared to the size of the city boundary: do they make scooter distribution truly equitable? Using the vendors' public API endpoints (another requirement for operation within the city), data was (and is being) collected on scooter locations every fifteen minutes. For this project, I only analyzed times between 6:00 am and 10:00 am for the week of May 1, 2022 and May 7, 2022; but the potential is there for much more detailed analysis.

The python script which queries the API endpoints for all three vendors is currently running on [Mapping Capital](https://mapping.capital), and all other analysis was done using R statistical software. The scripts I used to manipulate the data collected can be found [here](/finalproj/scripts.md).

## Results

For this analysis, I've coined a new unit: people-points. Represented by the total number of jobs as represented in LEHD data added with the total population in a given area, people-points can be used to find centers of transport and human activity as people commute to and from work and home. I'll be symbolizing my maps based on the number of scooters per person-point (in this case, per 1,000 people-points for better scaling) in order to pick out locations where the number of scooters is not proportional to the number of jobs and residents in an area.

Here are the resulting maps, made in `ggplot2` and arranged using `patchwork`:
