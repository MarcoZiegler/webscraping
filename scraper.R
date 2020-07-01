#########################
# webscraper            #
# MCZ                   #
# Marco_Ziegler@gmx.de  #
# 30.06.2020#           #
#########################

# libraries

  library(rvest)
  library(dplyr)
  library(tidyverse)

# chose a url an read its content
# this is our startpage: 
# "https://www.thomann.de/de/lp-modelle.html?pg=1&ls=25"
# first we prep the url a bit to iterate through all the guitars 

url <- "https://www.thomann.de/de/lp-modelle.html?"

# results per page 
rpp <- 25

# check how many entries we get from our start-page
parsed_page <- xml2::read_html(url)
results_count <-  as.numeric(html_text(html_nodes(parsed_page,".result-count")))

# setup pages to browsr through
list_of_pages <- str_c(url, "pg=", 1:rpp, "&ls=25")

manufac_list = array()
model_list = array()
guitar_list = data.frame()

for (page in list_of_pages) {
      
      #take the information u need
      print(c("scraping page:",page))
      
      #scraping the manufacturers
      manufacturers <-html_text(html_nodes(xml2::read_html(page),".manufacturer"))
      manufacturers <-manufacturers[3:(rpp+2)]
      manufac_list <- c(manufac_list,manufacturers)
      
      #scraping the models
      models <- html_text(html_nodes(xml2::read_html(page),".model"))
      model_list <- c(model_list,models)
      
      tmp <- as.data.frame(list(na.omit(manufacturers),na.omit(models)))
      colnames(tmp) <-c("Manufacturer","Model")
      guitar_list <-rbind(guitar_list,tmp)
      
}


#manufac_list <- unique(na.omit(manufac_list))

#clean data















