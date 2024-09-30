suppressPackageStartupMessages({
  library(readr)
  library(ggplot2)
  library(dplyr)
})

# https://www.bts.gov/state-transportation-infrastructure
roads = readr::read_csv("Infra_data.csv.gz",
                        col_types = "ccnn") |>
  select(Year = Year, State = State, Miles = Value)

# https://datahub.transportation.gov/Roadways-and-Bridges/Motor-Vehicle-Registrations-by-vehicle-type-and-st/hwtm-7xmz/data_preview
regs = readr::read_csv("Motor_Vehicle_Registrations__by_vehicle_type_and_state_20240920.csv.gz",
                       col_types = "ncnnnn") |>
  dplyr::rowwise() |>
  mutate(total = sum(c_across(Auto:Motorcycle), na.rm = TRUE)) |>
  select(State = state, Year = year, Regs = total)
us = group_by(regs, Year) |>
    group_map(
      function(tbl, key){
        tibble(Year = key$Year, State = "United States", Regs = sum(tbl$Regs))
      }) |>
  bind_rows()

regs = bind_rows(regs, us)

p1 = ggplot(filter(regs, State != "United States"), 
       mapping = aes(x = Year, y = Regs, group = State)) + 
  geom_line(alpha = 0.2) + 
  geom_line(data = filter(regs, State == "Maine"),
            linewidth = 1.3, color = "orange") +
  labs(y = "State Vehicle Registrations",
       caption = "https://datahub.transportation.gov/Roadways-and-Bridges",
       title = "State Vehicle Registrations")

ggsave("regs.png", plot = p1)


p2 = ggplot(filter(roads, State != "United States"), 
       aes(x = Year, y = Miles, group = State)) +
  geom_line(alpha = 0.2) + 
  geom_line(data = filter(roads, State == "Maine"),
            linewidth = 1.3, color = "orange") +
  labs(y = "State Miles of Public Roads",
       caption = "https://www.bts.gov/state-transportation-infrastructure",
       title = "State Miles of Public Roads")

ggsave("roads.png", plot = p2)


x = left_join(roads, regs, by = c("Year", "State")) |>
  mutate(Density = Regs/Miles) |>
  na.omit()


p3 = ggplot(filter(x, State != "United States"), 
       aes(x = Year, y = Density, group = State)) +
  geom_line(alpha = 0.2) + 
  geom_line(data = filter(x, State == "Maine"),
            linewidth = 1.3, color = "orange") +
  labs(y = "Registrations/Mile",
       title = "State Vehicle Registrations per Mile of Public Road")
ggsave("density.png", plot = p3)
