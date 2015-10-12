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
  

  df$Name <- xml_nodes(x, "name") %>% xml_text()
  df$Address1 <- xml_nodes(x,"address1") %>% xml_text()
  df$Address2 <- xml_nodes(x, "address2") %>% xml_text()
  df$City <- xml_nodes(x,"city") %>% xml_text()
  df$State <- xml_nodes(x,"state") %>% xml_text()
  df$Country <- xml_nodes(x,"country") %>% xml_text()
  df$PostalCode <- xml_nodes(x,"postalcode") %>% xml_text()
  df$PhoneNumber <- xml_nodes(x,"phone") %>% xml_text()
  df$FaxNumber <- xml_nodes(x,"fax") %>% xml_text()
  df$Latitude <- xml_nodes(x,"latitude") %>% xml_text()
  df$Longitude <- xml_nodes(x,"longitude") %>% xml_text()
  
  mydf <- rbind(mydf, df)
}

mydf <- unique(mydf)
mydf <- mydf[mydf$Country == "US",]

