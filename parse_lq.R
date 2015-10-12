files = dir("data/lq/",pattern = "*.html",full.names = TRUE)

extract_data <- function(files){  
  mydf <- NULL
  for(file in files)
  {
    lq_data = data.frame(Address = NA, City = NA, 
                         State = NA, Zipcode = NA, 
                         Phone = NA, Fax = NA, 
                         Latitude = NA, Longitude = NA, stringsAsFactors = F)
    
    html = read_html(file)
    
    info = html_nodes(html, ".hotelDetailsBasicInfoTitle p") %>%
           html_text() %>%
           str_trim() %>%
           str_replace_all("\n[ ]{2,}","")
    
    addr = strsplit(strsplit(strsplit(info, "Phone:")[[1]],"Fax:")[[1]],"Fax:")
    addr_parse1 = as.character(unlist(addr))
    addr_parse2 = str_split(addr_parse1,", ")[[1]][3] %>%
                  str_split(.," ")
    numbers = str_extract_all(info, "([0-9])[- .]([0-9]{3})[- .]([0-9]{3})[- .]([0-9]{4})")
    
    lq_data$Address = str_split(addr_parse1,", ")[[1]][1]
    lq_data$City = str_split(addr_parse1,", ")[[1]][2]
    lq_data$State = addr_parse2[[1]][1]
    lq_data$Zipcode = addr_parse2[[1]][2]
    lq_data$Phone = numbers[[1]][1]
    lq_data$Fax = numbers[[1]][2]
    lat_long = html_nodes(html, ".minimap") %>% html_attr("src")
    lq_data$Latitude = str_extract_all(lat_long,"[0-9-.]{4,}")[[1]][1]
    lq_data$Longitude = str_extract_all(lat_long,"[0-9-.]{4,}")[[1]][2]
    
    lq_df <- rbind(mydf, lq_data)
  }
  return(lq_df)
}


