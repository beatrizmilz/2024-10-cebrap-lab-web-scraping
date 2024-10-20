# Carregando pacotes
library(httr)
library(jsonlite)

# Exemplo 1 - Brasil API
# Para começar, vamos conhecer o projeto Brasil API, 
# que disponibiliza uma série de dados sobre o Brasil,
# como estados, cidades, CEPs, entre outros.
# https://brasilapi.com.br/

# Definindo a URL base usada pela API
u_base <- "https://brasilapi.com.br/api"


## Vamos buscar informações sobre CEPs ----
# https://brasilapi.com.br/api/cep/v2/{cep}

endpoint_cep <- "/cep/v2/"

# Vamos fazer a requisição para o CEP 04015-051
cep <- "04015051"

# Montando a URL completa
u_cep <- paste0(u_base, endpoint_cep, cep)
u_cep

# Fazendo a requisição GET
r_cep <- GET(u_cep)

# Verificando o status da requisição
r_cep 
# Status: 200 quer dizer que a requisição foi bem sucedida
# Content-Type: application/json -> o conteúdo da resposta é um JSON

# Conhecendo um JSON: Abrindo o JSON no navegador
browseURL(u_cep)


# Verificando o conteúdo da resposta
conteudo_cep <- content(r_cep) # Retornando uma lista

# O resultado é uma lista com as informações do CEP.
conteudo_cep

# Acessando os elementos da lista
conteudo_cep$cep
conteudo_cep$state
conteudo_cep$city
conteudo_cep$neighborhood
conteudo_cep$street
conteudo_cep$service

# Exercício 1: Consulte o seu CEP e acesse as informações retornadas pela API.
# As informações retornadas são as mesmas que você esperava?




## Exemplo 2 - Explorando a Tabela FIPE  ------

### 2.1 - Consultando as marcas de carro disponíveis na tabela FIPE ----
# https://brasilapi.com.br/api/fipe/marcas/v1/{tipoVeiculo}

endpoint_fipe <- "/fipe/marcas/v1/"
tipo_veiculo <- "carros"
u_fipe <- paste0(u_base, endpoint_fipe, tipo_veiculo)

r_fipe <- GET(u_fipe)

content(r_fipe)

# O conteúdo da resposta é um JSON, que pode ser convertido para um data frame
tabela_marcas_fipe <- content(r_fipe, simplifyDataFrame = TRUE) |> 
  tibble::as_tibble()

# Criando a pasta para armazenar os dados
fs::dir_create("dados/brasilapi")

# Buscando os dados e salvando em um arquivo
r_fipe <- GET(
  u_fipe, 
  write_disk("dados/brasilapi/fipe_marcas.json", overwrite = TRUE)
)

r_fipe


### 2.2 - Consultando quais são as tabelas de referência existentes ----

# Endpoint da API das tabelas FIPE
endpoint_fipe_tabelas <- "/fipe/tabelas/v1/"

# Montando a URL completa
u_fipe_tabelas <- paste0(u_base, endpoint_fipe_tabelas)

# Fazendo uma requisição GET
r_fipe_tabelas <- GET(u_fipe_tabelas)

# Verificando o status da requisição
r_fipe_tabelas


mes_referencia_tabela_fipe <- r_fipe_tabelas |> 
  # Convertendo o conteúdo da resposta para um data frame
  content(simplifyDataFrame = TRUE) |> 
  # Convertendo o data frame para um tibble
  tibble::as_tibble()

# O resultado é um tibble com os períodos de referência disponíveis,
# e o código de cada um deles.
mes_referencia_tabela_fipe |> 
  print(n = 100)


### 2.3 - Consultando o preço de um veículo segundo a tabela FIPE ----

# Parte 1 - Consultando o preço atual
# Vamos consultar o preço de um veículo específico

# Endpoint da API da Tabela FIPE para preços
endpoint_preco <- "/fipe/preco/v1/"

# Código do veículo
cod_veiculo <- "025265-4"

# Montando a URL completa
u_preco <- paste0(u_base, endpoint_preco, cod_veiculo)

# Fazendo a requisição GET
r_preco <- GET(u_preco)

# Buscando o conteúdo da resposta e convertendo para um data frame
tab_preco_atual <- content(r_preco, simplifyDataFrame = TRUE) |> 
  tibble::as_tibble()

tab_preco_atual

# Parte 2: Consultando o preço de um veículo em um outro mês de referência

# Precisamos criar uma lista com o código da tabela de referência
query_fipe <- list(
  "tabela_referencia" = "249" # dezembro/2019 
)

# Fazendo a requisição GET
r_preco_antigo <- GET(u_preco, query = query_fipe)

# Buscando o conteúdo da resposta e convertendo para um data frame
tab_preco_antigo <- content(r_preco_antigo, simplifyDataFrame = TRUE) |> 
  tibble::as_tibble()

tab_preco_antigo
