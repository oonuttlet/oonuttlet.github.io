join_acs_to_events <- function(data_left, data_right, id_col){
  data_right |>
    right_join(data_left, by = join_by(GEOID, data_yr), relationship = 'many-to-many') |>
    distinct(GEOID, data_yr, variable, pt_in_time, {{ id_col }}, .keep_all = T)
}

tidy_joined_events <- function(data, id_col, output){
  dat_out <- data |>
    group_by({{ id_col }}, pt_in_time, variable) |>
    reframe(computed = case_when(
      startsWith(variable, "mean") ~ mean(estimate, na.rm = T),
      startsWith(variable, "median") ~ median(estimate, na.rm = T),
      TRUE ~ sum(estimate, na.rm = T)
    )) |>
    distinct() |>
    ungroup() |>
    group_by({{ id_col }}, variable) |>
    filter(!is.na(variable)) |>
    arrange(desc(pt_in_time))
  if(output == "tidy"){
    return(dat_out)
  }
  dat_out |>
    reframe(diff = (computed[pt_in_time == "after"] - computed[pt_in_time == "before"])) |>
    filter(!is.na(variable)) |>
    pivot_wider(id_cols = {{ id_col }}, names_from = "variable", values_from  = "diff")
}

join_tidy_to_events <- function(data, events, id_col){
  events |>
    left_join(data, by = join_by({{ id_col }}))
}
