# Atenção: eu fiz algumas modificações nesse script após a aula!

# Site da sabesp estava fora do ar, então usamos o exemplo sugerido pela Marina
# Sugestão da Marina:
# consultas públicas ANVISA agrotóxico de janeiro de 2016 até junho de 2024
# https://antigo.anvisa.gov.br/consultas-publicas#/
# https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa?assuntos=476541&atos=1&companyId=10154&count=10&groupId=10181&itensPorPagina=10&page=1&pesquisaAto=false&total=1900&userId=10158

# Carregar pacotes
library(httr)

# É uma API quando conseguimos fazer uma requisição GET/POST e retorna um JSON ou XML

# PARTE 1 - BUSCANDO A LISTA DE CONSULTAS PÚBLICAS
# Acessar o site: https://antigo.anvisa.gov.br/consultas-publicas
# abrir a aba network do navegador
# limpar o que já aparece (botão de lixeira)
# fazer algum clique nos filtros (ex. assuntos = agrotóxicos)
# Ver na aba network a chamada da API, copiei o link da chamada da API
# https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa?assuntos=476541&atos=1&companyId=10154&count=10&groupId=10181&itensPorPagina=10&page=1&pesquisaAto=false&total=1900&userId=10158

# Fizemos alguns testes e vimos que conseguimos buscar até 1000 itens por página

# Fazendo a requisição
url_anvisa <- "https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa?assuntos=476541&atos=1&companyId=10154&count=1000&groupId=10181&itensPorPagina=1000&page=1&pesquisaAto=false&userId=10158"

r_anvisa <- GET(url_anvisa)

c_anvisa <- content(r_anvisa, simplifyDataFrame = TRUE)

# Explorando o resultado
c_anvisa$resultado

dados_anvisa <- c_anvisa$resultado$dados |> tibble::as_tibble()

c_anvisa$resultado$pagina
c_anvisa$resultado$itensPorPagina
c_anvisa$resultado$totalPaginas
c_anvisa$resultado$total

# Podemos fazer uma função, para depois fazer um loop para buscar todas as páginas

buscar_anvisa_pagina <- function(n_pagina) {
  url_anvisa <- paste0(
    "https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa?assuntos=476541&atos=1&companyId=10154&count=1000&groupId=10181&itensPorPagina=1000&page=",
    n_pagina,
    "&pesquisaAto=false&userId=10158"
  )
  r_anvisa <- GET(url_anvisa)

  c_anvisa <- content(r_anvisa, simplifyDataFrame = TRUE)

  dados_anvisa <- c_anvisa$resultado$dados |> tibble::as_tibble()

  dados_anvisa
}

# preparando para fazer o loop
total_paginas <- c_anvisa$resultado$totalPaginas
vetor_paginas <- 1:total_paginas

lista_anvisa <- purrr::map(.x = vetor_paginas, .f = buscar_anvisa_pagina, .progress = TRUE)
# Cade os 3? Descobrir depois

tibble_anvisa <- lista_anvisa |>
  purrr::list_rbind()

readr::write_rds(tibble_anvisa, file = "dados/anvisa_lista_consulta.rds")

# PARTE 2 - BUSCANDO INFORMAÇÕES DE CADA CONSULTA ----------
# https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa/525684

# Criando uma função que recebe os elementos da lista,
# remove os elementos NULL e transforma em um tibble
# Essa função é auxiliar, usada dentro de buscar_anvisa_consulta()
transformar_em_tibble <- function(elemento_lista) {
  tibble_criada <- elemento_lista |>
    # vamos descartar se o elemento for NULL
    purrr::discard(is.null) |>
    # transformando em uma tibble
    tibble::as_tibble()

  if (nrow(tibble_criada) == 0) {
    # se tiver mais de uma linha, vamos transformar em uma lista
    tibble_criada <- tibble::tibble(vazio = "")
  }

  tibble_criada
}

# Criando uma função para buscar as informações de uma consulta
# usando o ID da consulta
# O processo para descobrir foi similar: aba network
buscar_anvisa_consulta <- function(cod_id_consulta) {
  # Criando um objeto compondo o nome do arquivo para salvar
  # o Sys.Date() é para ter um timestamp
  nome_do_arquivo_rds <- paste0("dados/anvisa/", cod_id_consulta, "_", Sys.Date(), ".rds")

  # verificação se o arquivo foi baixado.
  # Se não foi, baixar.
  # Se foi, apenas lê o arquivo baixado anteriormente.
  if (!fs::file_exists(nome_do_arquivo_rds)) {
    # Criando a URL da consulta
    url_consulta <- paste0(
      "https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa/",
      cod_id_consulta
    )
    # Fazendo a requisição GET
    g_consulta <- GET(url_consulta)

    # se o status code for diferente de 200, abortar
    status_consulta <- status_code(g_consulta)
    if (status_consulta != 200) {
      cli::cli_abort("Algo deu errado na requisição. Status code: {status_consulta}.")
    }

    c_consulta <- content(g_consulta, simplifyDataFrame = TRUE)
    # o resultado é uma lista que não pode ser transformada diretamente em um tibble
    # precisamos quebrar em passo a passo!


    # Informações básicas
    informacoes_basicas <- c_consulta$resultado |>
      # vamos descartar se o elemento for NULL
      purrr::discard(is.null) |>
      # vamos descartar se o elemento for uma lista vazia
      purrr::discard(~ length(.x) == 0) |>
      # vamos descartar se o elemento for uma lista com mais de um elemento
      # (precisamos tratar esse caso a seguir!)
      purrr::discard(~ length(.x) > 1) |>
      # transformando em uma tibble
      tibble::as_tibble()


    # Extraindo elementos que não conseguimos na etapa acima
    # fazendo o nest para que vire uma célula e a gente consiga juntar na tabela final

    # Verificando se estamos tratando todos os elementos
    nomes_itens_lista_profunda <- c_consulta$resultado |>
      purrr::keep(~ length(.x) > 1) |>
      names()

    elementos_lista_profunda <- c(
      "documentosRelacionados",
      "unidadeOrg",
      "condicaoProcessual",
      "publicacaoDou",
      "linksRelacionados",
      "atosRelacionados"
    )

    # browser()

    vetor_logico_elementos <- !nomes_itens_lista_profunda %in% elementos_lista_profunda

    vetor_falta_item_lista <- nomes_itens_lista_profunda[vetor_logico_elementos]


    if (length(vetor_falta_item_lista) > 0) {
      cli::cli_abort("Há elementos que não foram tratados. Verificar: {vetor_falta_item_lista}")
    }

    # tratar os elementos que são listas com mais de um elemento
    documentos_relacionados <- transformar_em_tibble(c_consulta$resultado$documentosRelacionados) |>
      tidyr::nest(.key = "documentos_relacionados")

    unidade_org <- transformar_em_tibble(c_consulta$resultado$unidadeOrg) |>
      tidyr::nest(.key = "unidade_org")

    condicao_processual <- transformar_em_tibble(c_consulta$resultado$condicaoProcessual) |>
      tidyr::nest(.key = "condicao_processual")

    links_relacionados <- transformar_em_tibble(c_consulta$resultado$linksRelacionados) |>
      tidyr::nest(.key = "links_relacionados")

    atos_relacionados <- transformar_em_tibble(c_consulta$resultado$atosRelacionados) |>
      tidyr::nest(.key = "atos_relacionados")



    publicacao_dou <- transformar_em_tibble(c_consulta$resultado$publicacaoDou) |>
      dplyr::mutate(arquivo = list(transformar_em_tibble(arquivo))) |>
      tidyr::unnest(arquivo) |>
      dplyr::distinct() |>
      tidyr::nest(.key = "publicacao_dou")


    # juntando tudo em uma tabela final
    tab_final <- informacoes_basicas |>
      dplyr::bind_cols(
        unidade_org,
        condicao_processual,
        publicacao_dou,
        documentos_relacionados,
        links_relacionados,
        atos_relacionados
      )

    # salvando o arquivo
    fs::dir_create("dados/anvisa/")
    readr::write_rds(tab_final, file = nome_do_arquivo_rds)
  } else {
    # Caso o arquivo tenha sido salvo anteriormente,
    # leia o arquivo
    tab_final <- readr::read_rds(nome_do_arquivo_rds)
  }

  tab_final
}

# Experimentando a função
# sample(tibble_anvisa$id, 1)
df_consulta <- buscar_anvisa_consulta("444468")


tibble_anvisa$id
# PARTE 3 - Iterando sobre todas as consultas

# Vamos fazer um loop para buscar parte das consultas
# (é possível fazer com todas, mas demora!)
# Vamos buscar 10 consultas aleatórias
ids_buscar <- sample(tibble_anvisa$id, 10)

# Iterando sobre as consultas do "ids_buscar" usando
# a função "buscar_anvisa_consulta"
# o .progress = TRUE é para mostrar a barra de progresso
buscas <- purrr::map(ids_buscar, buscar_anvisa_consulta, .progress = TRUE)

# empilhar as linhas
df_buscas <- buscas |>
  purrr::list_rbind()

# Salvando em um arquivo
readr::write_rds(df_buscas, file = "dados/anvisa_consultas_detalhadas.rds")

dplyr::glimpse(df_buscas)
# Rows: 10
# Columns: 32
# $ id                               <int> 314654, 340499, 427666, 440664, 469681, 25…
# $ tipoAto                          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
# $ descricaoTipoAto                 <chr> "Consulta Pública", "Consulta Pública", "C…
# $ numeracao                        <int> 195, 306, 855, 973, 1059, 34, 110, 614, 51…
# $ dataCriacao                      <dbl> 1.465398e+12, 1.486730e+12, 1.594820e+12, …
# $ dataAssinatura                   <dbl> 1.465268e+12, 1.486606e+12, 1.594091e+12, …
# $ fimContribuicao                  <dbl> 1.467947e+12, 1.489288e+12, 1.599966e+12, …
# $ inicioContribuicao               <dbl> 1.465441e+12, 1.486692e+12, 1.594868e+12, …
# $ formulario                       <chr> "http://websphere/wps/wcm/connect/4653e300…
# $ situacaoConsultaPublica          <int> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
# $ assuntoAudiencia                 <chr> "Proposta de incluir a cultura de milheto …
# $ assuntoResumidoAudiencia         <chr> "Proposta de Resolução para o ingrediente …
# $ processo                         <chr> "25351708390201137", "25351337955201036", …
# $ temaAgenda                       <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N…
# $ unidade                          <int> 96, 96, 1750, 1750, 1750, 96, 96, 1750, 17…
# $ diretorRelator                   <chr> "RENATO ALENCAR PORTO", "Fernando Mendes G…
# $ regimeTramitacao                 <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, NA
# $ descricaoSituacaoConsultaPublica <chr> "Encerrado", "Encerrado", "Encerrado", "En…
# $ descricaoRegimeTramitacao        <chr> "Comum", "Comum", "Comum", "Comum", "Comum…
# $ descricaoStatusEtapa             <chr> "Encerrado", "Encerrado", "Encerrado", "En…
# $ userId                           <int> 514862, 2697180, 5671995, 5671995, 6311257…
# $ groupId                          <int> 10181, 10181, 10181, 10181, 10181, 10181, …
# $ companyId                        <int> 10154, 10154, 10154, 10154, 10154, 10154, …
# $ titulo                           <chr> "Consulta Pública nº 195 de 07/06/2016", "…
# $ unidade_org                      <list> [<tbl_df[1 x 5]>], [<tbl_df[1 x 5]>], [<tb…
# $ condicao_processual              <list> [<tbl_df[3 x 3]>], [<tbl_df[3 x 3]>], [<tb…
# $ publicacao_dou                   <list> [<tbl_df[1 x 9]>], [<tbl_df[1 x 9]>], [<tb…
# $ documentos_relacionados          <list> [<tbl_df[1 x 1]>], [<tbl_df[1 x 1]>], [<t…
# $ avisos                           <chr> NA, "Importante: A fim de garantir maior …
# $ links_relacionados               <list> <NULL>, <NULL>, <NULL>, <NULL>, [<tbl_df[…
# $ atos_relacionados                <list> <NULL>, <NULL>, <NULL>, <NULL>, [<tbl_df[…
# $ situacaoProblema                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, "Neces…
