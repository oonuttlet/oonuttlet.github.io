library(ipumsr)
library(dplyr)
library(stringr)
library(tidycensus)
library(ggplot2)
library(gganimate)
library(tidyverse)

setwd("G:\\My Drive\\~2223\\381\\final_proj\\~gsl")
list.files()

ut_ts <- read_nhgis("data/nhgis0005_ts_geog2010_tract.csv") %>%
  filter(STATE == "Utah") %>%
  filter(str_detect(COUNTY, "Utah County|Salt Lake County|Davis|Weber|Box Elder|Tooele")) %>%
  select(c(1,6,8:17)) %>%
  pivot_longer(cols = tidyselect::starts_with("CL8AA"))%>%
  filter(name %in% c("CL8AA1990","CL8AA2000","CL8AA2010","CL8AA2020"))

ut_ts.lm <- ut_ts %>% mutate(year = str_sub(ut_ts$name, start = -4,-1), value = round(value)) %>%
  select(-name) %>%
  filter(as.numeric(year) <= 2010)
ut_ts.split <- ut_ts.lm %>%
  group_by(GISJOIN) %>%
  group_split()
ut_model <- lapply(ut_ts.split, function(x) lm(value~as.numeric(year), x))
summary(ut_model)

ut_ts.pred <- list()
for (i in 1:length(ut_model)){
  ut_ts.pred[[i]] = data.frame(year = c(1986:2009), 
                               GISJOIN = first(ut_ts.split[[i]]$GISJOIN), 
                               COUNTYA = first(ut_ts.split[[i]]$COUNTYA))
  ut_ts.pred[[i]]$tpop = round(predict(ut_model[[i]], newdata = ut_ts.pred[[i]]))
} 
ut_ts.pred <- bind_rows(ut_ts.pred)

ut_ts.sum <- ut_ts.pred %>%
  group_by(year)%>%
  mutate(tpop = sum(tpop)) %>%
  ungroup()%>%
  distinct(year, .keep_all = TRUE) %>%
  select(year, tpop)

ut_acs.list <- lapply(c(2010:2020), function(y) get_acs(geography = "county", state = "UT", year = y, survey = "acs5", variables = "B01001_001", cache_table = TRUE) %>% mutate(year = y)) %>%
  bind_rows()
ut_acs.filtered <- ut_acs.list %>% filter(str_detect(NAME, "Utah County|Salt Lake County|Davis|Weber|Box Elder|Tooele")) %>%
  group_by(year) %>%
  mutate(tpop = sum(estimate))%>%
  ungroup()%>%
  distinct(year, .keep_all = TRUE) %>%
  select(year, tpop)

ut_tpop <- bind_rows(ut_ts.sum, ut_acs.filtered)

year_area_gsl <- read_csv("data/year_area_gsl.csv")
vars_joined <- left_join(ut_tpop, year_area_gsl) %>% mutate(area_km = (area/1e6), tpop_mn = (tpop/1e6))
vars_joined <- na.omit(vars_joined)
write_csv(vars_joined, file = "data/vars_joined.csv")

