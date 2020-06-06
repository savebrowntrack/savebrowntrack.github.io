##
##    Project:    Save Brown Track & Field/Cross Country!!!
##
##    Name:       BTF_diversity_analysis.R
##
##    Approach:   Read in and analyze data from Brown varsity sports, including financial data
##                and data on Brown Track and Field and surveyed cost data from Youth Sports
##                
##    Authors:    Calvin J. Munson
##
##    Date:       June 6th, 2020
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

## NCAA-wide data
ncaa_div_raw <- read_csv("data/diversity/data_raw/ncaa.csv")

## Just Ivy-League data
Ivy_div_percent <- read_xlsx("data/diversity/data_intermediate/brown_racial_data_mens.IvyLeague.xlsx", sheet = "By Percent")



# 2. Clean NCAA data ------------------------------------------------------


# * 2.1 Separate out combined columns -------------------------------------

# What are the unique Divisions in this dataset?
ncaa_div_raw$Division_Subdivision %>% unique()

# What are the unique Gender_Race combinations?
ncaa_div_raw$`Gender_Race/Ethnicity` %>% unique()

# What are the unique Sports?
ncaa_div_raw$Sport %>% unique()


## Separate out the division_subdivision and gender_race columns
ncaa_div_sep <- ncaa_div_raw %>% 
  # Separate by the "_" which separates division and subdivision
  separate(col = Division_Subdivision, 
           into = c("Division", "Subdivision", "Subdivision_2"), 
           sep = "_", 
           remove = FALSE) %>% 
  # Unite subdivisions which had a second "_" in them
  unite(col = "Subdivision", Subdivision, Subdivision_2) %>% 
  # Separate Gender and Race from the Gender_Race column
  separate(col = `Gender_Race/Ethnicity`, into = c("Gender", "Race/Ethnicity"), sep = "-")



# * 2.2 Pivot data --------------------------------------------------------

## Pivot data frame so that year is its own column, and the number of people in each category goes
# into its own row
ncaa_div_pivot <- ncaa_div_sep %>% 
  pivot_longer(cols = c(`2012`, `2013`, `2014`, `2015`, `2016`, `2017`, `2018`, `2019`), 
               names_to = "Year",
               values_to = "Number_People")


# * 2.3 Filter data for D1 athletes only ---------------------------------

## Filter data frame to only include Division 1, 
## and only Athletes (rather than coaches, assistant coaches)

ncaa_div_pivot$`Title/Position` %>% unique()

ncaa_div_filt <- ncaa_div_pivot %>% 
  filter(Division == "Division I",
         `Title/Position` == "Student-Athlete")



# * 2.4 Calculate percentages  --------------------------------------------

asdf <- ncaa_div_filt %>% 
  filter(Gender == "Male",
         Year == "2019") %>% 
  group_by(Division, Sport, Gender, `Race/Ethnicity`, Year) %>% 
  summarise(Total_Athletes = sum(Number_People, na.rm = TRUE))


asdf$Sport %>% unique()
