# carregando pacotes necessários
library(rvest)
library(xml2)

# Criar pasta dados/, caso não exista!
fs::dir_create("dados/")

# fazer download do arquivo necessário
download.file(
  url = "https://raw.githubusercontent.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/refs/heads/main/dados/html_exemplo.html",
  destfile = "dados/html_exemplo.html"
)

# Pacote XML2 - xpath
# ler o html
html <- read_html("dados/html_exemplo.html")

# buscando as tags de parágrafos
todos_os_paragrafos <- xml_find_all(html, "//p")
primeiro_paragrafo <- xml_find_first(html, "//p")

# extraindo texto
texto_primeiro_paragrafo <- xml_text(primeiro_paragrafo)

xml_text(todos_os_paragrafos)

# extrair atributos
xml_attrs(todos_os_paragrafos) # atributos (geral)

xml_attr(todos_os_paragrafos, "style") # precisamos falar qual atributo queremos!

# Pacote rvest  --------

html_elements(html, xpath = "//p") # buscando os parágrafos

html_text(html) # extraindo texto

# texto do parágrafo que está em azul
html |> 
  # buscando o elemento que tem style = color: blue
  html_elements(xpath = "//p[@style='color: blue;']") |>
  # extraindo texto
  html_text()

