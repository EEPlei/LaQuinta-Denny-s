files = dir("data/lq/",pattern = "*.html",full.names = TRUE)


for(file in files)
{
  html = read_html(file)
  
  info = html_nodes(html, ".hotelDetailsBasicInfoTitle p") %>%
         html_text() %>%
         str_trim() %>%
         str_replace_all("\n[ ]{2,}","")
  
  addr = strsplit(strsplit(strsplit(info, "Phone:")[[1]],"Fax:")[[1]],"Fax:")
  
  numbers = str_extract_all(info, "([0-9])[- .]([0-9]{3})[- .]([0-9]{3})[- .]([0-9]{4})")
  
  phone = numbers[[1]][1]
  
  fax= numbers[[1]][2]
  
  lat_long = html_nodes(html, ".minimap") %>% html_attr("src")
}