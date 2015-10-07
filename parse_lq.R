files = dir("data/lq/",pattern = "*.html",full.names = TRUE)


for(file in files)
{
  html = read_html(file)
  
  addr = html_nodes(html, ".hotelDetailsBasicInfoTitle p") %>% html_text()
  
  lat_long = html_nodes(html, ".minimap") %>% html_attr("src")
}