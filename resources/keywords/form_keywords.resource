*** Settings ***
Documentation    Operações genéricas de formulário, usadas por qualquer página que tenha campos.
...              A página informa QUAIS campos existem; aqui fica COMO preenchê-los.

Resource         ../common/browser.resource


*** Keywords ***
Preencher Campos Do Formulário
    [Documentation]    Preenche cada campo do dicionário {seletor: valor}, na ordem informada.
    ...    Valores vazios limpam o campo, o que permite testar campos obrigatórios.
    [Arguments]    ${fields}
    FOR    ${locator}    ${value}    IN    &{fields}
        Fill Text    ${locator}    ${value}
    END

Preencher Campo Sigiloso
    [Documentation]    Preenche senhas sem expor o valor no log.html.
    [Arguments]    ${locator}    ${secret}
    Fill Secret    ${locator}    $secret
