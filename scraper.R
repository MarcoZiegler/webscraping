#########################
# webscraper            #
# MCZ                   #
# Marco_Ziegler@gmx.de  #
# 30.06.2020#           #
#########################

# scenario:
# "I wonder which manufacturer sells the most expensive guitars?"
# lets scrape the guitars from thomann.de 
# I like Paulas (a e-guitar model) - I so we will ckeck them out

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
# we could also just scrape all results at once without iterating through pages in this case
# this is deliberatly held complex to easily adapt the script to other websites
  rpp <- 25

# check how many entries we get from our start-page
  parsed_page <- xml2::read_html(url)
  results_count <-  as.numeric(html_text(html_nodes(parsed_page,".result-count")))

#define how many pages we have to search
  surf <- ceiling(results_count / rpp)

# setup pages to iterate through
  list_of_pages <- str_c(url, "pg=", 1:surf, "&ls=25")

#a dataframe to bind them all! 
  masterframe <- data.frame()

# iterate through the pages and get the information we want
    for (page in list_of_pages) {
      
      #you are here:
      print(c("scraping page:",page))
  
      #scraping the manufacturers - check out the css tag on the page (right click: inspect element)
      manufacturers <-html_text(html_nodes(xml2::read_html(page),"#defaultResultPage .manufacturer"))
      print(length(manufacturers))
     
      #scraping the models
      models <- html_text(html_nodes(xml2::read_html(page),".model"))
      #print(models)
      print(length(models))
      
      #scraping prices
      price <- html_text(html_nodes(xml2::read_html(page),".article-basketlink"))
      print(length(price))
      
      masterframe <-rbind(masterframe,data.frame(cbind(manufacturers,models,price)))
                 
    }

# replace annoying characters
  masterframe$price <- as.numeric(gsub("[€.]","",masterframe$price))

# find the average price for a guitar by manufacturer
  table <-aggregate(masterframe$price ,by = list(masterframe$manufacturers),mean)
  names(table) <- c("manufacturer","average.price")
  table <-arrange(table, average.price)

# make a little visualisation
  plot <- ggplot(data = table, aes(x = manufacturer, y = average.price)) +
    geom_bar(stat = "identity") +
    ylab("average price (€)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90))
    
    
