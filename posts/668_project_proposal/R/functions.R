check_acs_years <- function(yr) {
  if (any(yr <= 2010)) {
    cli::cli_abort("Tract data is available starting in 2010. Check the date of your event, and the range of years.")
  }
}

calculate_decade <- function(year) {
  as.numeric(year) - as.numeric(year) %% 10
}

relate_tracts_to_events <- function(tr, data, year) {
  tr_j <- tr |>
    st_join(data) |>
    mutate(event_decade = calculate_decade({{ year }})) |>
    st_filter(data)
}

get_incident_impacts <- function(data,
                                 id_col,
                                 year,
                                 years_before = 1,
                                 years_after = 1,
                                 variables = NULL,
                                 output = "tidy",
                                 ...) {
  data_prj <- data |>
    st_transform(4269) |>
    mutate(
      yr_before = as.numeric({{ year }}) - years_before,
      yr_after = as.numeric({{ year }}) + years_after
    )
  data_long <- data_prj |>
    pivot_longer(
      cols = c("yr_before", "yr_after"),
      names_to = "pt_in_time",
      values_to = "data_yr",
      names_pattern = "yr_(.*)"
    )
  ct <- get_counties_all_years(data_long, {{ year }})
  tc <- get_tracts_all_years(ct)
  dat_related <- relate_tracts_to_events(tc, data_long, data_yr)
  distinct_acs <- get_distinct_acs_info(dat_related, STATEFP, COUNTYFP, data_yr)
  acs_all_yr <- get_acs_all_years(distinct_acs, STATEFP, COUNTYFP, data_yr, variables)
  acs_joined <- join_acs_to_events(dat_related, acs_all_yr, {{ id_col }})
  tidy_joined <- tidy_joined_events(acs_joined, {{ id_col }}, output)
  join_tidy_to_events(tidy_joined, data, id_col = {{ id_col }}) |>
    st_as_sf()
}



