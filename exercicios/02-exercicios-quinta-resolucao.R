# Conceitos para praticar:
# Raspar informações de um site
library(httr)
library(rvest)

# https://pt.wikipedia.org/wiki/Paulo_Freire

# wikitable sortable jquery-tablesorter

url_wiki <- "https://pt.wikipedia.org/wiki/Paulo_Freire"

r_wiki <- GET(url_wiki)

html_wiki <- read_html(r_wiki)

tabela_catedras <- html_wiki |>
  html_elements(xpath = "//table[@class='wikitable']") |>
  html_table(header = TRUE)

tabela_honoris_causa <- html_wiki |>
  html_element(xpath = "//table[@class='wikitable sortable']") |>
  html_table(header = TRUE)

# Exercício 2 --------
# Carregando as bibliotecas necessárias
library(rvest)
library(dplyr)

# Definindo a URL da página da Wikipedia
url_oscar <- "https://pt.wikipedia.org/wiki/Oscar_de_melhor_filme"

# Lendo a página da Wikipedia
html_oscar <- read_html(url_oscar)

# Extraindo todas as tabelas da página
tabelas <- html_oscar |>  
  html_element(xpath = "//table[@class='wikitable']") |> 
  html_table(header = TRUE) |> 
  janitor::clean_names()
  
filmes_vencedores <- html_oscar |>  
  html_element(xpath = "//table[@class='wikitable']") |> 
  html_elements(xpath = "//td[@style='background:#FAEB86;']") |> 
  html_text(trim = TRUE) |> 
  unique()

tabelas_com_ganhadores <- tabelas |>
  dplyr::mutate(vencedor = titulo_original %in% filmes_vencedores)
