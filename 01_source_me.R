#A bit of pre-processing to speed up the app.
library(tidyverse)
library(here)
library(feather)
library(janitor)
library(assertthat)
library(readxl)
library(fpp3)
library(readxl)

observed_data <- here("raw_data", "Employment by 64 LMO industries for BC and regions, 1997-2021.xlsx")
old_forecast_data <- here("raw_data", "LMO 2021 Industry Forecast.xlsx")
driver_data <- here("raw_data","Driver Based Forecast.xlsx")

observations <- read_excel(observed_data, skip=2)%>%
  pivot_longer(cols =! c("Industry Code", "Industry"), names_to = "year", values_to = "employment")%>% 
  clean_names()%>%
  mutate(year = as.numeric(year),
         industry = paste(industry_code, industry, sep = "-"))%>%
  select(-industry_code)

write_feather(observations, here("data_for_app", "observations.feather"))

################ old forecasts
old_forecast <- read_excel(old_forecast_data)%>%
  pivot_longer(cols =! c("IND_CODE", "Industry"), names_to = "year", values_to = "forecast")%>%
  clean_names()%>%
  mutate(industry = paste(ind_code, industry, sep = "-"),
         year = as.numeric(year))%>%
  select(-ind_code)%>%
  as_tsibble(key=industry, index=year)

fit <- old_forecast%>% #fit linear model to last year's forecasts
  model(`Linear Trend` = TSLM(forecast ~ trend()))

forecasts <- fit %>% #add one year to last year's forecast
  forecast(h = "1 year")%>%
  as_tibble()%>%
  select(industry, year, forecast=.mean)

old_forecast <- bind_rows(old_forecast, forecasts)

write_feather(old_forecast, here("data_for_app", "old_forecast.feather"))
########driver data

driver_data <- read_excel(driver_data)%>%
  mutate(industry=paste(`Ind Code`,`Ind Des`, sep="-"))%>%
  select(-`Ind Code`,-`Ind Des`)%>%
  pivot_longer(cols=!industry,names_to = "year", values_to = "employment")%>%
  mutate(year=as.numeric(year))

write_feather(driver_data, here("data_for_app", "driver_data.feather"))


