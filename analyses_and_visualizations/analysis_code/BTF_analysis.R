##
##    Project:    Save Brown Track & Field/Cross Country!!!
##
##    Name:       BTF_analysis.R
##
##    Approach:   Read in and analyze data from Brown varsity sports, including financial data
##                and data on Brown Track and Field accolades
##                
##    Authors:    Calvin J. Munson
##
##    Date:       May 29th, 2020
##
##    Note:       Use Cmd + Shift + O to open RStudio's outline functionality, which will provide
##                better organization for this script


# 1. Set up ---------------------------------------------------------------

## Clean up
rm(list=ls())

## Set working directory
setwd("~/Desktop/savebrowntrack.github.io/analyses_and_visualizations")


# * 1.1 Call to key packages ---------------------------------------------

## Key data visualization packages
library(tidyverse)
library(patchwork)
library(scales)


# * 1.2 Read in data ------------------------------------------------------

## Operating cost data for 2019
cost_raw <- read_csv("data_raw/varsity_operating_costs_2019.csv") %>% 
  mutate(is.track = if_else(`Varsity Sport` == "Track/XC", "TRUE", "FALSE"))

cost_raw$`Varsity Sport` %>% unique()

# * 1.3 Calculate per capita operating costs ------------------------------

## Divide total team operating cost by number of athletes on rost for each row
cost_perAthlete <- cost_raw %>% 
  mutate(`Cost per Athlete` = `Operating Costs`/Roster)


# * 1.4 Create separate Male/Female dataframes ----------------------------

cost_perAthlete.Men <- cost_perAthlete %>% 
  filter(Gender == "Men")

cost_perAthlete.Women <- cost_perAthlete %>% 
  filter(Gender == "Women")


# 2. Data visualizations --------------------------------------------------


# * 2.1 Cost per athlete for each team ------------------------------------

## Calculate cost per roster spot vs cost per athlete
# Explanation: The roster of Brown Men's Track and Field and Cross country is calculated by the
# administration by adding together all registered athletes for Indoor (47), outdoor (44), 
# and Cross Country (17). In reality, almost every athlete overlaps between indoor and outdoor 
# (except for outdoor exclusive events like javelin). In addition, all cross country runners
# run both indoor and outdoor as well. Thus, the number of unique athletes on the Track, Field, 
# and XC roster would be, conservatively, the maximum of any of the three rosters, or 47 
# (though others may not have participated due to injury)
cost_perUnique <- cost_perAthlete.Men %>% 
  filter(`Varsity Sport` == "Track/XC") %>% 
  mutate(`Varsity Sport` = "Track/XC (per unique athlete)",
         Roster = 47,
         `Cost per Athlete` = `Operating Costs`/`Roster`)




## Plot Cost per athlete for each varsity team (Men)
cost_perAthlete.Men %>% 
  # Bind the row created above
  bind_rows(cost_perUnique) %>% 
  # Rename the original Track/XC label as Track/XC per roster spot
  mutate(`Varsity Sport` = fct_recode(`Varsity Sport`,
                                      "Track/XC (per roster spot)" = "Track/XC")) %>% 
  # Reorder Sport by cost per athlete (reorders the labels on the axis)
  mutate(`Varsity Sport` = fct_reorder(`Varsity Sport`, `Cost per Athlete`)) %>% 
  # Assemble plot
  # Assign fill to Track/XC
  ggplot(aes(x = `Varsity Sport`, y = `Cost per Athlete`, fill = is.track)) +
  geom_col(color = "black",
           width = 0.75) +
  geom_text(aes(label = dollar(round(`Cost per Athlete`, 0))),
            size = 4.5,
            nudge_y = 2000,
            hjust = 0) +
  annotate(y = 69000,
           x = "Track/XC (per unique athlete)",
           geom = "text",
           hjust = 0,
           vjust = 1,
           label = "Data taken from the 2019 \n'Equity in Athletics' report") +
  scale_fill_manual(values = c("saddlebrown", "red")) +
  scale_y_continuous(limits = c(0, 100000),
                     labels = dollar) +
  coord_flip() +
  ggtitle("Operating cost per roster spot for Men's varsity teams",
          subtitle = "Based on Brown University's 2019 athletic season") +
  labs(y = "Cost per roster spot") +
  theme_minimal() + 
  theme(axis.text.x = element_text(size = 14,
                                   margin = margin(t = 0.5, unit = "cm")),
        axis.text.y = element_text(size = 14,
                                   color = "black"),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 14,
                                    margin = margin(t = 0.5, unit = "cm")),
        plot.title = element_text(size = 16),
        plot.subtitle = element_text(size = 13,
                                     face = "italic"),
        plot.margin = margin(0.5, 0.5, 0.5, r = 0.75, unit = "cm"),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = "none")
  
## Export as pdf
ggsave("figures/costs_per_roster.pdf",
       height = 6,
       width = 8.5,
       dpi = 320)

## Also export as png
ggsave("figures/costs_per_roster.png",
       height = 6,
       width = 8.5,
       dpi = 640)



# * 2.2 Total operating costs per team ------------------------------------


## Plot Cost per athlete for each varsity team (Men)
cost_perAthlete.Men %>% 
  # Reorder Sport by cost per athlete (reorders the labels on the axis)
  mutate(`Varsity Sport` = fct_reorder(`Varsity Sport`, `Operating Costs`)) %>% 
  # Assemble plot
  # Assign fill to Track/XC
  ggplot(aes(x = `Varsity Sport`, y = `Operating Costs`, fill = is.track)) +
  geom_col(color = "black",
           width = 0.75) +
  geom_text(aes(label = dollar(round(`Operating Costs`, 0))),
            size = 5,
            nudge_y = 100000,
            hjust = 0) +
  scale_fill_manual(values = c("saddlebrown", "red")) +
  scale_y_continuous(limits = c(0, 4500000),
                     labels = dollar) +
  coord_flip() +
  ggtitle("Total operating cost for Men's varsity teams",
          subtitle = "Based on the 2019 season") +
  theme_minimal() + 
  theme(axis.text.x = element_text(size = 14,
                                   margin = margin(t = 0.5, unit = "cm")),
        axis.text.y = element_text(size = 14,
                                   color = "black"),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 16,
                                    margin = margin(t = 0.5, unit = "cm")),
        plot.title = element_text(size = 18),
        plot.subtitle = element_text(size = 14),
        plot.margin = margin(0.5, 0.5, 0.5, r = 0.75, unit = "cm"),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        legend.position = "none")
