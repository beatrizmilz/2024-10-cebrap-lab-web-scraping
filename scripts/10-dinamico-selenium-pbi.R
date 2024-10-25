library(httr)
library(rvest)
library(RSelenium)

# link que tem um iframe
u_pbi <- "https://justica-em-numeros.cnj.jus.br/painel-estatisticas/"
# link real. encontramos procurando no inspetor de elementos, tag iframe

u_pbi <- "https://app.powerbi.com/view?r=eyJrIjoiY2MyNmU4NjYtOTcwOS00OGE5LTkzYWYtMGM0ZTVkMGJjOTllIiwidCI6ImFkOTE5MGU2LWM0NWQtNDYwMC1iYzVjLWVjYTU1NGNjZjQ5NyIsImMiOjJ9"

r_pbi <- GET(u_pbi)

read_html(r_pbi) |> 
  html_text()


# usando RSelenium

drv <- rsDriver(browser = "firefox", chromever = NULL, phantomver = NULL)

ses <- drv$client

ses$navigate(u_pbi)

# não é o que vamos usar, porque queremos pegar o HTML disso
divs <- ses$findElements("xpath", "//div[@class='visualWrapper report']")
div <- divs[[1]]

# vamos pegar o html completo e usar rvest
html <- ses$getPageSource()[[1]]


divs <- html |> 
  read_html() |> 
  html_elements(xpath = "//div[@class='visualWrapper report']")

# alternativa 1

titulos <- divs |> 
  html_element(xpath = ".//h3[@class='preTextWithEllipsis']") |> 
  html_text()

valores <- divs |> 
  html_element(xpath = ".//text[@class='value']") |> 
  html_text()

tibble::tibble(
  titulo = titulos,
  valor = valores
) |> 
  dplyr::filter(!is.na(titulo), !is.na(valor))

# alternativa 2, mais robusta

titulos <- divs |> 
  purrr::map(\(x) html_element(x, xpath = ".//h3[@class='preTextWithEllipsis']")) |> 
  purrr::map_chr(html_text)

valores <- divs |> 
  purrr::map(\(x) html_element(x, xpath = ".//text[@class='value']")) |> 
  purrr::map_chr(html_text)

tibble::tibble(
  titulo = titulos,
  valor = valores
) |> 
  dplyr::filter(!is.na(titulo), !is.na(valor))

pega_infos_basicas <- function(ses) {
  html <- ses$getPageSource()[[1]]
  divs <- html |> 
    read_html() |> 
    html_elements(xpath = "//div[@class='visualWrapper report']")

  titulos <- divs |> 
    purrr::map(\(x) html_element(x, xpath = ".//h3[@class='preTextWithEllipsis']")) |> 
    purrr::map_chr(html_text)

  valores <- divs |> 
    purrr::map(\(x) html_element(x, xpath = ".//text[@class='value']")) |> 
    purrr::map_chr(html_text)

  tibble::tibble(
    titulo = titulos,
    valor = valores
  ) |> 
    dplyr::filter(!is.na(titulo), !is.na(valor))

}

pega_infos_basicas(ses)

botao <- ses$findElement("xpath", "//div[div/div/h3[contains(text(),'Tribunal')]]/following-sibling::div")

botao$clickElement()

selectbox <- ses$findElement("xpath", "//span[contains(text(),'TJAM')]")

selectbox$clickElement()

pega_infos_basicas(ses)
