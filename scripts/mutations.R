library(tidyverse)

cols <- cols_only(
  Area = col_double(), Feret = col_double(), MinFeret = col_double(),
  AR = col_double(), Round = col_double(), Solidity = col_double(),
  L_BlackBackground = col_double(), a_BlackBackground = col_double(),
  b_BlackBackground = col_double(), L_GreenBackground = col_double(),
  a_GreenBackground = col_double(), b_GreenBackground = col_double(),
  Color_sd = col_double(), ColorNature = col_character(),
  Group = col_character(), RF_use = col_logical(),
  File_Name = col_character(), Particle_Num = col_integer()
)

data <- list.files("data", pattern = "*.csv$", full.names = T) |> 
  map(\(path) read_csv(path, col_types = cols)) |> 
  list_rbind() |>  janitor::clean_names()

data <- data |> distinct(file_name, particle_num, .keep_all = TRUE)

data <- data |> mutate(
  id = str_c(file_name, "_", particle_num), .keep = "unused", .before = 1
)

data <- data |> mutate(
  group = group |> fct_collapse(
    turf = c("Artificial turf", "Artificial.turf"),
    filament = c("Filament"),
    film = c("Film.Sheet", "Film/Sheet"),
    foam = c("Foam"),
    fragment = c("Fragment"),
    pellet = c("Pellet"),
    spherule = c("Spherule.Microbead", "Spherule/Microbead"),
    other_level = "other"
  )
)

data |> write_rds("data/plastics.rds")

