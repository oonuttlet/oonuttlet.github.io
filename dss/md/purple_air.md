## Sociospatial distribution of PurpleAir sensors in Maryland

**Project description:** Ensuring accurate and updated air quality information to all Americans should be a public health priority. Particularly with today’s increased manufacturing, wildfires, and transportation, air quality reporting is absolutely necessary.

### The spatial distribution of citizen-science air quality sensors disproportionately affects already marginalized individuals.

By continuing to rely on wide-scale data for reporting, the government is leveling one more public health concern against communities already facing elevated health risks due to class- and race-based discrimination.


### Using [PurpleAir's public data](https://map.purpleair.com/) and USCB tract data, differences were calculated between where someone lives and their closest sensor.

scipy's cKDTree was used to perform a nearest-neighbor analysis between census tracts and PurpleAir sensors.

### Differences were found.

<img src="dss/it worked MHI.png?raw=true"/> <br> Particularly in west Baltimore, it was found that there were large differences between the tract in which someone lived and the tract where their nearest sensor was located (designated in red).

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).
