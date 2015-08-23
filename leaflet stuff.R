devtools::install_github("rstudio/leaflet")
library(leaflet)
library(stringi)
library(htmltools)
library(RColorBrewer)
m <- leaflet() %>%
  addTiles() %>%
  addMarkers(lng=174.768, lat=-36.852, popup='The birthplace of R')


%>% is the magrittr pip operator, pipes into previous
#read up the data
danny <- readLines("http://weather.unisys.com/hurricane/atlantic/2015/DANNY/track.dat")
#clean up the lines 
danny_dat <- read.table(textConnection(gsub("TROPICAL ", "TROPICAL_", danny[3:length(danny)])), header=TRUE, stringsAsFactors=FALSE)
#Title Case, and remove the _
danny_dat$STAT <- stri_trans_totitle(gsub("_", " ", danny_dat$STAT))
#make columns nicer
colnames(danny_dat) <- c("advisory", "lat", "long", "time", "wind_speed", "pressure", "status")
danny_dat$color <- as.character(factor(danny_dat$status, 
                                              level=c("Tropical Depression", "Tropical Storm", 
                                                      "Hurricane-1", "Hurricane-2", "Hurricane-3", 
                                                      "Hurricane-4", "Hurricane-5"), 
                                              labels=rev(brewer.pal(7, "Dark2"))))

leaflet() %>%
  addTiles() %>%
  addPolylines(data=danny_dat[1:25,],~lon, ~lat, color=~color) %>%
  addCircles(data=danny_dat[26:31,], ~lon, ~lat, color=~color, fill=~color, radius=25000,
             popup=~sprintf("<b>Advisory forecast for %sh (%s)</b><hr noshade size = '1'/>
                            Position: %3.2f, %3.2f<br/>
                            Expected strength: <span style='color':%s><strong>%s</strong></span><br/>
                            Forecast wind: %s (knots)<br/>Forecast pressure: %s",
                            htmlEscape(advisory),htmlEscape(time), htmlEscape(lon),
                            htmlEscape(lat), htmlEscape(color), htmlEscape(status), htmlEscape(wind_speed),
                            htmlEscape(pressure)))%>% html_print

