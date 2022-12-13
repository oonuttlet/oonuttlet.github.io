# The Great Shrinking Lake
## Final Project for GES 381: Remote Sensing

This presentation was given as my final project for my remote sensing course at UMBC. It uses R and Google Earth Engine to analyze the relationship between the changing water area of the Great Salt Lake since 1986 and the growing population of the Wasatch Front and the Utah Valley. You can view the animated timeseries of the lake [here](/381_proj/images).

The report was limited in scope due to limited time to work: obviously, there are more factors contributing to a shrinking lake area than just population growth. However, in USGS's 2015 [Circular 1441]("https://pubs.er.usgs.gov/publication/cir1441") ranked Utah second of all states in per capita domestic water usage, so to say that the population of the Valley is not a major reason the Lake is losing water yearly would be undeniably false.

Linear correlation tests run in R yielded a significantly negative correlation of y ~ 0.0016x and an R-squared value of 0.78 (*p* << 0.001). In context, according to this model, for every 100,000 people that move to the Salt Lake area, 160 km<sup>2</sup> of water surface are lost. 

The R scripts for this report are available [here]() and the Earth Engine code is available [here](https://code.earthengine.google.com/5f7c5dd52c2292d35cbd8dc426d87578).

<object data="/381_proj/gsl_ppt.pdf" type="application/pdf" width="700px" height="700px"/>

