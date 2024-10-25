library(httr)
library(rvest)

# 2)
u_g1 <- "https://g1.globo.com/"
r_g1 <- GET(u_g1)

# Response [https://g1.globo.com/]
#   Date: 2024-10-24 14:09
#   Status: 200
#   Content-Type: text/html; charset=UTF-8
#   Size: 934 kB
# <!DOCTYPE HTML> 

html_g1 <- read_html(r_g1)


posts <- html_elements(html_g1, xpath = "//div[@class='feed-root']") |>
  html_elements(xpath = "//div[@class='_evt']")
# {xml_nodeset (20)}
#  [1] <div class="_evt"><div class="bstn-fd bstn-fd-ssr">\n<div class="post ...
#  [2] <div class="_evt"><div class="bastian-page" data-index="1"><div class ...
#  [3] <div class="_evt"><div class="bastian-feed-item" data-index="1"><div  ...
#  [4] <div class="_evt"><h2><a href="https://g1.globo.com/rj/rio-de-janeiro ...
#  [5] <div class="_evt"><div class="bastian-feed-item" data-index="2"><div  ...
#  [6] <div class="_evt"><h2><a href="https://g1.globo.com/rj/rio-de-janeiro ...
#  [7] <div class="_evt"><div class="bastian-feed-item" data-index="3"><div  ...
#  [8] <div class="_evt"><h2><a href="https://g1.globo.com/playlist/videos-p ...
#  [9] <div class="_evt"><div class="bastian-feed-item" data-index="4"><div  ...
# [10] <div class="_evt"><h2><a href="https://g1.globo.com/ms/mato-grosso-do ...
# [11] <div class="_evt"><div class="bastian-feed-item" data-index="5"><div  ...
# [12] <div class="_evt"><h2><a href="https://g1.globo.com/politica/blog/cam ...
# [13] <div class="_evt"><div class="bastian-feed-item" data-index="6"><div  ...
# [14] <div class="_evt"><h2><a href="https://g1.globo.com/jornal-nacional/n ...
# [15] <div class="_evt"><div class="bastian-feed-item" data-index="7"><div  ...
# [16] <div class="_evt"><h2><a class="feed-post-link gui-color-primary gui- ...
# [17] <div class="_evt"><div class="bastian-feed-item" data-index="8"><div  ...
# [18] <div class="_evt"><h2><a href="https://g1.globo.com/pop-arte/noticia/ ...
# [19] <div class="_evt"><div class="bastian-feed-item" data-index="9"><div  ...
# [20] <div class="_evt"><h2><a href="https://g1.globo.com/sp/vale-do-paraib ...

# titulo do post
titulos <- posts |>
  html_elements("h2") |>
  html_text()

# [1] "Passageiro de ônibus morreu após ser atingido na cabeça"              
# [2] "Cidade do Rio entrou em estágio 2 após tiroteios; conheça todos"      
# [3] "Motoristas se deitam na Av. Brasil durante tiroteio e mais VÍDEOS"    
# [4] "Quem são os 5 desembargadores afastados por venda de sentenças"       
# [5] "Desembargador investigado comprou carros e imóvel com dinheiro vivo"  
# [6] "Homem que matou pai, irmão e PM no RS era CAC: veja o que se sabe"    
# [7] "Jogos do g1"                                                          
# [8] "Fã brasileiro gasta R$ 200 por mês para alimentar relação com o ídolo"
# [9] "5 morrem em queda de avião de pequeno porte durante temporal"      

# link do post
links <- posts |>
  html_elements("h2") |>
  html_elements("a") |>
  html_attr("href")

# [1] "https://g1.globo.com/rj/rio-de-janeiro/noticia/2024/10/24/tiro-avenida-brasil-onibus.ghtml"                                                                                   
# [2] "https://g1.globo.com/rj/rio-de-janeiro/noticia/2024/10/24/entenda-os-cinco-estagios-operacionais-da-cidade-do-rio.ghtml"                                                      
# [3] "https://g1.globo.com/playlist/videos-para-assistir-agora.ghtml"                                                                                                               
# [4] "https://g1.globo.com/ms/mato-grosso-do-sul/noticia/2024/10/24/veja-quem-sao-os-5-desembargadores-do-tribunal-de-justica-de-ms-afastados-por-suspeita-venda-de-sentencas.ghtml"
# [5] "https://g1.globo.com/politica/blog/camila-bomfim/post/2024/10/24/coaf-apontou-movimentacoes-atipicas-de-desembargadores-suspeitos-de-vender-sentencas.ghtml"                  
# [6] "https://g1.globo.com/jornal-nacional/noticia/2024/10/23/homem-morre-depois-de-assassinar-3-pessoas-e-ferir-9-em-novo-hamburgo-rs.ghtml"                                       
# [7] NA                                                                                                                                                                             
# [8] "https://g1.globo.com/pop-arte/noticia/2024/10/24/fa-brasileiro-gasta-r-200-por-mes-para-alimentar-relacao-com-os-idolos-veja-raio-x-dos-fandoms.ghtml"                        
# [9] "https://g1.globo.com/sp/vale-do-paraiba-regiao/noticia/2024/10/24/aviao-de-pequeno-porte-que-caiu-no-interior-de-sp-tinha-cinco-ocupantes-e-ninguem-sobreviveu.ghtml"


# Problema: aparece apenas as primeiras notícias.
# O site carrega mais notícias conforme o usuário desce a página.
# Investigar como carregar mais notícias.
