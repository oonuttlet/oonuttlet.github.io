## This can be your internal website page / project page

**Project description:** Using Python scripting and GIS packages, maps were developed to find the differences in where someone lives and where their nearest air quality sensor is.

### 1. Suggest hypotheses about the causes of observed phenomena

Underserved communities across the country are often overlooked by the EPA's AQS monitoring network, usually based on economic, political, and social motivations. Since the likelihood of living nearer to industry and manufacturing falls disproportionately on marginalized communities, the lack of information about hyperlocal air quality in these areas can be deadly. 

Brands like PurpleAir and IQAir offer a simple, all-in-one package to track various air quality metrics such as PM2.5, ground-level ozone, and oxides, while modular, open-source kits exist for the more tech-savvy built on platforms such as Arduino and Raspberry Pi. Many of these options can be configured to output AQI, depending on the types of data collected. These sensors cost between $100 and $5,000 depending on the options selected. Though this is orders of magnitude less expensive than the regulation-grade monitors, these prices are still prohibitive to lower-income households.

<img src="images/distro.png?raw=true"/>

### 2. Assess assumptions on which statistical inference will be based

Python was used to pull the location of PurpleAir sensors for Maryland and surrounding states. A k-dimensional search tree was used to locate the nearest PurpleAir sensor to each census tract in the area, and then the difference in median household income (MHI) and percentage of BIPOC residents was calculated for each tract and the tract in which its nearest sensor was located.

### 3. Support the selection of appropriate statistical tools and techniques

<img src="images/it worked MHI.png" width="2500" />

### 4. Provide a basis for further data collection through surveys or experiments

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. 

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).
