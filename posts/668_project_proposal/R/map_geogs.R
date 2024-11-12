map_counties.default <- function(bbox, decade) {
  counties(
    resolution = "20m",
    year = decade,
    filter_by = st_bbox(bbox)
  ) |>
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
    distinct(STATEFP, COUNTYFP, decade, .keep_all = T) |>
    st_as_sf()
}

map_counties <- function(data, decade) {
  UseMethod("map_counties", data)
}

map_tracts.default <- function(s, c, y) {
  tracts(
    state = s,
    county = c,
    year = y
  ) |>
    select(-c(STATEFP, COUNTYFP)) |>
    (\(df) {
      names(df) <- gsub("\\d{2}", "", names(df))
      df
    })() |>
    mutate(
      STATEFP = str_sub(GEOID, 1, 2),
      COUNTYFP = str_sub(GEOID, 3, 5),
      decade = y
    )
}

map_tracts <- function(s, c, y) {
  UseMethod("map_tracts", s)
}

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
