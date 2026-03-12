# Wrangling the datasets into the correct format
library(tidyverse)
library(janitor)

# County codes
county_fips_PA <- read_csv("data/sandbox/county_fips_master.csv") %>%
  filter(state_abbr == "PA") %>%
  select(county, county_name)

pa_county_trees <- readRDS("data/sandbox/PA_county.rds") %>%
  left_join(county_fips_PA, by = join_by("COUNTYCD" == "county")) %>%
  mutate(county_short = str_remove(county_name, " County") %>% str_to_lower())

pa_county_boundaries <- map_data("county", "pennsylvania")

# Centroids for labels
pa_county_labels <- pa_county_boundaries %>% group_by(subregion) %>%
  summarize_at(vars(long, lat), ~ mean(range(.))) %>%
  mutate(county_label = str_to_title(subregion))
write_csv(pa_county_labels, "data/pa_county_labels.csv")

pa_county_trees <- pa_county_trees %>%
  left_join(pa_county_boundaries,
            by = join_by("county_short" == "subregion"))
write_csv(pa_county_trees, "data/pa_county_trees.csv")


###  Bucknell trees data
bucknell_trees <- read_csv("data/sandbox/bucknell_trees_engr100.csv") %>%
  clean_names() %>%
  select(-creator, -editor)

write_csv(bucknell_trees, "data/bucknell_trees.csv")
