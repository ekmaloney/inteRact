## code to prepare `us_2015_full` dataset goes here
library(here)
library(tidyverse)

us_2015_id <- read_csv("data-raw/FullSurveyorInteract_Identities.csv")
us_2015_beh <- read_csv("data-raw/FullSurveyorInteract_Behaviors.csv")
us_2015_mod <- read_csv("data-raw/FullSurveyorInteract_Modifiers.csv")

combine_dictionary <- function(id_d, beh_d, mod_d, country, year) {
  id_d <- id_d %>% mutate(type = "identity", country = country, year = year)
  beh_d <- beh_d %>% mutate(type = "behavior", country = country, year = year)
  mod_d <- mod_d %>% mutate(type = "modifier", country = country, year = year)

  full_dictionary <- bind_rows(id_d, beh_d, mod_d) %>%
                     mutate(term = tolower(term))

  return(full_dictionary)
}

us_2015_full <- combine_dictionary(us_2015_id, us_2015_beh, us_2015_mod, "US", 2015)

usethis::use_data(us_2015_full, overwrite = TRUE)
