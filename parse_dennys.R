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
  
  df$Address <- xml_nodes(x,"address1") %>% xml_text()
  df$City <- xml_nodes(x,"city") %>% xml_text()
  df$State <- xml_nodes(x,"state") %>% xml_text()
  df$Country <- xml_nodes(x,"country") %>% xml_text()
  df$PostalCode <- xml_nodes(x,"postalcode") %>% xml_text()
  df$Latitude <- xml_nodes(x,"latitude") %>% xml_text()
  df$Longitude <- xml_nodes(x,"longitude") %>% xml_text()
  df$Phone <- xml_nodes(x,"phone") %>% xml_text()
  df$Fax <- xml_nodes(x,"fax") %>% xml_text()
  
  mydf <- rbind(mydf, df)
}

mydf <- unique(mydf)
dennys_df <- mydf[mydf$Country == "US",]
save(dennys_df, file = "/home/grad/lsq3/Team4_hw2/data/dennys.Rdata")



