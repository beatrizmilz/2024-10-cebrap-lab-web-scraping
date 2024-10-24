library(tidyverse)
library(httr)
# library(xml2) # se o rvest for carregado, não precisa do xml2
library(rvest)

u_cdg <- "https://www.chancedegol.com.br/br23.htm"
r_cdg <- GET(u_cdg)

# content(r_cdg, encoding = "latin1")
html_cdg <- r_cdg |> 
  read_html()

tabela_resultados <- html_cdg |> 
  html_element(xpath = "//table") |> 
  html_table(header = TRUE) |> 
  janitor::clean_names()

# "/html/body/div/font/font/table/tbody/tr[4]/td[5]/font"

cores <- html_cdg |> 
  html_elements(xpath = "//font[@color='#FF0000']") |> 
  html_text()

tabela_resultados_tidy <- tabela_resultados |> 
  mutate(prob_resultado = cores) |> 
  mutate(across(
    c(vitoria_do_mandante, empate, vitoria_do_visitante, prob_resultado),
    parse_number
  )) |> 
  mutate(
    # a função pmax retorna o maior valor entre os três considerando A LINHA
    prob_modelo = pmax(vitoria_do_mandante, empate, vitoria_do_visitante),
    acertou = prob_modelo == prob_resultado
  )

View(tabela_resultados_tidy)

# média de acerto
mean(tabela_resultados_tidy$acertou)


