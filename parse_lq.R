files = dir("data/lq/",pattern = "*.html",full.names = TRUE)

extract_data = function(files){
  #first define an empty dataframe with column vectors from address to NumberofRooms
  lq_data = data.frame(Address = NA, City = NA, 
                       State = NA, Zipcode = NA, 
                       Phone = NA, Fax = NA, 
                       Latitude = NA, Longitude = NA, 
                       Internet = NA, WiFi= NA, SwimmingPool= NA, Parking = NA, Breakfast = NA,
                       Floors = NA, NumberofRooms = NA,
                       stringsAsFactors = FALSE)
  
  for(file in files)
  {
    
    html = read_html(file)
    
    #read in html file, convert as text, and remove white spaces
    info = html_nodes(html, ".hotelDetailsBasicInfoTitle p") %>%
      html_text() %>%
      str_trim() %>%
      str_replace_all("\n[ ]{2,}","") 
    
    #define address and longitude & latitude
    addr = strsplit(strsplit(strsplit(info, "Phone:")[[1]],"Fax:")[[1]],"Fax:")
    addr_parse1 = as.character(unlist(addr))
    addr_parse2 = str_split(addr_parse1,", ")[[1]][3] %>%
      str_split(.," ")
    numbers = str_extract_all(info, "([0-9])[- .]([0-9]{3})[- .]([0-9]{3})[- .]([0-9]{4})")
    lat_long = html_nodes(html, ".minimap") %>% html_attr("src")
    
    #define amenities with selectorgadget, convert as text and remove unnecessary text
    amenities_info = html_nodes(html, ".colctrl-50-50-c0") %>%
      html_text() %>%
      str_trim() %>%
      str_replace_all("\n[ ]{2,}","") %>%
      str_replace_all("\\n","") %>% 
      str_replace_all("\\t","") %>%
      str_replace_all("[ ]{2,}","")
    
    #define various elements through amenities_info such as availability of internet, Wifi, 
    #pools, parking, and complementary breakfast  
    Internet = str_extract(amenities_info, "Free High-Speed Internet Access")[1]
    WiFi = str_extract(amenities_info, "Free Wireless High-Speed Internet Access")[1]
    SwimmingPool = str_extract(amenities_info, "Outdoor Swimming Pool")[1] 
    Parking = str_extract(amenities_info, "Free Parking")[1]
    Breakfast = str_extract(amenities_info, "Free Bright Side Breakfast")[1]
    
    #same as amenities_info, define rooms_info to figure out the number of floors and rooms
    rooms_info = html_nodes(html, ".hotelDetailsFeaturesdetails .col-xs-12") %>%
      html_text() %>%
      str_trim() %>%
      str_replace_all("\n[ ]{2,}","") %>%
      str_replace_all("\\n","") %>%
      str_replace_all("\\r","") %>%
      str_replace_all("\\t","")
    
    Floors = str_extract(rooms_info, "Floors:..") %>% 
             str_split(., "Floors: ")
    
    NumberofRooms = str_extract(rooms_info, "Rooms: [0-9]{2,}") %>% 
                    str_split(., "Rooms: ")
   
   #plug in variables into the empty dataframe we defined
    newrow = c(str_split(addr_parse1,", ")[[1]][1],
               str_split(addr_parse1,", ")[[1]][2],
               addr_parse2[[1]][1],
               addr_parse2[[1]][2],
               numbers[[1]][1],
               numbers[[1]][2],
               str_extract_all(lat_long,"[0-9.-]{4,}")[[1]][1],
               str_extract_all(lat_long,"[0-9.-]{4,}")[[1]][2],
               Internet, 
               WiFi, 
               SwimmingPool, 
               Parking, 
               Breakfast,
               Floors[[1]][2],
               NumberofRooms[[1]][2]
               
    )
    
    #bind rows together, take out the first row of NAs
    lq_data = rbind(lq_data, setNames(as.list(newrow), names(lq_data)))
    lq_final = lq_data[-1,]
  } 
  return(lq_final)
}
