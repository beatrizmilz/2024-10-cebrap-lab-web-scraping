# install.packages("webdriver")
library(webdriver)
library(tidyverse)
library(rvest)

# Instalando o Phantom JS
# webdriver::install_phantomjs()

# Iniciando o Phantom JS
pjs <- run_phantomjs()
pjs
# $process
# PROCESS 'phantomjs', running, pid 94057.
# 
# $port
# [1] 5056

# Criando uma sessão
ses <- Session$new(port = pjs$port)

# <Session>
#   Public:
#     click: function (button = c("left", "middle", "right")) 
#     clone: function (deep = FALSE) 
#     delete: function () 
#     doubleClick: function (button = c("left", "middle", "right")) 
#     executeScript: function (script, ...) 
#     executeScriptAsync: function (script, ...) 
#     findElement: function (css = NULL, linkText = NULL, partialLinkText = NULL, 
#     findElements: function (css = NULL, linkText = NULL, partialLinkText = NULL, 
#     getActiveElement: function () 
#     getAllWindows: function () 
#     getLogTypes: function () 
#     getSource: function () 
#     getStatus: function () 
#     getTitle: function () 
#     getUrl: function () 
#     getWindow: function () 
#     go: function (url) 
#     goBack: function () 
#     goForward: function () 
#     initialize: function (host = "127.0.0.1", port = 8910) 
#     mouseButtonDown: function (button = c("left", "middle", "right")) 
#     mouseButtonUp: function (button = c("left", "middle", "right")) 
#     moveMouseTo: function (xoffset, yoffset) 
#     readLog: function (type = "browser") 
#     refresh: function () 
#     setTimeout: function (script = NULL, pageLoad = NULL, implicit = NULL) 
#     takeScreenshot: function (file = NULL) 
#     waitFor: function (expr, checkInterval = 100, timeout = 3000) 
#   Private:
#     host: 127.0.0.1
#     makeRequest: function (endpoint, data = NULL, params = NULL, headers = NULL) 
#     numLogLinesShown: 0
#     parameters: list
#     port: 5056
#     sessionId: 81c89e90-9212-11ef-b2be-8331fdbff13f

# Acessando uma página

ses$go("https://g1.globo.com/")

# Tirando um screenshot
fs::dir_create("images/")
nome_do_arquivo <- paste0("images/g1-home_", format(Sys.time(), "%Y-%m-%d_%Hh-%Mmin"), ".png")

ses$takeScreenshot(file = nome_do_arquivo)

# Função para rolar a página até o final e carregar mais notícias
scroll_page <- function(session) {
  # Executa script JS para rolar até o final da página
  session$executeScript("window.scrollTo(0, document.body.scrollHeight);")
  Sys.sleep(2)  # Aguarda 2 segundos para o conteúdo carregar
}

# Usando purrr::map para rolar a página múltiplas vezes
map(1:10, ~scroll_page(ses))

# Buscando os elementos das notícias carregadas
elementos_noticias <- ses$findElements(xpath = "//div[@class='feed-post-body']")

# Função para extrair o título de uma notícia
extrair_titulo <- function(elemento) {
  elemento$findElement(xpath = ".//h2")$getText()
}

# Função para extrair o link de uma notícia
extrair_link <- function(elemento) {
  elemento$findElement(xpath = ".//h2/a")$getAttribute("href")
}

extrair_imagem <- function(elemento) {
  img_element <- elemento$findElement(xpath = ".//picture[@class='bstn-fd-cover-picture']/img")
  img_element$getAttribute("src")
}


# Usando purrr::map para aplicar as funções
titulos_noticias <- map(elementos_noticias, extrair_titulo)
links_noticias <- map(elementos_noticias, extrair_link)
imagens_noticias <- map(elementos_noticias, possibly(extrair_imagem, NA))

# fazer download das imagens

fs::dir_create("images/noticias/")
imagens_noticias |> 
  purrr::map(~{
    if(!is.na(.x)){
      download.file(.x, paste0("images/noticias/", basename(.x)))
    }
  })

# Salvar o HTML
html <- ses$getSource()

readr::write_file(html, "html/g1_home.html")


# tentando extrair do HTML
html_g1 <- read_html("html/g1_home.html")
posts <- html_elements(html_g1, xpath = "//div[@class='feed-post-body']") 
