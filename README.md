# Extracting rainfall data from CEDA

We were asked to help open .nc file formats containing [rainfall data from CEDA](https://catalogue.ceda.ac.uk/uuid/c732716511d3442f05cdeccbe99b8f90). Obviously, as a bunch of human geographers, none of us had a clue how to do that. However, as there's an R package for everything we managed to extract the data using [tidync](https://ropensci.org/blog/2019/11/05/tidync/) and some liberal tidyverse-ing. Here's the code. 

![An example of CEDA data extracted.](https://github.com/ONSgeo/CEDA-rainfall-extracts/blob/main/example.PNG?raw=true)
