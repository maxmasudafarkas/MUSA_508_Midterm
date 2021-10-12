if(!require(pacman)){install.packages("pacman"); library(pacman)}
p_load(tigris, tidycensus, sf, tidyverse, stringr, viridis)

var19 <- load_variables(2019, "acs5", cache = TRUE)

# C24070 is industry of employment

acs_vars <- c(
  "B19013_001E", # Med HH Income
  "C24070_001E", # Labor force
  "C24070_002E", # Agriculture, forestry, fishing and hunting, and mining
  "C24070_003E", # Construction
  "C24070_004E", # Manufacturing
  "C24070_005E", # Wholesale trade
  "C24070_006E", # Retail trade
  "C24070_007E", # Transportation and warehousing, and utilities
  "C24070_008E", # Information
  "C24070_009E", # Finance and insurance, and real estate, and rental and leasing
  "C24070_010E", # Professional, scientific, and management, and administrative, and waste management services
  "C24070_011E", # Educational services, and  health care and social assistance
  "C24070_012E") # Arts, entertainment, and recreation, and accommodation and food services

acsTractsBoulder.2019.sf <- get_acs(geography = "tract",
                                   year = 2019, 
                                   variables = acs_vars, 
                                   geometry = TRUE, 
                                   state = "CO", 
                                   county = "Boulder", 
                                   output = "wide")

acsTractsBoulder.2019.sf <- acsTractsBoulder.2019.sf %>%
  dplyr::select(GEOID, NAME, all_of(acs_vars)) %>%
  rename(med_HH_Income = B19013_001E,
         employed = C24070_001E,
         Ag_Mining = C24070_002E,
         Construction = C24070_003E,
         Manufacturing = C24070_004E,
         Wholesale = C24070_005E,
         Retail = C24070_006E,
         Transportation = C24070_007E,
         Information = C24070_008E,
         Finance = C24070_009E,
         Professional = C24070_010E,
         Ed_Health = C24070_011E,
         ArtsRecEnt = C24070_012E) %>%
  mutate(
         pct.Ag_Mining = Ag_Mining/employed,
         pct.Construction = Construction/employed,
         pct.Manufacturing = Manufacturing/employed,
         pct.Wholesale = Wholesale/employed,
         pct.Retail = Retail/employed,
         pct.Transportation = Transportation/employed,
         pct.Information = Information/employed,
         pct.Finance = Finance/employed,
         pct.Professional = Professional/employed,
         pct.Ed_Health = Ed_Health/employed,
         pct.ArtsRecEnt = ArtsRecEnt/employed)

ggplot() +
  geom_sf(data = acsTractsBoulder.2019.sf, aes(fill = med_HH_Income)) +
  scale_fill_viridis()

ggplot() +
  geom_sf(data = acsTractsBoulder.2019.sf, aes(fill = pct.Professional)) +
  scale_fill_viridis()

ggplot() +
  geom_sf(data = acsTractsBoulder.2019.sf, aes(fill = pct.Ed_Health)) +
  scale_fill_viridis()
