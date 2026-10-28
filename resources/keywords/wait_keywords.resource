*** Settings ***
Documentation    Esperas baseadas em condições reais da interface.
...              A Browser Library já espera automaticamente antes de cada ação;
...              use estas keywords apenas para confirmar que uma página terminou de carregar.
...              Nunca use Sleep como estratégia de sincronização.

Resource         ../common/browser.resource


*** Variables ***
${PAGE_TITLE}    data-test=title


*** Keywords ***
Aguardar Página Com Título
    [Documentation]    Espera o título da página (canto superior esquerdo) exibir o texto informado.
    [Arguments]    ${title}
    Wait For Elements State    ${PAGE_TITLE}    visible
    Get Text    ${PAGE_TITLE}    ==    ${title}
