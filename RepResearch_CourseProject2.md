---
title: "Reproducible Research Course Project 2"
author: "George Alexandre Silva"
date: "28 de julho de 2018"
output: 
  html_document:
    df_print: default
    keep_md: yes
editor_options: 
  chunk_output_type: console
---



# Title: An explotarory analysis from the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database. 

## Synopsis

Storms and other severe weather events can cause both public health and economic problems for communities and municipalities. Many severe events can result in fatalities, injuries, and property damage, and preventing such outcomes to the extent possible is a key concern. As a requirement to complete the Reproducible Research Course, we must explore the NOAA storm database to determine which types of events are most harmful with respect to population health and which ones have the greatest economic consequences.

## Getting, loading and preprocessing the data

```r
# Check if the data are available or the run_all flag exists.
# If not, prepare the tidy data
# Note: in order to these cache strategy works, you must run from console: rmarkdown::render("RepResearch_CourseProject2.Rmd")
# To refresh the data from it's source, create a object called run_all ( run_all <- TRUE ).open
if ( !exists("storm_db") || exists("run_all") ) {
        destfile <- "./noaa_storm_db.bz2" 
        # Check if the raw data file are there, otherwise download from te source
        if (!file.exists(destfile) || exists("run_all")) {
                fileURL  <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"   
                download.file(fileURL, destfile, method="auto") 
                rm("fileURL")
        }
        # Create a dataset with raw data
        storm_db <- read.csv2(destfile , sep = ",", header = TRUE, na.strings = "NA", dec = ".")
        rm("destfile")
        rm("run_all")
}

# Prepare the analysis dataset
storm_db <- as.data.frame(storm_db)

# Creating vectors summarizing events with more fatalities and injuries
healt_impact_injuries = storm_db %>% 
  select(EVTYPE, INJURIES) %>% 
  group_by(EVTYPE) %>% 
  summarize(events=n(), injuries=sum(INJURIES)) %>% 
  arrange(-injuries)

healt_impact_fatalities = storm_db %>% 
  select(EVTYPE, FATALITIES) %>% 
  group_by(EVTYPE) %>% 
  summarize(events=n(), fatalities=sum(FATALITIES)) %>% 
  arrange(-fatalities)
```
