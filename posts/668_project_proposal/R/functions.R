#' Get local ACS 5-year data before and after a historic event.
#'
#' @param data An sf object.
#' @param id_col An unquoted column name containing uniquely-identified event IDs.
#' @param year An unquoted column name containing the year of the event.
#' @param years_before An integer describing the number of years to look backward from the event.
#' @param years_after An integer describing the number of years to look forward from the event.
#' @param variables Any additional ACS variables (in tidycensus syntax) to be included in the output.
#' @param output One of "tidy" (the default) or "wide," describing if the output table should be pivoted and differences calculated automatically.
#' @param ... Passed to other functions
#'
#' @return An sf object, containing Census information from before and after an event's occurrence.
#' @export
#'
#' @examples
get_incident_impacts <- function(data,
                                 id_col,
                                 year,
                                 years_before = 2,
                                 years_after = 3,
                                 variables = NULL,
                                 output = "tidy",
                                 ...) {
  check_sf_input(data)
  check_id_col_unique(pull(data, {{ id_col }}))
  check_year_inclusive(years_before, years_after)
  check_year_overlap(years_before, years_after)

  data_prj <- data |>
    st_transform(4269) |>
    mutate(
      yr_before = as.numeric({{ year }}) - years_before,
      yr_after = as.numeric({{ year }}) + years_after
    )

  check_acs_years(data_prj$yr_before)

  data_long <- data_prj |>
    pivot_longer(
      cols = c("yr_before", "yr_after"),
      names_to = "pt_in_time",
      values_to = "data_yr",
      names_pattern = "yr_(.*)"
    )
  ct <- get_counties_all_years(data_long, data_yr)
  tc <- get_tracts_all_years(ct)
  dat_related <- relate_tracts_to_events(tc, data_long, data_yr)
  distinct_acs <- get_distinct_acs_info(dat_related, STATEFP, COUNTYFP, data_yr)
  acs_all_yr <- get_acs_all_years(distinct_acs, STATEFP, COUNTYFP, data_yr, variables)
  acs_joined <- join_acs_to_events(dat_related, acs_all_yr, {{ id_col }})
  tidy_joined <- tidy_joined_events(acs_joined, {{ id_col }}, output)
  join_tidy_to_events(tidy_joined, data, id_col = {{ id_col }}) |>
    st_as_sf()
}
