# Carregando pacotes
library(tidyverse)
library(httr)

# API olho vivo da SP trans ----
# https://www.sptrans.com.br/desenvolvedores/api-do-olho-vivo-guia-de-referencia/documentacao-api/

# URL base
u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"

# end point para buscar a posição
endpoint_posicao <- "/Posicao"

# componto a URL
url_posicao <- paste0(u_sptrans, endpoint_posicao)

# fazendo a requisicao
r_posicao <- GET(url_posicao)
r_posicao

# NÃO DEU CERTO, POIS PRECISAMOS AUTENTICAR!!!

# Tentando autenticar ----------------------------------------
# /Login/Autenticar?token={token}

# end point para autenticar
endpoint_login <- "/Login/Autenticar"
# componto a URL
url_login <- paste0(u_sptrans, endpoint_login)

# Pausa: importante cuidar das senhas/tokens ----
# Para obter o token, é necessário se cadastrar no site da SPTrans
# para usar o token:
# uma forma é adicionando no .Renviron
# no padrao
# API_OLHO_VIVO_CURSO = "....."
usethis::edit_r_environ(scope = "project")
# após adicionar a variável, salvar o arquivo, e reiniciar a sessão do R.
# Os arquivos .Renviron são carregados na inicialização do R

# Caso não queira salvar a senha no .Renviron, pode-se criar um objeto.
# Mas tome cuidado! 
# https://beamilz.com/posts/2022-09-13-nao-guarde-senhas-no-script/pt/index.html
# api_key <- "....."

# Buscando a senha no .Renviron e armazenando em uma variável
api_key <- Sys.getenv("API_OLHO_VIVO_CURSO")

# Criando uma lista com o token, usaremos na query
q_sptrans_login <- list(token = api_key)

# Aqui fazemos uma requisição POST
# e passamos a lista criada no argumento query
r_sptrans_login <- POST(url_login, query = q_sptrans_login)
r_sptrans_login

# Verificando o conteúdo da resposta
r_sptrans_login |> 
  content() 
# TRUE
# Significa que deu certo!

# Posição -------------------
# Agora que estamos autenticados, podemos buscar a posição dos veículos

# fazendo a requisição (criamos a URL anteriormente)
r_posicao <- GET(url_posicao)

# buscando o conteúdo retornado pela requisição
conteudo_posicao <- content(r_posicao, simplifyDataFrame = TRUE)

# O resultado é uma lista com 2 elementos: hr e l
conteudo_posicao$hr
# [1] "20:50"

# o elemento hr é o horário da consulta

# o elemento l é uma lista com as informações dos veículos
tabela_posicoes <- conteudo_posicao$l |> 
  as_tibble() |> 
    unnest(vs) 

# Exemplo de visualizacao da posição dos veículos
tabela_posicoes |> 
  ggplot() +
  geom_point(aes(x = px, y = py)) +
  coord_equal()



