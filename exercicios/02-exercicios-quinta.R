# Conceitos para praticar:
# Raspar informações de um site
library(httr)
library(rvest)


# 1) Raspando tabelas -------------------------

# 1.a)
# Usando a página do wikipedia sobre o Paulo Freire, raspe as seguintes tabelas:
# - Títulos de Doutor Honoris Causa
# - Relação das Cátedras Paulo Freire no Brasil 

# https://pt.wikipedia.org/wiki/Paulo_Freire
url_wiki <- "https://pt.wikipedia.org/wiki/Paulo_Freire"

# Não se preocupe em tratar os dados depois de raspar, o foco é conseguir
# acessar as tabelas (mas se quiser, sem problemas também).

# 1.b) Use a página da Wikipedia sobre "Oscar de melhor filme" para raspar a
# tabela que contém a lista de filmes indicados para o Oscar.
# Link: https://pt.wikipedia.org/wiki/Oscar_de_melhor_filme





# 1.b - Desafio: tente criar uma coluna que indique se o filme foi vencedor ou não.

