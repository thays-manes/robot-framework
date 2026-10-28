*** Settings ***
Documentation    Configuração central da Browser Library (Playwright) e do navegador.
...              - Um navegador por suíte, aberto em Suite Setup.
...              - Um contexto novo (cookies e storage isolados) por teste.
...              - Screenshot automático em qualquer falha (run_on_failure).

Resource         ../variables/environment_variables.resource
Library          Browser
...                  timeout=${TIMEOUT}
...                  run_on_failure=Take Screenshot
...                  strict=True


*** Keywords ***
Abrir Navegador
    [Documentation]    Abre o navegador definido em BROWSER (chromium, firefox ou webkit).
    Log    Ambiente: ${ENVIRONMENT} | URL: ${BASE_URL} | Navegador: ${BROWSER} | Headless: ${HEADLESS}
    New Browser    browser=${BROWSER}    headless=${HEADLESS}

Abrir Nova Sessão
    [Documentation]    Cria um contexto isolado e abre a aplicação na rota informada.
    [Arguments]    ${route}=/
    New Context    baseURL=${BASE_URL}    viewport=${VIEWPORT}
    New Page    ${BASE_URL}${route}

Capturar Tela
    [Documentation]    Registra um screenshot da página inteira no log.html.
    Take Screenshot    fullPage=True
