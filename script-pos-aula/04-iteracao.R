# Carrega as bibliotecas necessárias para manipulação de dados e requisições HTTP
library(tidyverse)
library(httr)

# Exemplo de uso da Brasil API para buscar informações de CEP (VISTO ANTERIORMENTE)---------
# URL base da API de CEP
u_base <- "https://brasilapi.com.br/api"

# Endpoint específico para buscar informações de CEP
endpoint_cep <- "/cep/v2/"

# Define o CEP a ser buscado
cep <- "04015051"

# Constrói a URL completa para fazer a requisição, concatenando a base e o CEP
u_cep <- paste0(u_base, endpoint_cep, cep)

# Faz uma requisição GET para a URL criada
r_cep <- GET(u_cep)

# Exibe a resposta da requisição
r_cep

# Extrai o conteúdo da resposta no formato adequado (tipicamente uma lista)
conteudo_cep <- content(r_cep)

# Verifica a classe do conteúdo retornado (geralmente uma lista ou JSON)
class(conteudo_cep)

# Acessa um elemento específico da resposta (o campo 'cep')
conteudo_cep$cep

# Tentativa de converter o conteúdo da resposta diretamente para um DataFrame
# content(r_cep, simplifyDataFrame = TRUE) - não deu certo!

# Converte o conteúdo da resposta em tibble (formato tabular), remove a coluna 'location' e mantém apenas valores distintos
conteudo_cep |> 
  tibble::as_tibble() |> 
  dplyr::select(-location) |> 
  dplyr::distinct()

# COMO FAZER ISSO PARA VÁRIOS CEPS? CRIAR UMA FUNÇÃO E USAR O MAP!--------------
# Função para buscar informações de um CEP na API

buscar_cep_api <- function(numero_cep){
  # Verifica se o CEP tem o comprimento correto (8 ou 9 caracteres)
  if(!str_length(numero_cep) %in% c(8, 9)){
    stop("O número do CEP deve conter 8 dígitos")
  }
  
  # URL base e endpoint
  u_base <- "https://brasilapi.com.br/api"
  endpoint_cep <- "/cep/v2/"
  
  # Constrói a URL completa
  u_cep <- paste0(u_base, endpoint_cep, numero_cep)
  
  # Faz a requisição GET
  r_cep <- GET(u_cep)
  
  # Verifica o status da requisição e interrompe em caso de erro
  q_status_code <- status_code(r_cep)
  if(q_status_code != 200){
    stop(paste0("A requisição retornou o status: ", q_status_code))
  }
  
  # Extrai o conteúdo da resposta
  conteudo_cep <- content(r_cep)
  
  # Pausa a execução por 1 segundo 
  Sys.sleep(1)
  
  # Converte o conteúdo em tibble, remove a coluna 'location' e mantém valores distintos
  conteudo_cep |>
    tibble::as_tibble() |>
    dplyr::select(-location) |>
    dplyr::distinct()
}

# Exemplos de uso da função buscar_cep_api
cep_cebrap <- buscar_cep_api("04015051")
cep_av_paulista <- buscar_cep_api("01310-100")

# Exemplo de CEP inválido (sem aspas, resultaria em erro)
# cep_av_paulista_2 <-  buscar_cep_api(01310100)

# Usando map para aplicar a função de busca em um conjunto de CEPs
conjunto_ceps <- c("04015051", "01310-100", "05508-010", "09606-045")

# Aplica a função de busca de CEPs em cada um dos CEPs do conjunto
# O argumento .progress = TRUE mostra uma barra de progresso durante a execução
lista_map <- map(.x = conjunto_ceps, .f = buscar_cep_api, .progress = TRUE)

# Empilha as linhas em uma única tibble
df_map_ceps <- lista_map |> 
  list_rbind()
