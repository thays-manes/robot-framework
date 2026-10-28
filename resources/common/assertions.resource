*** Settings ***
Documentation    Verificações reutilizadas por mais de uma página.
...              Para verificações simples, use direto as asserções da Browser Library
...              (ex.: Get Text    seletor    ==    texto).

Resource         browser.resource
Library          Collections


*** Keywords ***
A URL Atual Deve Ser A Rota
    [Arguments]    ${route}
    Get Url    ==    ${BASE_URL}${route}

A Lista Deve Estar Ordenada
    [Documentation]    Falha se a lista não estiver na ordem indicada (crescente ou decrescente).
    [Arguments]    ${values}    ${order}=crescente
    Should Not Be Empty    ${values}
    ${expected}=    Copy List    ${values}
    Sort List    ${expected}
    IF    '${order}' == 'decrescente'    Reverse List    ${expected}
    Lists Should Be Equal    ${values}    ${expected}
    ...    msg=A lista não está em ordem ${order}: ${values}
