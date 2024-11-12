map_data.default <- function(s, c, y, v){
  suppressMessages(get_acs(geography = "tract",
          state = s,
          county = c,
          year = y,
          variables = v,
          survey = "acs5",
          geometry = F)
  )
}

map_data <- function(s, c, y, v){
  UseMethod("map_data", s)
}


get_distinct_acs_info <- function(data, state, county, acs_year){
  data |>
    distinct({{ state }},
             {{ county }},
             {{ acs_year }})
}

get_acs_all_years <- function(data,
                              state,
                              county,
                              acs_year,
                              variables = NULL){
  message("Getting ACS data...")
  message("If this is slow, try reducing the geographic or temporal range of your data.")
  s = pull(data, {{ state }})
  c = pull(data, {{ county }})
  y = pull(data, {{ acs_year }})

  acs_vars <-
    c("pop_total" = "B03002_001", # total population
      "pop_nh_white" = "B03002_003", # non-Hispanic White
      "pop_nh_black" = "B03002_004", # non-Hispanic Black
      "pop_nh_aian" = "B03002_005", # non-Hispanic American Indian/Alaskan Native
      "pop_nh_asian" = "B03002_006", # non-Hispanic Asian
      "pop_nh_hipi" = "B03002_007", # non-Hispanic Native Hawaiian And Other Pacific Islander
      "pop_nh_other" = "B03002_008", # non-Hispanic Some Other Race Alone
      "pop_nh_two" = "B03002_009", # non-Hispanic Two or More Races
      "pop_hisp" = "B03002_012", # Hispanic or Latino
      "median_hhi" = "B19013_001",  # median household income
      "mean_hh_size" = "B25010_001", # household size
      "sch_enrollment" = "B14001_002", # school enrollment
      variables # user-declared variables
    )

  purrr::pmap(list(s, c, y),
              \(s,c,y) map_data(
                s = s,
                c = c,
                y = y,
                v = acs_vars
              ) |>
                mutate(data_yr = y)) |>
    list_rbind()
}
