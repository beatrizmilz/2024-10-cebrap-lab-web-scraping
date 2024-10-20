# Parte 1 ------------------------------------------------------------------
# Faça os exercícios usando a API de dados abertos da Câmara dos Deputados, 
# https://dadosabertos.camara.leg.br/swagger/api.html

# 1) Explore a documentação. Isso é importante para entender como a API funciona.

# Dica: a URL base é:
# https://dadosabertos.camara.leg.br/api/v2/

# 1a) Qual é o endpoint para consultar deputadas e deputados?

# 1b) Qual tipo de requisição é necessária para consultar deputadas e deputados?

# 2) Buscando a lista de deputadas e deputados
# 2a) Faça uma requisição para consultar a lista de deputadas e deputados.


# 2b) Verifique o Status. O que ele significa?


# 2c) Verifique o Content-Type. O que ele significa?

# 2d) Acesse o conteúdo (lembre-se da função content()
# e o argumento simplifyDataFrame = TRUE). Como a resposta é estruturada?

# 2e) Salve em um novo objeto apenas uma tabela com os dados das deputadas e deputados.
# Ex do glimpse() do objeto:

# Rows: 513
# Columns: 9
# $ id            <int> 220593, 204379, 220714, 221328, 204560, 204528, 121948, 74646, 136811…
# $ uri           <chr> "https://dadosabertos.camara.leg.br/api/v2/deputados/220593", "https:…
# $ nome          <chr> "Abilio Brunini", "Acácio Favacho", "Adail Filho", "Adilson Barroso",…
# $ siglaPartido  <chr> "PL", "MDB", "REPUBLICANOS", "PL", "PSDB", "NOVO", "PP", "PSDB", "PP"…
# $ uriPartido    <chr> "https://dadosabertos.camara.leg.br/api/v2/partidos/37906", "https://…
# $ siglaUf       <chr> "MT", "AP", "AM", "SP", "BA", "SP", "GO", "MG", "RS", "RS", "PB", "PA…
# $ idLegislatura <int> 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 5…
# $ urlFoto       <chr> "https://www.camara.leg.br/internet/deputado/bandep/220593.jpg", "htt…
# $ email         <chr> "dep.abiliobrunini@camara.leg.br", "dep.acaciofavacho@camara.leg.br",…



# 3) Escolha um deputado ou deputada para consultar os detalhes,
# a partir de seu ID (coluna ID na tabela acima).


# 3a) quais informações conseguimos buscar nessa API sobre alguma 
# deputada/deputado específico(a)?


# 3b) Faça uma requisição para consultar quais foram as ocupações anteriores (trabalho)
# do deputado ou deputada escolhido(a).


# 3c) Faça uma requisição para consultar quais são as despesas recentes do deputado 
# ou deputada escolhido(a). Tramsforme a resposta em um data.frame/tibble.

