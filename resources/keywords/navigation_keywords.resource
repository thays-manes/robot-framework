*** Settings ***
Documentation    Navegação reutilizada entre fluxos.

Resource         ../common/browser.resource


*** Keywords ***
Acessar Rota
    [Documentation]    Navega para uma rota relativa à BASE_URL (ex.: /inventory.html).
    [Arguments]    ${route}
    Go To    ${BASE_URL}${route}
