library(tidyverse)
library(ggplot2)
library(lubridate)
library(tsibbledata)
library(hrbrthemes)
library(leaflet)
library(sf) 

nyc_bikes_df <- nyc_bikes

#----------------- Adding Day, Month & Year Columns----------------------------
nyc_bikes_df <- nyc_bikes_df %>% 
  mutate(
    day = wday(start_time, label = TRUE, abbr = FALSE),
    month = month(start_time, label = TRUE, abbr = TRUE),
    year = year(start_time),
    start_hour = hour(start_time)
    
  )

#---------------- Subcriber Demographic ---------------------------------------

# create age_demographic column
nyc_bikes_df$age_demographic <- 
  ifelse(2018 - nyc_bikes_df$birth_year >= 18 & 2018 - nyc_bikes_df$birth_year <= 24, "18-24",
  ifelse(2018 - nyc_bikes_df$birth_year >= 25 & 2018 - nyc_bikes_df$birth_year <= 34, "25-34",
  ifelse(2018 - nyc_bikes_df$birth_year >= 35 & 2018 - nyc_bikes_df$birth_year <= 44, "35-44",
  ifelse(2018 - nyc_bikes_df$birth_year >= 45 & 2018 - nyc_bikes_df$birth_year <= 54, "45-54",
  ifelse(2018 - nyc_bikes_df$birth_year >= 55 & 2018 - nyc_bikes_df$birth_year <= 64, "55-64",
  ifelse(2018 - nyc_bikes_df$birth_year >= 65, "65+", NA))))))

# remove rows with birth year 1887 or 1888
nyc_bikes_df <- nyc_bikes_df[!(nyc_bikes_df$birth_year == 1887 | 
                                 nyc_bikes_df$birth_year == 1888),]



subscriber_demographic <- nyc_bikes_df %>% 
  filter(type == "Subscriber", gender != "Unknown") %>% 
  select(gender, age_demographic) %>% 
  group_by(gender) %>% 
  count(age_demographic, name = "no_trips")  %>% 
  ggplot(aes(x = age_demographic, y = no_trips, fill = gender )) +
  geom_col() +
  labs(
    x = "Age Demographic",
    y = "Number of Trips",
    title = "Breakdown of User Demographics") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    legend.key.size = unit(12, "pt")
  )

#-------------------- 2018 Subscriptions----------------------------------------
sub_month <- nyc_bikes_df %>% 
  filter(type == "Subscriber") %>% 
  select(month) %>% 
  count(month, name = "no_trips")  %>% 
  ggplot(aes(x = month, y = no_trips, group = 1)) +
  geom_line() +
  geom_point(shape=21, color="black", fill="#69b3a2", size=2) +
  labs(
    x = "Month",
    y = "Number of Trips",
    title = "Subscriber Useage in 2018") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    legend.key.size = unit(12, "pt")
  )

#---------------------- Calculating Peak Times ---------------------------------

## Peak Hours
peak_times_hr <- nyc_bikes_df %>% 
  count(start_hour) %>% 
  ggplot(aes(x = start_hour, y = n, group = 1 )) +
  geom_line() +
  geom_point(shape=21, color="black", fill="#69b3a2", size=2) +
  theme_ipsum() +
  labs(x = "Time (24h)", 
       y = "Number of Trips", 
       title = "Peak Times") +
  scale_x_continuous(breaks = seq(0, 23, by = 2))

## Peak Days
peak_times_day <- nyc_bikes_df %>% 
  count(day) %>% 
  ggplot(aes(x = day, y = n, group = 1 )) +
  geom_line() +
  geom_point(shape=21, color="black", fill="#69b3a2", size=2) +
  theme_ipsum() +
  labs(x = "Day", 
       y = "Number of Trips", 
       title = "Number of Trips per Day") +
  scale_x_discrete(limits = 
          c("Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday", "Sunday"))

#----------------------- Station Visualisation ---------------------------------
station_location_map <- nyc_bikes_df %>% 
  leaflet() %>% 
  addTiles() %>% 
  addMarkers(
    lng = ~start_long,
    lat = ~start_lat,
    clusterOptions = markerClusterOptions()
  )

