# Carregando pacotes
library(httr)
library(rvest)
library(RSelenium)
library(tidyverse)

# Link que queremos acessar
url_cnj <- "https://justica-em-numeros.cnj.jus.br/painel-estatisticas/"

r_cnj <- GET(url_cnj)

c_cnj <- content(r_cnj)

readr::write_lines(c_cnj, "cnj.html")
# Olhando o código fonte, as informações não estão lá.

# É um iframe!
url_pbi <- "https://app.powerbi.com/view?r=eyJrIjoiY2MyNmU4NjYtOTcwOS00OGE5LTkzYWYtMGM0ZTVkMGJjOTllIiwidCI6ImFkOTE5MGU2LWM0NWQtNDYwMC1iYzVjLWVjYTU1NGNjZjQ5NyIsImMiOjJ9"

r_pbi <- GET(url_pbi)

c_pbi <- content(r_pbi)
readr::write_lines(c_pbi, "cnj_pbi.html")
# Olhando o código fonte, as informações não estão lá.

# Usando o selenium! ---------------
# iniciando a sessão no Firefox
drv <- rsDriver(browser = "firefox", chromever = NULL, phantomver = NULL)

# navegando até o site do PBI
drv$client$navigate(url_pbi)

# salvando para facilitar acessar
sessao <- drv$client

# buscando código fonte
page_source <- sessao$getPageSource()
html <- page_source[[1]]

# salvando em um arquivo
readr::write_lines(html, "cnj_pbi_selenium.html")

# Buscando informações que estão no site ----------------
divs_report <- html |> 
  read_html() |> 
  html_elements(xpath = "//div[@class='visualWrapper report']")
# visualWrapper report

titulos <- divs_report |> 
  map(html_element, xpath = ".//h3[@class='preTextWithEllipsis']") |> 
  map(html_text) |> 
  as.character()


valores <- divs_report |> 
  map(html_element, xpath = ".//text[@class='value']") |> 
  map(html_text) |> 
  as.character() |> 
  parse_number(locale = locale(decimal_mark = ",",
                               grouping_mark = "."))

tibble_bruta <- tibble::tibble(
  titulos, valores
) |> 
  drop_na(titulos, valores)

# criar uma função ------------------------------

pegar_informacoes_basicas <- function(info_sessao) {
  html <- info_sessao$getPageSource()[[1]]
  
  divs_report <- html |>
    read_html() |>
    html_elements(xpath = "//div[@class='visualWrapper report']")
  
  titulos <- divs_report |>
    map(html_element, xpath = ".//h3[@class='preTextWithEllipsis']") |>
    map(html_text) |>
    as.character()
  
  valores <- divs_report |>
    map(html_element, xpath = ".//text[@class='value']") |>
    map(html_text) |>
    as.character() |>
    parse_number(locale = locale(decimal_mark = ",", grouping_mark = "."))
  
  tibble_bruta <- tibble::tibble(titulos, valores) |>
    drop_na(titulos, valores)
  
  tibble_bruta
}

pagina_inicial <- pegar_informacoes_basicas(sessao)

# Fazendo um filtro e buscando as informações ------

caminho_xpath <- "/html/body/div[1]/report-embed/div/div/div[1]/div/div/div/exploration-container/div/div/docking-container/div/div/div/div/exploration-host/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container-group[2]/transform/div/div[2]/visual-container-group/transform/div/div[2]/visual-container-group[3]/transform/div/div[2]/visual-container[1]/transform/div/div[3]/div/div/visual-modern/div/div/div[2]/div/div"
#caminho_xpath_julio <- "//div[div/div/h3[contains(text(),'Tribunal')]]/following-sibling::div"

botao <- sessao$findElement("xpath", caminho_xpath)
botao$clickElement()

selecao <- sessao$findElement("xpath", "//span[contains(text(), 'TJSP')]")
selecao$clickElement()


infos_tjsp <- pegar_informacoes_basicas(sessao)

# finalizando a sessão ------
sessao$quit()
