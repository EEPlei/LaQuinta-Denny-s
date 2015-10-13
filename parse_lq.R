files = dir("data/lq/",pattern = "*.html",full.names = TRUE)

extract_data = function(files){
  
  lq_data = data.frame(Address = NA, City = NA, 
                       State = NA, Zipcode = NA, 
                       Phone = NA, Fax = NA, 
                       Latitude = NA, Longitude = NA, stringsAsFactors = FALSE)
 
   for(file in files)
  {
   
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
    lat_long = html_nodes(html, ".minimap") %>% html_attr("src")
    
    newrow = c(str_split(addr_parse1,", ")[[1]][1],
               str_split(addr_parse1,", ")[[1]][2],
               addr_parse2[[1]][1],
               addr_parse2[[1]][2],
               numbers[[1]][1],
               numbers[[1]][2],
               str_extract_all(lat_long,"[0-9-.]{4,}")[[1]][1],
               str_extract_all(lat_long,"[0-9-.]{4,}")[[1]][2]
               )
    
    lq_data = rbind(lq_data, setNames(as.list(newrow), names(lq_data)))
    lq_final = lq_data[-1,]
  } 
  return(lq_final)
}





