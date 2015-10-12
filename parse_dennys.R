library(rvest)
files <- dir("data/dennys/",pattern = "*.xml",full.names = TRUE)

mydf <- NULL

for(file in files)
{
  xml <- read_xml(file)
  collection <- xml_nodes(xml, "collection")
  x <- collection[[1]]
  df <- data.frame(
    uid = xml_nodes(x,"uid") %>% xml_text()
  )
  
  df$Country <- xml_nodes(x,"country") %>% xml_text()
  df$State <- xml_nodes(x,"state") %>% xml_text()
  df$Address <- xml_nodes(x,"address1") %>% xml_text()
  df$Latitude <- xml_nodes(x,"latitude") %>% xml_text()
  df$Longitude <- xml_nodes(x,"longitude") %>% xml_text()
  
  mydf <- rbind(mydf, df)
}

mydf <- unique(mydf)
mydf <- mydf[mydf$Country == "US",]




