library(RSelenium)

# Iniciar, e abrir uma aba do navegador
drv <- rsDriver(browser = "firefox", verbose = FALSE, chromever = NULL)

# Acessar uma URL
drv$client$navigate("https://g1.globo.com/")

scroll_page <- function(cliente) {
  # Executa script JS para rolar até o final da página
  cliente$executeScript("window.scrollTo(0, document.body.scrollHeight);")
  Sys.sleep(2)  # Aguarda 2 segundos para o conteúdo carregar
}


# Usando purrr::map para rolar a página múltiplas vezes
purrr::map(1:10, ~scroll_page(drv$client))


# Salvar screenshot
arq <- "images/g1_selenium.png"
drv$client$screenshot(file = arq)

# Salvar o HTML em um arquivo
arq_html <- "html/g1_selenium.html"

codigo_pagina <- drv$client$getPageSource() |> 
  as.character()

writeLines(codigo_pagina, arq_html)

# Encontrar um elemento na página
elem <- drv$client$findElement("xpath", "//textarea[@name='q']")

# tentando extrair do HTML
html_g1 <- rvest::read_html("g1_home.html")
posts <- rvest::html_elements(html_g1, xpath = "//div[@class='feed-post-body']") 