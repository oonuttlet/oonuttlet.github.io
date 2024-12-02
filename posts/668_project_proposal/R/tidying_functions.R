# calculate decade for geometry requests
calculate_decade <- function(year) {
  as.numeric(year) - as.numeric(year) %% 10
}

# spatial join between events and tracts
relate_tracts_to_events <- function(tr, data, year) {
  tr_j <- tr |>
    st_join(data) |>
    mutate(event_decade = calculate_decade({{ year }})) |>
    st_filter(data)
}

# tabular join between ACS data and tracts from a given vintage
join_acs_to_events <- function(data_left, data_right, id_col) {
  data_right |>
    right_join(data_left, by = join_by(GEOID, data_yr), relationship = "many-to-many") |>
    distinct(GEOID, data_yr, variable, pt_in_time, {{ id_col }}, .keep_all = TRUE)
}

# tidy table and compute information
# if output = tidy, then variables will be aggregated across all intersecting tracts, but a difference will not be calculated
# if output = wide, then variables will be aggregated and differences will be calculated automatically
tidy_joined_events <- function(data, id_col, output) {
  dat_out <- data |>
    group_by({{ id_col }}, pt_in_time, data_yr, variable) |>
    reframe(computed = case_when(
      startsWith(variable, "mean") ~ mean(estimate, na.rm = TRUE),
      startsWith(variable, "median") ~ median(estimate, na.rm = TRUE),
      TRUE ~ sum(estimate, na.rm = TRUE)
    )) |>
    distinct(.keep_all = TRUE) |>
    ungroup() |>
    group_by({{ id_col }}, variable) |>
    filter(!is.na(variable)) |>
    arrange(desc(pt_in_time))
  if (output == "tidy") {
    return(dat_out)
  }
  dat_out |>
    reframe(diff = (computed[pt_in_time == "after"] - computed[pt_in_time == "before"]),
            acs_vintage = paste0(data_yr[pt_in_time == "before"], " to ",  data_yr[pt_in_time == "after"])) |>
    filter(!is.na(variable)) |>
    pivot_wider(id_cols = c({{ id_col }}, acs_vintage), names_from = c("variable"), values_from = c("diff"))
}

# join tidied table back to original events
join_tidy_to_events <- function(data, events, id_col) {
  events |>
    left_join(data, by = join_by({{ id_col }}))
}
