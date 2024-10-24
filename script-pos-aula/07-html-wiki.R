# Vamos extrair informações de uma página da Wikipedia
# Carregando pacotes
library(httr)
library(rvest)

# URL
u_wiki <- "https://en.wikipedia.org/wiki/R_(programming_language)"

# Fazendo a requisição
r_wiki <- GET(u_wiki)

# Lendo o conteúdo HTML
html_wiki <- read_html(r_wiki)

# A função html_table retorna todas as tabelas de um HTML
html_wiki |> 
  html_table()

# queremos apenas a tabela das versões do R!
# Explorando no site, vemos que a tabela que queremos tem a classe wikitable

tabela_versoes <- html_wiki |> 
  # buscando o elemento que tem a tag table e a classe wikitable 
  html_element(xpath = "//table[@class='wikitable']") |> 
  # extraindo a tabela
  html_table() |> 
  # limpando nome das colunas
  janitor::clean_names() |> 
  # selecionando colunas relevantes
  dplyr::select(version, release_date, name)

# Dúvida: e se tiver mais que um elemento com a mesma classe?
html_wiki |> 
  # buscando uma classe de exemplo que aparece mais de uma vez
  html_elements(xpath = "//table[@class='nowraplinks mw-collapsible autocollapse navbox-inner']") |> 
  # a função purrr::pluck pega o elemento de uma lista
  purrr::pluck(2)


# Buscando a lista de links que fica na caixinha no começo da página
lista_links_sujo <- html_wiki |> 
  # buscando os elementos que são links (tag a)
  # que estão dentro de uma tabela com a classe infobox vevent
  html_elements(xpath = "//table[@class='infobox vevent']//a") |> 
  html_attr("href")

#  [9] "/wiki/Imperative_programming"                                      
# [10] "/wiki/Array_programming"                                           
# [11] "#cite_note-Morandat-1"

# Não mostrei na aula: limpando os links
links_limpos <- lista_links_sujo |> 
  # transformando em tibble para facilitar a manipulação
  tibble::as_tibble() |>
  # removendo os valores que começam com #
  dplyr::filter(!stringr::str_starts(value, "#")) |>
  # criando o link completo
  dplyr::mutate(
    link = dplyr::case_when(
      # se o link começar com /, adicionamos o domínio do Wikipedia
      stringr::str_starts(value, "/") ~ paste0("https://en.wikipedia.org", value),
      # se não, mantemos o link que ja existia
      TRUE ~ value
    )
  ) |> 
  # extraindo a coluna link como um vetor
  dplyr::pull(link)
