library(tidyverse)
library(httr)
library(rvest)
library(xml2)

# Acessar o site:
# https://esaj.tjsp.jus.br/cjsg/resultadoCompleta.do
# Abrir o network
# fazer uma busca, e ver o que aparece no network
# aparece uma requisição POST. lá podemos ver as configurações do pedido.


# usando httr

r_tjsp <- httr::POST(
  "https://esaj.tjsp.jus.br/cjsg/resultadoCompleta.do", 
  body = list(
    dados.buscaInteiroTeor = "test",  # O que escrevemos no campo da pesquisa livre
    dados.origensSelecionadas = "T"
  )
)

# Só retorna conteúdo da primeira página. 
# É necessário fazer um iterador para pegar as outras páginas.

# Status 200, Conteúdo text - HTML

r_tjsp_pag <- httr::GET(
  "https://esaj.tjsp.jus.br/cjsg/trocaDePagina.do", 
  query = list(
    tipoDeDecisao = "A", 
    pagina = 2, 
    conversationId = ""
  )
)

tab_html <- r_tjsp_pag |> 
  read_html(encoding = "UTF-8") |> 
  xml2::xml_find_all("//tr[@class='fundocinza1']//table")

tab_tibble <- tab_html[[1]] |> 
  html_table() |> 
  as_tibble() |> 
  mutate(X1 = str_squish(X1))

