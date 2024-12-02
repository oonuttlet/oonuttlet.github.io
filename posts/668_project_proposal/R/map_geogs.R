# function wrapped by `get_counties_all_years()`
# handles different vintages (and different column names) by default
map_counties <- function(data, decade) {
  ct <- counties(
    resolution = "20m",
    year = decade,
    filter_by = st_bbox(data)
  )

  if (decade == 2000){
    ct_std <- ct |>
      mutate(
        decade = decade,
        GEOID = paste0(STATEFP, COUNTYFP)
      ) |>
      distinct(STATEFP, COUNTYFP, decade, .keep_all = TRUE) |>
      select(GEOID, STATEFP, COUNTYFP, decade, geometry) |>
      st_as_sf()
    return(ct_std)
  }

  ct_std <- ct |>
    select(-c(STATEFP, COUNTYFP)) |>
    (\(df) {
      names(df) <- gsub("\\d{2}", "", names(df))
      df
    })() |>
    mutate(
      STATEFP = str_sub(GEOID, 1, 2),
      COUNTYFP = str_sub(GEOID, 3, 5),
      decade = decade
    ) |>
    distinct(STATEFP, COUNTYFP, decade, .keep_all = TRUE) |>
    select(GEOID, STATEFP, COUNTYFP, decade, geometry) |>
    st_as_sf()
  return(ct_std)
}

# function wrapped by `get_tracts_all_years()`
# handles different vintages (and different column names) by default
map_tracts <- function(s, c, y) {
  tc <- tracts(
    state = s,
    county = c,
    year = y
  )

  if ("GEOID" %in% names(tc)){
    tc_std <- tc |>
      select(-c(STATEFP, COUNTYFP)) |>
      (\(df) {
        names(df) <- gsub("\\d{2}", "", names(df))
        df
      })() |>
      mutate(
        STATEFP = str_sub(GEOID, 1, 2),
        COUNTYFP = str_sub(GEOID, 3, 5),
        decade = y
      ) |>
      select(GEOID, STATEFP, COUNTYFP, decade, geometry) |>
      st_as_sf()
    return(tc_std)
  }

  tc_std <- tc |>
    select(-c(STATEFP, COUNTYFP)) |>
    (\(df) {
      names(df) <- gsub("\\d{2}", "", names(df))
      df
    })()  |>
    select(STATEFP, COUNTYFP, TRACTCE, geometry) |>
    mutate(decade = y,
           GEOID = paste0(STATEFP, COUNTYFP, TRACTCE)) |>
    st_as_sf()
  return(tc_std)
}

# iterate `map_counties()` over distinct combinations of years, then filter by event geography
get_counties_all_years <- function(data, year) {
  message("Getting counties...")
  years <- dplyr::pull(data, {{ year }})
  decades <- unique(calculate_decade(years))

  purrr::map(
    decades,
    \(y) suppressMessages(map_counties(data, decade = y))
  ) |>
    list_rbind() |>
    st_as_sf() |>
    st_filter(data)
}

# iterate `map_tracts()` over distinct combinations of state, county, and decade (returned by `get_counties_all_years()`)
get_tracts_all_years <- function(ct) {
  message("Getting tracts...")
  tr <- purrr::pmap(
    list(
      ct$STATEFP,
      ct$COUNTYFP,
      ct$decade
    ),
    suppressMessages(map_tracts)
  ) |>
    list_rbind() |>
    st_as_sf() |>
    st_filter(ct)
}
