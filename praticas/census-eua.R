# Sugestão do Christy
# https://www2.census.gov/library/publications/decennial/

library(httr)
library(rvest)
library(tidyverse)

u_census <- "https://www2.census.gov/library/publications/decennial/"

r_census <- GET(u_census)
# Retorna um HTML

c_census <- content(r_census)

lista_arquivos_anos <- html_table(c_census) |> 
  purrr::pluck(1) |> 
  janitor::clean_names() |> 
  tibble::as_tibble() |> 
  dplyr::filter(!name %in% c("", "Parent Directory")) |> 
  dplyr::select(-x) |> 
  dplyr::mutate(url = paste0(u_census, name))
  
# Ideia: criar uma função que lista os arquivos de uma URL deste tipo
# e retorna um tibble com os arquivos e os links para download

listar_arquivos <- function(url_census) {
  r_census <- GET(url_census)
  c_census <- content(r_census)
  
  lista_arquivos <- html_table(c_census) |> 
    purrr::pluck(1) |> 
    janitor::clean_names() |> 
    tibble::as_tibble() |> 
    dplyr::filter(!name %in% c("", "Parent Directory")) |> 
    dplyr::select(-x) |> 
    dplyr::mutate(
      url_busca = url_census,
      url = paste0(url_census, name))
  
  lista_arquivos
}

arquivos_decennial <- listar_arquivos("https://www2.census.gov/library/publications/decennial/")

# Criar função para buscar arquivos de subpastas
# e aplicar em todas as pastas

buscar_arquivos_sub_pastas <- function(df_arquivos) {
  pastas_para_buscar <- df_arquivos |>
    # quando terminar com /, é uma pasta
    dplyr::filter(str_ends(name, "/"))
  
  arquivos_subpasta <- pastas_para_buscar$url |>
    purrr::map(listar_arquivos, .progress = TRUE)
  
  df_arquivos_subpasta <- arquivos_subpasta |>
    purrr::list_rbind()
  df_arquivos_subpasta
}

df_arquivos_1800 <- arquivos_decennial |> 
  dplyr::filter(stringr::str_starts(name, "18"))

arquivos_1800 <- df_arquivos_1800 |> 
  buscar_arquivos_sub_pastas() 

subpastas_1800 <- arquivos_1800 |> 
  buscar_arquivos_sub_pastas() 


# Juntando em um df

df_arquivos_1800_completo <- df_arquivos_1800 |>
  dplyr::bind_rows(arquivos_1800) |> 
  dplyr::bind_rows(subpastas_1800) |> 
  dplyr::distinct()

# filtrando os PDFs
df_arquivos_1800_completo_pdf <- df_arquivos_1800_completo |>
  dplyr::filter(str_ends(name, ".pdf"))

# Baixando os PDFs

baixar_pdf <- function(url_pdf){

  nome_arquivo <- url_pdf |> 
    stringr::str_remove("^https://www2.census.gov/library/publications/")
  
  arquivo_salvar <- paste0("dados/census/", nome_arquivo)
  
  # pastas para salvar
  diretorios <- c(fs::path_dir(arquivo_salvar))
  
  # criar diretorio
  fs::dir_create(diretorios)
  
  # download
  download.file(url_pdf, arquivo_salvar)

}

baixar_pdf(df_arquivos_1800_completo_pdf$url[1])

# Daqui pra frente é um problema diferente,
# extração de texto de PDFs