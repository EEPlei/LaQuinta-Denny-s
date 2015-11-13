library(rvest)
library(magrittr)
files <- dir("data/dennys/",pattern = "*.xml",full.names = TRUE)


extract_data <- function(file)
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
  
  df
}

l = lapply(files, extract_data)
mydf <- do.call(rbind,l) %>%
        unique() %>%
        .[.$Country == "US",]
dennys_df <- mydf
save(dennys_df, file = "data/dennys.Rdata")



