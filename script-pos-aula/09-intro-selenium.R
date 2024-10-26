# Carregar o pacote RSelenium
library(RSelenium)

# Iniciar o servidor do RSelenium. Ele irá abrir uma janela do Firefox
# Essa etapa pode demorar um pouco
drv <- rsDriver(browser = "firefox", verbose = FALSE, chromever = NULL)

# No windows precisa de outras instalação
# Com firefox é mais fácil! chrome a gente tem que passar a versão

# Acessando uma URL
drv$client$navigate("https://google.com")

# Procurando um elemento: no caso, o campo de busca
elem <- drv$client$findElement("xpath", "//textarea[@name='q']")


# Escrevendo no campo de busca
elem$sendKeysToElement(list("Cebrap lab"))
# Clicando enter
elem$sendKeysToElement(list(key = "enter"))

# voltar para a página anterior?
# drv$client$goBack()

# Esperar um pouco para a página carregar
Sys.sleep(2)

# Capturar a tela
drv$client$screenshot(file = "imagens/screenshot_selenium.png")

# Buscando o código fonte (HTML) da página

lista_page_source <- drv$client$getPageSource()[[1]]

# Salvando o código fonte em um arquivo local
readr::write_lines(lista_page_source, "google.html")

# extraindo as informações da página ------------
library(rvest)
html_google <- lista_page_source |> 
  read_html() 

# Buscando os links
html_google |> 
  html_nodes("#center_col") |> 
  html_elements("a") |> 
  html_attr(name = "href")



# Buscando os títulos de terceira ordem
html_google |> 
  html_elements("h3")

# Fechar o servidor
drv$client$quit()
