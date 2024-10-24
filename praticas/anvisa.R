# Sugestão da Marina:
# consultas públicas ANVISA agrotóxico de janeiro de 2016 até junho de 2024
# Informações para buscar:
# Parte 1:
# - número da consulta - OK
# - assunto - OK
# - status - OK
# Parte 2: 
# - análise do impacto regulatório
# - Justificativa para dispensa de AIR
# - Consulta Pública(CP)
# - Documentos relacionados

library(httr)


# É uma API quando conseguimos fazer uma requisição GET/POST e retorna um JSON ou XML


# Acessar o site: https://antigo.anvisa.gov.br/consultas-publicas
# abrir a aba network do navegador
# limpar o que já aparece (botão de lixeira)
# fazer algum clique nos filtros (ex. assuntos = agrotóxicos)
# Ver na aba network a chamada da API
# https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa?assuntos=476541&atos=1&companyId=10154&count=10&groupId=10181&itensPorPagina=10&page=1&pesquisaAto=false&total=1900&userId=10158

url_anvisa <- "https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa?assuntos=476541&atos=1&companyId=10154&count=1000&groupId=10181&itensPorPagina=1000&page=1&pesquisaAto=false&total=1900&userId=10158"
r_anvisa <- GET(url_anvisa)
# ACEITA 1000 RESULTADOS POR PÁGINA


r_anvisa

c_anvisa <- content(r_anvisa, simplifyDataFrame = TRUE)

c_anvisa$resultado$total # total de resultados
c_anvisa$resultado$totalPaginas # número de páginas

tab_resultados <- c_anvisa$resultado$dados |> 
  tibble::as_tibble()

# ACEITA 1000 RESULTADOS POR PÁGINA

# Mostrar: como buscar outras páginas. fazer função.

# Parte 2 - informações sobre cada a consulta

# mesmo processo do network.
# https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa/525684

url_anvisa_consulta <- "https://antigo.anvisa.gov.br/etapas-regulatorias-portlet/api/etapa/525684"
r_anvisa_consulta <- GET(url_anvisa_consulta)
c_anvisa_consulta <- content(r_anvisa_consulta, simplifyDataFrame = TRUE)
c_anvisa_consulta$resultado

informacoes_basicas <- c_anvisa_consulta$resultado |> 
  # Removendo itens da lista que tem valores NULL
  purrr::discard(is.null) |>
  # Tem alguns elementos que são data.frames. 
  purrr::discard(~length(.x) > 1) |>
  # removendo listas vazias
  purrr::discard(~length(.x) == 0) |>
  # Transformando em tibble
  tibble::as_tibble()

transformar_em_tibble <- function(elemento_lista){
  elemento_lista |> 
    # Removendo itens da lista que tem valores NULL
    purrr::discard(is.null) |>
    # transformando em tibble
    tibble::as_tibble()
  
}

documentos_relacionados <- c_anvisa_consulta$resultado$documentosRelacionados |> 
  transformar_em_tibble()

condicao_processual <- c_anvisa_consulta$resultado$condicaoProcessual |> 
  transformar_em_tibble()

unidade_org <- c_anvisa_consulta$resultado$unidadeOrg |>
  transformar_em_tibble()

publicacao_dou <- c_anvisa_consulta$resultado$publicacaoDou |>
  transformar_em_tibble() |> 
  dplyr::mutate(arquivo = list(transformar_em_tibble(arquivo))) |> 
  tidyr::unnest(arquivo)


list(
  informacoes_basicas = informacoes_basicas,
  documentos_relacionados = documentos_relacionados,
  condicao_processual = condicao_processual,
  unidade_org = unidade_org,
  publicacao_dou = publicacao_dou

)

# • Size 2: Column `documentosRelacionados`.
# • Size 3: Column `condicaoProcessual`.
# • Size 5: Column `unidadeOrg`.
# • Size 13: Column `publicacaoDou`.

str(c_anvisa_consulta$resultado)
# List of 50
#  $ id                               : int 525684
#  $ tipoAto                          : int 1
#  $ descricaoTipoAto                 : chr "Consulta Pública"
#  $ numeracao                        : int 1288
#  $ dataCriacao                      : num 1.73e+12
#  $ dataAssinatura                   : num 1.73e+12
#  $ fimContribuicao                  : num 1.74e+12
#  $ inicioContribuicao               : num 1.73e+12
#  $ dataAudienciaPublica             : NULL
#  $ formulario                       : chr "http://pesquisa.anvisa.gov.br/index.php/212154?lang=pt-BR"
#  $ resultado                        : NULL
#  $ situacaoConsultaPublica          : int 1
#  $ situacaoAudienciaPublica         : NULL
#  $ localAudiencia                   : NULL
#  $ assuntoAudiencia                 : chr "Proposta de alteração da Resolução da Diretoria Colegiada - RDC nº 73, de 7 de abril de 2016, que dispõe sobre "| __truncated__
#  $ assuntoResumidoAudiencia         : chr "Alteração das RDCs nº 73, de 7/04/2016 e nº 47, de 8/09/2009."
#  $ situacaoProblema                 : chr "Necessidade de tornar expressa a aplicação da Resolução RDC nº 73/2016 ao pós-registro de radiofármacos e medic"| __truncated__
#  $ processo                         : chr "25351809534202421"
#  $ temaAgenda                       : chr "S"
#  $ numeroTema                       : chr "8.11"
#  $ anoAgenda                        : chr "2024/2025"
#  $ outraArea                        : NULL
#  $ diretorResponsavel               : NULL
#  $ unidade                          : int 2040
#  $ unidadeOrg                       :List of 5
#   ..$ id    : int 2040
#   ..$ coUf  : chr "DF"
#   ..$ codigo: NULL
#   ..$ nome  : chr "GERÊNCIA-GERAL DE PRODUTOS BIOLÓGICOS, RADIOFÁRMACOS, SANGUE, TECIDOS, CÉLULAS, ÓRGÃOS E PRODUTOS DE TERAPIAS AVANÇADAS "
#   ..$ sigla : chr "GGBIO"
#  $ outraUnidade                     : NULL
#  $ diretorRelator                   : chr "Frederico Augusto de Abreu Fernandes"
#  $ regimeTramitacao                 : NULL
#  $ local                            : NULL
#  $ avisos                           : chr "1) E-mails das Áreas Técnicas responsáveis por esta CP: GGBIO = ggbio@anvisa.gov.br e  GGMED = medicamento.asse"| __truncated__
#  $ referencias                      : list()
#  $ condicaoProcessual               :'data.frame':	3 obs. of  3 variables:
#   ..$ id                        : int [1:3] 4 1 6
#   ..$ descricao                 : chr [1:3] "Realização de CP aprovada" "Dispensa de AIR aprovada" "Processo de baixo impacto"
#   ..$ tipoCondicaoProcessualEnum: chr [1:3] "CONSULTA_PUBLICA" "ANALISE_IMPACTO_REGULATORIO" "JUSTIFICATIVA_DISPENSA"
#  $ publicacaoDou                    :List of 13
#   ..$ id                    : int 525679
#   ..$ dataPublicacao        : chr "2024-10-18"
#   ..$ tipoAlteracao         : NULL
#   ..$ tipo                  : NULL
#   ..$ idEtapaRegulatoria    : NULL
#   ..$ idPublicacaoPai       : NULL
#   ..$ idArquivo             : NULL
#   ..$ descArquivo           : NULL
#   ..$ descricaoTipoAlteracao: NULL
#   ..$ numeracao             : NULL
#   ..$ secao                 : NULL
#   ..$ pagina                : NULL
#   ..$ arquivo               :List of 8
#   .. ..$ fileEntryId: int 6892996
#   .. ..$ uuid       : chr "30802d83-2788-4e5a-828f-7e122f229f29"
#   .. ..$ title      : chr "CONSULTA PÚBLICA Nº 1288 GGBIO.pdf"
#   .. ..$ groupId    : int 10181
#   .. ..$ folderId   : int 6892593
#   .. ..$ extension  : chr "pdf"
#   .. ..$ rename     : NULL
#   .. ..$ url        : chr "/documents/10181/6892593/CONSULTA+P%C3%9ABLICA+N%C2%BA+1288+GGBIO.pdf/30802d83-2788-4e5a-828f-7e122f229f29"
#  $ retificacoes                     : list()
#  $ descricaoSituacaoConsultaPublica : chr "Aguardando Abertura"
#  $ descricaoSituacaoAudienciaPublica: NULL
#  $ referenciasDescricao             : list()
#  $ descricaoRegimeTramitacao        : NULL
#  $ descricaoStatusEtapa             : chr "Aguardando Abertura"
#  $ userId                           : int 6311257
#  $ groupId                          : int 10181
#  $ companyId                        : int 10154
#  $ retificacoesExcluidas            : NULL
#  $ categoryIds                      : NULL
#  $ documentosExcluidos              : NULL
#  $ documentosRelacionados           :'data.frame':	2 obs. of  8 variables:
#   ..$ fileEntryId: int [1:2] 6892598 6892612
#   ..$ uuid       : chr [1:2] "1177fb21-b61f-4b56-bae0-3fbaac2b2fb1" "739482d8-d831-4bec-b240-ca9080919af6"
#   ..$ title      : chr [1:2] "Formulário de Abertura de Processo de Regulação_CP 1288_2024 - GGBIO-GGMED.pdf" "Voto nº 2119_2024_Dire2_CP 1288_SEI_ANVISA - 3217573.pdf"
#   ..$ groupId    : int [1:2] 10181 10181
#   ..$ folderId   : int [1:2] 6892593 6892593
#   ..$ extension  : chr [1:2] "pdf" "pdf"
#   ..$ rename     : logi [1:2] NA NA
#   ..$ url        : chr [1:2] "/documents/10181/6892593/Formul%C3%A1rio+de+Abertura+de+Processo+de+Regula%C3%A7%C3%A3o_CP+1288_2024+-+GGBIO-GG"| __truncated__ "/documents/10181/6892593/Voto+n%C2%BA+2119_2024_Dire2_CP+1288_SEI_ANVISA+-+3217573.pdf/739482d8-d831-4bec-b240-ca9080919af6"
#  $ linksRelacionados                :'data.frame':	1 obs. of  3 variables:
#   ..$ id    : int 525694
#   ..$ link  : logi NA
#   ..$ titulo: logi NA
#  $ atosRelacionados                 :'data.frame':	1 obs. of  4 variables:
#   ..$ descricao: chr "Termo de Abertura de Processo (TAP) nº 64 de 18/10/2024"
#   ..$ id       : int 525685
#   ..$ tipo     : chr "E"
#   ..$ processo : logi NA
#  $ noticiasRelacionadas             : list()
#  $ titulo                           : chr "Consulta Pública nº 1288 de 17/10/2024"
