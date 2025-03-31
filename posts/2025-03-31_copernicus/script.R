suppressPackageStartupMessages({
  library(rnaturalearth)
  library(sf)
  library(copernicus)
  library(stars)
  library(dplyr)
})



fcstpath = copernicus_path("GLOBAL_ANALYSISFORECAST_PHY_001_024/nwa")
lut = product_lut("GLOBAL_ANALYSISFORECAST_PHY_001_024")

longnames = lut$standard_name |>
  rlang::set_names(lut$short_name)

fcstdb = read_database(fcstpath)

fcast = read_copernicus(slice_tail(fcstdb, n=1), fcstpath) 
names(fcast) = longnames[names(fcast)]

png("forecast.png")
plot(fcast, axes = TRUE, reset = FALSE)
dev.off()


histpath = copernicus_path("GLOBAL_MULTIYEAR_PHY_001_030/nwa")
histdb = read_database(histpath)
lut = product_lut("GLOBAL_MULTIYEAR_PHY_001_030")

longnames = lut$standard_name |>
  rlang::set_names(lut$short_name)

summary(histdb)