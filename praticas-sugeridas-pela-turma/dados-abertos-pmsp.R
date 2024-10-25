# Sugestão do Pedro: 
#PMSP Dados Abertos
# http://dados.prefeitura.sp.gov.br/
# Interesse em checar periodicamente quais conjuntos de dados 
# estão disponiveis nos dados abertos (por tema) e saber quando
# foram atualizados	
# Informações interessantes:
# Tema, nome do conjunto, data modificada, autor
# -------
# Não encontrei a API escondida!
# É um site implementado com CKAN
# https://docs.ckan.org/en/2.7/api/
# O CKAN tem uma API


# PARTE 1 ---- Buscar a lista de conjunto de dados
library(httr)

u_temas <- "http://dados.prefeitura.sp.gov.br/api/3/action/package_list"

r_temas_v1 <- u_temas |> 
  GET() 

# Dá resultado 200, mas aparece "REQUISIÇÃO BLOQUEADA" 
# no conteúdo do HTML

# Pedi ajuda para o Gepeto. Ele sugeriu usar a função add_headers()


# Parece que o servidor da API está bloqueando sua requisição, 
# provavelmente por causa de restrições que envolvem o "User-Agent" do 
# seu request. O navegador inclui um "User-Agent" automaticamente,
# o que pode permitir o acesso sem restrições, enquanto as requisições 
# programáticas feitas com httr ou outros pacotes podem ser bloqueadas 
# se não incluírem esse cabeçalho.
# 
# Tente adicionar o cabeçalho User-Agent na sua requisição, como mostrado
# abaixo:

# Adiciona um User-Agent ao request
r_lista_de_temas <- GET(
  u_temas,
  add_headers(`User-Agent` = "Mozilla/5.0")
)

# Verifica o conteúdo
r_lista_de_temas
# Status 200
# retornou um json

# Verifica o conteúdo
c_lista_de_temas <- content(r_lista_de_temas)


temas_disponiveis <- c_lista_de_temas$result |> 
  unlist()

temas_disponiveis


# Parte 2 ----------------
# Acessando informações sobre um conjunto de dados

conjunto_buscar <- sample(temas_disponiveis, 1)

u_conjunto <- paste0("http://dados.prefeitura.sp.gov.br/api/3/action/package_show?id=", conjunto_buscar)
r_conjunto <- GET(u_conjunto, add_headers(`User-Agent` = "Mozilla/5.0"))

c_conjunto <- content(r_conjunto, simplifyDataFrame = TRUE)


c_conjunto$result |> 
  tibble::as_tibble()

# Error in `recycle_columns()`:
# ! Tibble columns must have compatible sizes.
# • Size 0: Columns `relationships_as_object`, `groups`, `relationships_as_subject`, and `extras`.
# • Size 11: Column `organization`.
# • Size 46: Column `resources`.
# ℹ Only values of size one are recycled.


c_conjunto$result |> 
  # removendo os elementos que tem tamanho == 0
  purrr::discard(~length(.x) == 0) |>
  tibble::as_tibble()

# Esses elementos maiores podemos buscar depois
# Error in `recycle_columns()`:
# ! Tibble columns must have compatible sizes.
# • Size 11: Column `organization`.
# • Size 46: Column `resources`.
# ℹ Only values of size one are recycled.

informacoes_basicas <- c_conjunto$result |> 
  # manter os elementos que tem tamanho == 1
  purrr::keep(~length(.x) == 1) |>
  tibble::as_tibble()

organizacao <- c_conjunto$result$organization |> 
  tibble::as_tibble()

recursos <- c_conjunto$result$resources |>
  tibble::as_tibble()

# Fazer a mesma ideia dos exemplos anteriores: criar uma função,
# iterar nos elementos da lista e transformar em tibble

# Se for só para checar o que mudou, eu apenas geraria uma tibble simples,
# e exportaria um CSV. Usaria o GitHub actions.

# Para buscar todos os dias por exemplo, use o GitHub Actions