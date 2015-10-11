key = "6B962D40-03BA-11E5-BC31-9A51842CA48B"

get_dennys_locs = function(dest, key, lat, long, radius, limit)
{
  url = paste0(
    "https://hosted.where2getit.com/dennys/responsive/ajax?&xml_request=",
    "<request>",
    "<appkey>",key ,"</appkey><formdata id=\"locatorsearch\">",
    "<dataview>store_default</dataview>",
    "<limit>",limit,"</limit>",
    "<order>rank,_distance</order>",
    "<geolocs><geoloc><addressline></addressline>",
    "<longitude>",long,"</longitude>",
    "<latitude>",lat,"</latitude>",
    "<country>US</country></geoloc></geolocs><stateonly>1</stateonly>",
    "<searchradius>",radius,"</searchradius></formdata></request>")
  
  download.file(url,destfile=dest,method = "wget")
}

locs = read.csv("dennys_coords.csv",header = FALSE)

dir.create("data/dennys/",recursive = TRUE,showWarnings = FALSE)
limit = 1000

for(i in 1:nrow(locs))
{
  long = locs[i,1]
  lat = locs[i,2]
  radius = locs[i,3]
  dest = paste0("data/dennys/",i,".xml")
  
  get_dennys_locs(dest, key, lat, long, radius, limit)
}

