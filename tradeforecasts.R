# World Economic Outlook Oct 2024

##### SETUP ####
library(tidyverse); library(readxl); library(janitor); library(fable); library(forecast)

df_weo <- read_excel("WEOOct2024alla.xlsx", sheet = "Sheet1") %>% 
  pivot_longer(cols = 9:58, names_to = "year", values_to = "value") %>% clean_names() %>%
  mutate(year = as.numeric(year))

################

##### Historical Brent Crude Prices
plotbrenthis <- df_weo %>% filter(weo_subject_code == "POILBRE" & country_group_name == "World") %>%
  filter(year <= 2024) %>%
  ggplot(aes(year, value)) + 
  geom_line(colour = "blue") + 
  geom_point(size = 1.2) + 
  scale_y_continuous(breaks = c(20,40,60,80,100,120)) +
  scale_x_continuous(breaks = c(1980,1985,1990,1995,2000,2005,2010,2015,2020,2025)) +
  theme_minimal() +
  labs(x = "", y = "Dated Brent, $US/barrel", title = "Historical Brent Crude Prices",
       caption = "Data retrieved from IMF World Economic Outlook, October 2024.")
ggsave("brent_historical.png", plotbrenthis, width = 8, height = 5, units = "in")

# Plotting APSP Index shows same price movements as Brent chart

##### Simple Brent Crude Forecast
df_brent <- df_weo %>% filter(weo_subject_code == "POILBRE" & country_group_name == "World") %>%
  filter(year <= 2024) %>% select(year, value) %>% as_tsibble(index = year)
df_brent2 <- df_weo %>% filter(weo_subject_code == "POILBRE" & country_group_name == "World") %>%
  filter(year > 2024) %>% select(year, value) %>% as_tsibble(index = year)

# Determine specification
acf(df_brent$value)
pacf(df_brent$value) # AR1

# Create the forecast given the AR(1) specification
brentf <- df_brent %>% 
  model(arima = ARIMA(value ~ 0 + pdq(1,0,0))) %>% forecast(h = 5)

# Construct the plot
plotbrentf <- ggplot(df_brent, aes(year, value)) +
  geom_line(colour = "black", linewidth = 1) +
  geom_line(data = brentf, aes(year, .mean)) +
  geom_line(data = df_brent2, aes(year, value), colour = "red", linewidth = 2) +
  autolayer(brentf, alpha = 0.4) + 
  scale_y_continuous(breaks = c(20,40,60,80,100,120)) +
  scale_x_continuous(breaks = c(1980,1990,2000,2010,2020,2025,2030)) +
  theme_minimal() + 
  labs(x ="", y = "Dated Brent, $US/barrel", title = "Brent Crude Forecast, h = 5",
       subtitle = "IMF forecast represented in red, ours in blue.",
       caption = "Data retrieved from IMF World Economic Outlook, October 2024.")
plotbrentf
ggsave("brent_forecast.png", plotbrentf, width = 8, height = 5, units = "in")

#autoplot(df_brent) + autolayer(brentf)


#### Historical Export Volume Growth
plottradehist <- df_weo %>% filter(weo_subject_code == "TXG_RPCH" & country_group_name == "World") %>%
  filter(year <= 2024) %>%
  ggplot(aes(year, value)) +
  geom_line(linewidth = 1) + 
  geom_hline(aes(yintercept=0),size = 0.5, colour = "blue") +
  scale_x_continuous(breaks = c(1980,1985,1990,1995,2000,2005,2010,2015,2020,2025)) +
  theme_minimal() +
  labs(x = "", y = "Export Volume Growth Rate (%)", title = "Historical World Export Volume Growth",
       caption = "Data retrieved from IMF World Economic Outlook, October 2024.")
plottradehist
ggsave("tradev_historical.png", plottradehist, width = 8, height = 5, units = "in")

##### Export Growth Forecast
df_export <- df_weo %>% filter(weo_subject_code %in% c("POILBRE","TXG_RPCH","NID_NGDP"))  %>%
  filter(year <= 2024) %>% select(weo_subject_code, country_group_name, year, value) %>%
  pivot_wider(names_from = c(weo_subject_code, country_group_name), values_from = value) %>%
  as_tsibble(index = year)
df_export2 <- df_weo %>% filter(weo_subject_code %in% c("POILBRE","TXG_RPCH","NID_NGDP"))  %>%
  filter(year > 2024) %>% select(weo_subject_code, country_group_name, year, value) %>%
  pivot_wider(names_from = c(weo_subject_code, country_group_name), values_from = value) %>%
  as_tsibble(index = year)

# Determine specification
acf(df_export$TXG_RPCH_World)
pacf(df_export$TXG_RPCH_World) # Neither show a specific process
acf(df_export$`TXG_RPCH_Advanced economies`)
pacf(df_export$`TXG_RPCH_Advanced economies`)
auto.arima(df_export$TXG_RPCH_World, d=1, trace = T) # ARIMA(2,1,1) appears to be best


# Create the forecast given the ARIMA(2,1,1) specification
exportf <- df_export %>% 
  model(arima = ARIMA(TXG_RPCH_World ~ 0 + pdq(2,1,1))) %>% forecast(h = 5)

# Construct the plot
plotexportf <- ggplot(df_export, aes(year, TXG_RPCH_World)) +
  geom_line(colour = "black", linewidth = 1) +
  geom_line(data = exportf, aes(year, .mean)) +
  geom_line(data = df_export2, aes(year, TXG_RPCH_World), colour = "red", linewidth = 2) +
  autolayer(exportf, alpha = 0.4) + 
  scale_x_continuous(breaks = c(1980,1990,2000,2010,2020,2025,2030)) +
  theme_minimal() + 
  labs(x ="", y = "Export Volume Growth (%)", title = "World Export Volume Forecast, h = 5",
       subtitle = "IMF forecast represented in red, ours in blue.",
       caption = "Data retrieved from IMF World Economic Outlook, October 2024.")
plotexportf
ggsave("export_forecast.png", plotexportf, width = 8, height = 5, units = "in")
