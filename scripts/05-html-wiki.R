library(httr)
library(purrr)
library(rvest)

u_wiki <- "https://en.wikipedia.org/wiki/R_language"

r_wiki <- GET(u_wiki)

## outra alternativa
# read_html(u_wiki)
 tabelas <- r_wiki |> 
  read_html() |> 
   html_table()
 
 # tabela versão do R
  tabelas_versao_r <- r_wiki |> 
  read_html() |> 
    # classe wikitable
  html_elements(xpath = "//table[@class='wikitable']") |>
   html_table()

# Exemplo do julio
links <- r_wiki |> 
  read_html() |> 
  html_elements(xpath = "//table[@class='infobox vevent']//a")

## alternativa xpath
# r_wiki |> 
#   read_html() |> 
#   html_elements(xpath = "//table[contains(@class, 'infobox')]//a")

urls <- paste0("https://en.wikipedia.org", html_attr(links, "href"))

baixar_pagina <- function(u, indice, path) {
  f <- file.path(path, paste0(indice, ".html"))
  # o if é opcional
  if (!file.exists(f)) {
    GET(u, write_disk(f))
  }
}

## obs: imap pega o índice e coloca como segundo argumento
# imap(letters, \(letra, indice) print(paste(indice, letra)))

path <- "dados/wiki/"
imap(urls, \(x, y) baixar_pagina(x, y, path))

safe_baixar_pagina <- possibly(baixar_pagina)

imap(urls, \(x, y) safe_baixar_pagina(x, y, path), .progress = TRUE)
