# Carregando pacotes
library(httr)
library(rvest)
library(tidyverse)

# URL do site
url_scielo <- "https://www.scielo.br/journals/alpha?status=current"

# Fazendo a requisição
r_scielo <- GET(url_scielo)

# Pegando o conteúdo
c_scielo <- content(r_scielo)

# daria para limpar os conteúdos,
# porém a função HTML table retorna só o texto.
exemplo_tabela <- html_table(c_scielo)

# Vamos buscar as linhas da tabela
tr_elements <- c_scielo |> 
  html_element("body") |> 
  html_elements("section") |> 
  html_elements("tr") 

# textos dos td

lista_td_textos <- tr_elements |> 
  map(html_elements, "td") |> 
  map(html_elements, "a") |> 
  compact() 
  
# titulo do periodico
titulos_periodicos <- lista_td_textos |> 
  map(html_nodes, ".journalTitle") |> 
  map(html_text) |> 
  as.character()

# volumes

volumes_periodicos <- lista_td_textos |> 
  map(html_nodes, ".journalIssues") |> 
  map(html_text) |> 
  as.character()

# último volume

# last-issue-legend
ultimo_volume <- lista_td_textos |> 
  map(html_nodes, ".last-issue-legend") |> 
  map(html_text) |> 
  as.character()



# Informações que estão nos botões
# actions

col_nomes <- tibble(
  nome_colunas = c("homepage", "submissao", "corpo_editorial",
                  "instrucoes", "sobre", "contato")
)

# Buscando os links
lista_links <- tr_elements |> 
  map(html_nodes, ".actions") |> 
  map(html_elements, "a") |> 
  map(html_attr, "href") |> 
  compact() |> 
  map(as_tibble) |> 
  map(bind_cols, col_nomes) 

# exemplo de uso do pivot wider
lista_links[[1]] |> 
  pivot_wider(names_from = nome_colunas, values_from = value) |> View()

# fazendo o pivot wider e empilhando as tabelas
tibble_links <- lista_links |> 
  map(pivot_wider, names_from = nome_colunas, values_from = value) |> 
  list_rbind()


# unindo as informações
tabela_periodicos <- tibble_links |> 
  mutate(
    titulos_periodicos,
    volumes_periodicos,
    ultimo_volume,
    .before = everything()
  )

tabela_periodicos
