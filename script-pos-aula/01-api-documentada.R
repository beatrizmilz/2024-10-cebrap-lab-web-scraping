# Carregar os pacotes
library(httr)
library(tidyverse)


# Exemplo BRASIL API

# CEP -------------
# https://brasilapi.com.br/api/cep/v2/{cep}

# URL BASE
u_base <- "https://brasilapi.com.br/api"

# END POINT
endpoint_cep <- "/cep/v2/"
 
# Parâmetro da busca
cep <- "04015051"

# componto a URL
u_cep <- paste0(u_base, endpoint_cep, cep)

# fazendo uma requisição GET na URL criada
r_cep <- GET(u_cep)

# explorando o que a requisição retornou
r_cep

# buscando o conteúdo retornado pela requisição
conteudo_cep <- content(r_cep)

# Verificando a classe: é uma lista!
class(conteudo_cep)
# Conseguimos acessar os elementos da lista com $
conteudo_cep$cep

# content(r_cep, simplifyDataFrame = TRUE) - não deu certo!

# Transformando a lista em um tibble
conteudo_cep |> 
  tibble::as_tibble() |> 
  dplyr::select(-location) |> 
  dplyr::distinct()

# Exemplo de iteração para o futuro! (feito em: scripts/04-iteracao.R)

# Exemplo 2 - tabela FIPE ======
# end point: /fipe/tabelas/v1
endpoint_fipe_tabela <- "/fipe/tabelas/v1"

# componto a URL
u_fipe_tabela <- paste0(u_base, endpoint_fipe_tabela)

# fazendo uma requisição GET na URL criada
r_fipe_tabela <- GET(u_fipe_tabela)
r_fipe_tabela

# buscando o conteúdo retornado pela requisição,
# e transformando em um tibble
tab_referencia_fipe <- content(r_fipe_tabela, simplifyDataFrame = TRUE) |> 
  tibble::as_tibble()

# Parte 2 - Buscar preço de carros
# https://brasilapi.com.br/api/fipe/preco/v1/{codigoFipe}

# end point: /fipe/preco/v1/{codigoFipe}
endpoint_fipe_preco <- "/fipe/preco/v1/"

# código do veículo (isso não está na API, busquei exemplos na internet)
cod_veiculo <- "025265-4"

# componto a URL
url_preco <- paste0(u_base, endpoint_fipe_preco, cod_veiculo)

# fazendo uma requisição GET na URL criada
r_preco <- GET(url_preco)
r_preco

# buscando o conteúdo retornado pela requisição, e transformando em um tibble
tab_preco_atual <- content(r_preco, simplifyDataFrame = TRUE) |> 
  tibble::as_tibble()


# buscar informações anteriores

# precisamos criar uma lista nomeada para passar para o argumento query
# o valor foi obtido no exemplo anterior (tab_referencia_fipe)
query_fipe <- list(
  "tabela_referencia" = "249"
)

# fazendo uma requisição GET na URL criada, 
# passando o argumento query
r_preco_antigo <- GET(url_preco, query = query_fipe)

# buscando o conteúdo retornado pela requisição, e transformando em um tibble
tab_preco_antigo <- content(r_preco_antigo, simplifyDataFrame = TRUE) |> 
  tibble::as_tibble()
