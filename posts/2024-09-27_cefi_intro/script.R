
suppressPackageStartupMessages({
  library(rnaturalearth)
  library(cefi)
  library(stars)
  library(dplyr)
  library(ggplot2)
})

point = tibble(lon = -69, lat = 42) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326)
uri = catalog_uri(region = "Northwest Atlantic", period = "forecast")
fcst = read_catalog(uri)
nc = fcst |>
  dplyr::filter(Variable_Name == "tob" & Time_of_Initialization == "1995-12") |>
  cefi_open()

nc = cefi_filter(nc, 
                 time = as.Date(c("1994-12-01", "1995-11-01")), 
                 xh = xh > -75 & xh < -60,
                 yh = yh > 40 & yh < 50)

s = cefi_var(nc, var = "tob")

coast = rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf") |>
  sf::st_crop(s) |>
  sf::st_geometry() 

png("tob-map.png")
plot(slice(s, time, 1), reset = F, main = "Temp of the Bottom (C)")
plot(coast, add = TRUE, col = "orange")
plot(st_geometry(point), add = TRUE, col = "blue")
ok = dev.off()

x = st_extract(s, point) |> as_tibble()
gg = ggplot(data = x, mapping = aes(x = time, y = tob)) + 
  geom_line() + 
  geom_point() + 
  labs(x = "Date", y = "Temp of Bottom (C)")
ggsave(
  "tob-timeseries.png", plot = gg)

