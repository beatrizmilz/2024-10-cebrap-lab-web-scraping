library(tidyverse)
library(httr)

# API olho vivo da SP trans
# https://www.sptrans.com.br/desenvolvedores/api-do-olho-vivo-guia-de-referencia/
u_sptrans <- "https://api.olhovivo.sptrans.com.br/v2.1"
endpoint <- "/Posicao"

# Criando a URL completa
u_sptrans_posicao <- paste0(u_sptrans, endpoint)

# fazendo a requisição GET
r_posicao <- GET(u_sptrans_posicao)
# Verificando o conteúdo da resposta
r_posicao |> 
  content()


# Precisamos de uma chave de autenticação para acessar a API ------------
# usethis::edit_r_environ(scope = "project")
api_key <- Sys.getenv("API_OLHO_VIVO")
# api_key <- "cole_a_chave_aqui"

# Criando a URL completa
endpoint_login <- "/Login/Autenticar"
u_sptrans_login <- paste0(u_sptrans, endpoint_login)

# A query será uma lista
q_sptrans_login <- list(token = api_key)

# Fazendo a requisição POST
# e passando a lista criada para o argumento query
r_sptrans_login <- POST(u_sptrans_login, query = q_sptrans_login)

# acessando o conteúdo da resposta
r_sptrans_login |> 
  content()


# isso só funciona porque o httr guarda informações da sessão nos cookies
r_posicao <- GET(u_sptrans_posicao)

d_posicoes <- r_posicao |> 
  content(simplifyDataFrame = TRUE) |> 
  pluck("l") |> 
  as_tibble()

d_posicoes$vs[[1]]

d_posicoes |> 
  unnest(vs) |> 
  ggplot(aes(x = px, y = py)) +
  geom_point() +
  coord_equal()
