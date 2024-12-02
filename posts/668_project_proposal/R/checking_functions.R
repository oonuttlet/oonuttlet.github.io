### GENERAL CHECKING FUNCTIONS ###

# check if year is valid
check_acs_years <- function(yr) {
  if (any(yr < 2009)) {
    cli::cli_abort("ACS data is available starting in 2009. Check the date(s) of your event, and the range of years.")
  }
}

# check if there is enough distance between before and after vintages
check_year_overlap <- function(yrs_before, yrs_after) {
  if (yrs_before + yrs_after < 5) {
    cli::cli_abort("5-year ACS data is only comparable with a gap of 5 years or greater.")
  }
}

# check if both years are greater than zero
check_year_inclusive <- function(yrs_before, yrs_after) {
  if (any(c(yrs_before, yrs_after) <= 0)) {
    cli::cli_abort("`years_before` and `years_after` must be greater than 1.")
  }
}

# check if data is an sf object
check_sf_input <- function(data) {
  if (!is(data, "sf")) {
    cli::cli_abort("`data` must be an `sf` object.")
  }
}

# check if id column is uniquely IDed (otherwise, join issues will occur)
check_id_col_unique <- function(id_col) {
  if (any(duplicated({{ id_col }}))) {
    cli::cli_abort("`id_col` is not uniquely identified.")
  }
}

