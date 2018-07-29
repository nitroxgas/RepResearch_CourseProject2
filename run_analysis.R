rmarkdown::render("RepResearch_CourseProject2.Rmd")
#
#healt_impact_injuries = storm_db %>% 
##  select(EVTYPE, INJURIES) %>% 
#  group_by(EVTYPE) %>% 
#  summarize(events=n(), injuries=sum(INJURIES)) %>% 
#  arrange(-injuries)

#healt_impact_fatalities = storm_db %>% 
#  select(EVTYPE, FATALITIES) %>% 
#  group_by(EVTYPE) %>% 
#  summarize(events=n(), fatalities=sum(FATALITIES)) %>% 
#  arrange(-fatalities)

#fatal_plot <- ggplot() + 
#  geom_bar( data = healt_impact_fatalities[1:5,], aes( x = reorder(EVTYPE, -fatalities), y = fatalities, fill = interaction(fatalities, EVTYPE)), stat = "identity", show.legend=F) +
#  xlab("Harmful Events") + 
#  ylab("No. of fatailities") + 
#  ggtitle("Top 5 weather events causing fatalities")

#injuries_plot <- ggplot() + 
#  geom_bar( data = healt_impact_injuries[1:5,], aes( x = reorder(EVTYPE, -injuries), y = injuries, fill = interaction(injuries, EVTYPE)), stat = "identity", show.legend=F) +
#  xlab("Harmful Events") + 
#  ylab("No. of fatailities") + 
#  ggtitle("Top 5 weather events causing fatalities")

#grid.arrange(fatal_plot, injuries_plot, ncol = 2)