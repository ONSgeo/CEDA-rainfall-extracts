library(tidync)
library(dplyr)
library(stringr)
library(tidyr)
library(purrr)


#### Function: restructure_nc ####
#imports NC file, extracts rainfall data into df, creates human readable date format, pivots to short-wide structure, returns df of rainfall data

restructure_nc <- function(path){
  #loads and prints summary of NC file
  src <- tidync(path)
  print(src)
  
  #extract data's year from the file name
  year <- str_sub(sub(".*mon_", "", path), start = 1L, end = 4L) 
  
  #makes a data frame of the rainfall data grid
  rainfall_data <- hyper_tibble(src)
  
  #makes a data frame of the date grid
  D0 <- activate(src, "D0") %>% hyper_tibble()
  
  #join date grid to the rainfall data
  rainfall_data <- left_join(rainfall_data, D0, by = "time")
  
  #drops the season_year column, creates 2 digit month value (ie. 01 not 1), creates a column in the YYYYMM format.
  rainfall_data <- select(rainfall_data, -season_year) %>% 
    mutate(month_number = str_pad(month_number, side = "left", pad = "0", width = 2)) %>%  
    mutate(year_month = paste0(year, month_number))
  
  #pivots data from long thin to short wide format, with one column per month's rainfall data.
  output <- pivot_wider(rainfall_data, names_from = year_month, names_prefix = "rainfall_", values_from = rainfall, id_cols = c("projection_x_coordinate", "projection_y_coordinate"))
  
  #returns the reshaped data as a df
  return(output)
}


####Bulk extraction of NC format data####

#list all files to be extracted
files <- list.files(path = "//iddd1/Common/Chris_Gale/Spatial_Data/Natural_Captial/NC/CEDA NC Files/", pattern = "*.nc", full.names = TRUE)
#or just list path of one file
path <- "//iddd1/Common/Chris_Gale/Spatial_Data/Natural_Captial/NC/CEDA NC Files/rainfall_hadukgrid_uk_1km_mon_201201-201212.nc"


#using purrr::map run restructure_nc function on all files to load and extract rainfall data for multiple years
map_ncs <- map(files, restructure_nc)

#join all dfs in the map_ncs list of dfs together by the X and Y coordinates
output <- reduce(map_ncs, left_join, by = c("projection_x_coordinate", "projection_y_coordinate"))

#write output
write.csv(output, "//iddd1/Common/Chris_Gale/Spatial_Data/Natural_Captial/NC/CEDA NC Files/CEDA_rainfall_2012_2019_combined.csv", row.names = FALSE)