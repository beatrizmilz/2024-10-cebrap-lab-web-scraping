
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cebrap.lab online - Raspagem de dados com R

Para saber de próximos oferecimentos, entre em contato com
<cebrap.lab@cebrap.org.br>

## Informações gerais

- **Ministrante:** [Beatriz Milz](https://beamilz.com/about/)

- **Data/horário:** 21 a 25 de outubro/2024;

  - Segunda, Quarta e Sexta: aula ao vivo, online, das 19h00 às 22h00.
  - Terça e quinta: haverão tarefas para casa, para praticar os
    conceitos.

- **Inscrições:**
  <https://cursos.cebrap.org.br/cursos/raspagem-de-dados-com-r/>

## Descrição

O curso “Raspagem de dados com R” abordará uma introdução ao uso da
linguagem de programação R para obter dados da internet através de uma
técnica chamada raspagem de dados (web scraping).

O curso abordará conceitos relevantes, como:

- o que é raspagem de dados?;

- política de uso;

- tipos de problemas de raspagem (APIs (disponíveis e “escondidas”);

- raspagem de HTML (estático e dinâmico), etc);

- entre outros.

O curso apresentará exemplos de raspagem de dados em todas as aulas,
raspando sites que são interessantes no contexto brasileiro!

Todas as ferramentas utilizadas são gratuitas: utilizaremos a linguagem
de programação R, o RStudio, e os pacotes tidyverse, httr, rvest, xml2,
purrr, entre outros.

O curso tem como **público alvo** pessoasque tenham interesse em obter
dados através da técnica de raspagem de dados na internet utilizando R,
e que tenham familiaridade fazendo as seguintes tarefas em R: importar
bases de dados, filtrar linhas, selecionar colunas, agrupar a base,
criar sumarizações, criar novas colunas (pacotes readr e dplyr do
tidyverse).

## Materiais

- [Pasta compactada (`.zip`) com materiais do curso: scripts, dados,
  slides, exercícios,
  etc.](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/archive/refs/heads/main.zip)

### Slides

- [Slide de apresentação do
  curso](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/introducao-ao-curso.html)

- [APIs](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/api.html)

- [Raspando informações de páginas HTML
  estáticos](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/html-estatico.html)

- [Raspando informações de páginas HTML
  dinâmicos](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/html-dinamico.html)

### Scripts pós aula

| link |
|:---|
| [01-api-documentada.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/01-api-documentada.R) |
| [02-api-escondida.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/02-api-escondida.R) |
| [03-api-autenticacao.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/03-api-autenticacao.R) |
| [04-iteracao.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/04-iteracao.R) |
| [05-html-exemplo.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/05-html-exemplo.R) |
| [06-html-chancedegol.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/06-html-chancedegol.R) |
| [07-html-wiki.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/07-html-wiki.R) |
| [08-scielo.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/08-scielo.R) |
| [09-intro-selenium.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/09-intro-selenium.R) |
| [10-selenium-pbi.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/10-selenium-pbi.R) |

### Exercícios

- [Exercício para
  terça-feira](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/exercicios/01-exercicios-terca.R)

- [Exercício para
  quinta-feira](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/exercicios/02-exercicios-quinta.R)

## Links citados em aula

    #> ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.
    #> Rows: 46 Columns: 3
    #> ── Column specification ────────────────────────────────────────────────────────
    #> Delimiter: ";"
    #> chr (3): Dia, Material, Link
    #> 
    #> ℹ Use `spec()` to retrieve the full column specification for this data.
    #> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

| Dia | Material |
|:---|:---|
| 0 - Geral | [Repositório do GitHub](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping) |
| 0 - Geral | [Página com materiais](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/) |
| 1 - Segunda | [Slide de introdução ao curso](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/introducao-ao-curso.html#/) |
| 1 - Segunda | [Slide - Conhecendo APIs](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/api.html#/) |
| 1 - Segunda | [Comentário - Tese de doutorado sobre quebra de captchas](https://jtrecenti.github.io/doutorado/metodologia.html) |
| 1 - Segunda | [API - Brasil API](https://brasilapi.com.br/docs#tag/CEP-V2) |
| 1 - Segunda | [Exemplo de termos de uso que não permitem scraping](https://tripadvisor.mediaroom.com/BR-terms-of-use#_PROHIBITED_ACTIVITIES) |
| 1 - Segunda | [Exemplo de arquivo robots.txt](https://www.tripadvisor.com.br/robots.txt) |
| 1 - Segunda | [API - Olho Vivo - Ônibus de SP - Referência](https://www.sptrans.com.br/desenvolvedores/api-do-olho-vivo-guia-de-referencia/) |
| 1 - Segunda | [API - Olho Vivo - Ônibus de SP - Documentação](https://www.sptrans.com.br/desenvolvedores/api-do-olho-vivo-guia-de-referencia/documentacao-api/#docApi-posicao) |
| 1 - Segunda | [API - Datajud - Documentação](https://datajud-wiki.cnj.jus.br/) |
| 1 - Segunda | [Texto: Como usar senhas sem escreve-las nos scripts](https://beamilz.com/posts/2022-09-13-nao-guarde-senhas-no-script/pt/index.html) |
| 1 - Segunda | [Script 01-api-documentada.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/01-api-documentada.R) |
| 1 - Segunda | [Script 03-api-autenticacao.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/03-api-autenticacao.R) |
| 1 - Segunda | [Script 04-iteracao.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/04-iteracao.R) |
| 2 - Terça | [Exercício para terça-feira](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/exercicios/01-exercicios-terca.R) |
| 2 - Terça | [Leitura para terça-feira: 24.1 Introdução e 24.2 Ética e legalidade da raspagem de dados](https://cienciadedatos.github.io/pt-r4ds/webscraping.html) |
| 3 - Quarta | [Slide - Raspando informações de páginas HTML estáticas](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/html-estatico.html#/) |
| 3 - Quarta | [API citada nas dúvidas iniciais: reddit](https://www.reddit.com/dev/api/) |
| 3 - Quarta | [Exemplo API escondida - ANVISA](https://antigo.anvisa.gov.br/consultas-publicas#/) |
| 3 - Quarta | [APIs da Embrapa - exemplo de API freemium](https://www.agroapi.cnptia.embrapa.br/portal/) |
| 3 - Quarta | [Site citado: base dos dados](https://basedosdados.org/) |
| 3 - Quarta | [Script 02-api-escondida.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/02-api-escondida.R) |
| 3 - Quarta | [Script 05-html-exemplo.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/05-html-exemplo.R) |
| 3 - Quarta | [Script 06-html-chancedegol.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/06-html-chancedegol.R) |
| 3 - Quarta | [Script 07-html-wki.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/07-html-wiki.R) |
| 4 - Quinta | [Leitura para quinta-feira: 24.3 O básico de HTML até 24.6 Juntando tudo](https://cienciadedatos.github.io/pt-r4ds/webscraping.html) |
| 4 - Quinta | [Exercício para quinta-feira](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/exercicios/02-exercicios-quinta.R) |
| 5 - Sexta | [Slide - Raspando informações de páginas HTML dinâmicas](https://beatrizmilz.github.io/2024-10-cebrap-lab-web-scraping/slides/html-dinamico.html#/) |
| 5 - Sexta | [Extra: GitHub Actions. Post: Introdução ao GitHub Actions para quem programa em R](https://beamilz.com/posts/series-gha/2022-series-gha-1-what-is/pt/index.html) |
| 5 - Sexta | [Extra: GitHub Actions. Atividade em Português](https://beamilz.com/talks/pt/2021-github-actions-gyn/) |
| 5 - Sexta | [Extra: GitHub Actions. Atividade em inglês](https://beatrizmilz.github.io/2022-gha-rladies-abuja/hands-on.html) |
| 5 - Sexta | [Exemplo de repositório de raspador com GitHub Actions](https://github.com/beatrizmilz/scieloPeriodicos) |
| 5 - Sexta | [Extra (dúvidas): OCR no R - Pacote Tesseract](https://cran.r-project.org/web/packages/tesseract/vignettes/intro.html) |
| 5 - Sexta | [Extra (dúvidas): OCR no R - Pacote pdftools](https://docs.ropensci.org/pdftools/reference/pdf_ocr.html) |
| 5 - Sexta | [Repositório com materiais do curso do Julio Trecenti (o material é aberto)](https://github.com/curso-r/gravado-web-scraping) |
| 5 - Sexta | [Notícia comentada: Jornalista é acusado de ser hacker em CPI (abraji)](https://www.abraji.org.br/noticias/abraji-condena-acusacoes-infundadas-e-caluniosas-contra-reporter) |
| 5 - Sexta | [Notícia comentada: Jornalista é acusado de ser hacker em CPI (uol)](https://noticias.uol.com.br/politica/ultimas-noticias/2021/05/25/apos-dizer-que-jornalista-hackeou-app-mayra-nega-invasao-ao-tretecov.htm) |
| 5 - Sexta | [PBI exemplo selenium](https://justica-em-numeros.cnj.jus.br/painel-estatisticas/) |
| 5 - Sexta | [Lista de opções possíveis para header quando fazemos uma requisição](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields) |
| 5 - Sexta | [Exemplo API do CKAN - Dados abertos PMSP](http://dados.prefeitura.sp.gov.br/api/3/action/package_show?id=empenhos-orcamentarios-covid-19) |
| 5 - Sexta | [Script 08-scielo.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/08-scielo.R) |
| 5 - Sexta | [Script 09-intro-selenium.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/09-intro-selenium.R) |
| 5 - Sexta | [Script 10-selenium-pbi.R](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/blob/main/script-pos-aula/10-selenium-pbi.R) |
| 6 - Sábado (Extra/opcional) | [Leitura: 24.7 Sites Dinâmicos até 24.8 Resumo](https://cienciadedatos.github.io/pt-r4ds/webscraping.html) |
| 5 - Sexta | [Esboços das práticas sugeridas pela turma](https://github.com/beatrizmilz/2024-10-cebrap-lab-web-scraping/tree/main/praticas-sugeridas-pela-turma) |

## Materiais para revisão do conteúdo básico

- [Introdução à análise de dados no R - Utilizando dados públicos e
  registros administrativos
  brasileiros](https://ipeadata-lab.github.io/curso_r_intro_202409/)

- [Material do curso de Introdução ao R - 2024 (ministrado por Beatriz
  Milz)](https://beatrizmilz.github.io/2024-08-cebrap-lab-intro-R/)

- [Material do curso de Visualização de dados com R - 2024 (ministrado
  por Beatriz
  Milz)](https://beatrizmilz.github.io/2024-09-cebrap-lab-viz/)

- [Livro online, gratuito e em português: R for Data
  Science](https://cienciadedatos.github.io/pt-r4ds/)

- [Livro online e gratuito e em português: Ciência de Dados em
  R](https://livro.curso-r.com/7-2-dplyr.html)
