library(httr)

# montando a requisição GET
dia <- Sys.Date()
u_base <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
u_dia <- paste0(u_base, dia)

# Fazendo a requisição GET
r_dia <- GET(u_dia)

# Buscando o conteúdo
l_dia <- content(r_dia, simplifyDataFrame = TRUE)

# É uma lista aninhada!
l_dia$ReturnObj$sistemas 


d_dia <- l_dia |> 
  # acessar o item da lista que contém os dados
  purrr::pluck("ReturnObj", "sistemas") |> 
  # transformar em tibble
  tibble::tibble() |> 
  # limpar nomes
  janitor::clean_names()

# Podemos criar uma função para baixar os dados de um dia específico
sabesp_baixar_dia <- function(dia) {
  u_base <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
  u_dia <- paste0(u_base, dia)
  r_dia <- GET(u_dia)
  l_dia <- content(r_dia, simplifyDataFrame = TRUE)
  d_dia <- l_dia |> 
    purrr::pluck("ReturnObj", "sistemas") |> 
    tibble::tibble() |> 
    janitor::clean_names()
  d_dia
}

# Experimentando a função
sabesp_baixar_dia("2024-10-20")
