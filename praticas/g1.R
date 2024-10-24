# 2) 
u_g1 <- "https://g1.globo.com/"
r_g1 <- GET(u_g1)
html_g1 <- read_html(r_g1)


posts <- html_elements(html_g1, xpath = "//div[@class='feed-root']") |> 
  html_elements(xpath = "//div[@class='_evt']") 

# titulo do post
titulos <- posts |> 
   html_elements("h2") |> 
  html_text()

# link do post
links <- posts |> 
    html_elements("h2") |> 
    html_elements("a") |> 
  html_attr("href")


