# Exemplo de raspagem de uma tabela
# Site: Chance de gol
# https://www.chancedegol.com.br/

# Carregando pacotes
library(httr)
library(rvest)
library(xml2)
library(tidyverse)

# URL
u_cdg <- "https://www.chancedegol.com.br/br23.htm"
# Requisição GET
r_cdg <- GET(u_cdg)

# Lendo o conteúdo HTML da requisição
html_cdg <- read_html(r_cdg)


tabela_resultados <- html_cdg |> 
  # encontrando os elementos que sejam tabelas (tag table)
  html_element(xpath = "//table") |> 
  # a função html_table() extrai a tabela do HTML em uma tibble
  # o argumento header = TRUE indica que a primeira linha é o cabeçalho
  html_table(header = TRUE) |> 
  # limpando os nomes das colunas
  janitor::clean_names()


tabela_resultados



# A tabela tem informações nas cores: quem ganhou o jogo!
# Vamos extrair essas informações

# /html/body/div/font/font/table/tbody/tr[15]/td[6]/font


cor_em_vermelho <- html_cdg |> 
  # encontrando os elementos que sejam da tag font
  # e que tenham a cor vermelha (#FF0000)
  html_elements(xpath = "//font[@color='#FF0000']") |> 
  # extraindo o texto
  html_text()

# a cor vermelha indica quem ganhou o jogo

tabela_tidy <- tabela_resultados |> 
  # adicionando uma coluna com as informações em vermelho
  # representa o resultado do jogo.
  mutate(prob_resultado = cor_em_vermelho) |> 
  # transformando as colunas que deveriam ser números em numeric
  # com a função parse_number e a função across
  # a função across serve para aplicar uma função (no caso parse_number)
  # em várias colunas (as que estão listadas no argumento .cols)
  mutate(
    across(
      .cols = c(vitoria_do_mandante, empate, vitoria_do_visitante,
                prob_resultado),
      .fns = parse_number
    )
  ) |> 
  # 
  mutate(
    # buscando o maior valor dentre as colunas de probabilidade calculada pelo site
    prob_modelo_site = pmax(vitoria_do_mandante, empate, vitoria_do_visitante),
    # comparando a estimativa do site com o resultado real,
    # e criando uma coluna com a informação se o site acertou ou não
    site_acertou = prob_modelo_site == prob_resultado
  ) 

# taxa de acertos do site
mean(tabela_tidy$site_acertou) * 100
