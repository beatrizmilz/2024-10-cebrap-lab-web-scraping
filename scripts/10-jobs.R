library(httr)
library(rvest)
library(purrr)
library(dplyr)

u_rp <- "https://realpython.github.io/fake-jobs/"
r_rp <- GET(u_rp)

## usando stringr
# r_rp |> 
#   read_html() |> 
#   html_elements(xpath = "//footer[@class='card-footer']/a") |> 
#   html_attr("href") |> 
#   stringr::str_subset("github")

## usando xpath
links <- r_rp |> 
  read_html() |> 
  html_elements(xpath = "//footer[@class='card-footer']/a[contains(@href,'github')]") |> 
  html_attr("href")

h_rp <- r_rp |> 
  read_html()

cards <- h_rp |> 
  html_elements(xpath = "//div[@class='card']")

card <- cards[42]

processar_card <- function(card) {
  xpaths <- c(".//h2", ".//h3", ".//p[@class='location']", ".//time")

  xpaths |> 
    map(\(x) html_elements(card, xpath = x)) |> 
    map_chr(html_text) |> 
    stringr::str_squish() |> 
    set_names(c("posicao", "empresa", "local", "dia")) |> 
    tibble::enframe()  
}

processar_card(cards[10])

da_cards <- map(cards, processar_card) |> 
  # poderia ser bind_rows()
  list_rbind(names_to = "id_card") |> 
  tidyr::pivot_wider(names_from = name, values_from = value) |> 
  mutate(link = links)

pegar_descricao <- function(link) {
  link |>
    read_html() |> 
    html_element(xpath = "//div[@class='content']/p") |> 
    html_text()
}

da_cards_desc <- da_cards |> 
  mutate(desc = map_chr(link, pegar_descricao, .progress = TRUE))


