*** Settings ***
Documentation    Página de login: locators e ações do formulário de acesso.

Resource         ../common/browser.resource
Resource         ../keywords/form_keywords.resource
Resource         ../keywords/navigation_keywords.resource
Resource         ../variables/test_data.resource


*** Variables ***
${LOGIN_USERNAME_INPUT}    data-test=username
${LOGIN_PASSWORD_INPUT}    data-test=password
${LOGIN_BUTTON}            data-test=login-button
${LOGIN_ERROR_MESSAGE}     data-test=error


*** Keywords ***
Abrir Página De Login
    Acessar Rota    ${ROUTE_LOGIN}
    Validar Que A Página De Login Foi Carregada

Validar Que A Página De Login Foi Carregada
    Wait For Elements State    ${LOGIN_BUTTON}    visible
    Get Url    ==    ${BASE_URL}${ROUTE_LOGIN}

Preencher Usuário
    [Arguments]    ${username}
    Fill Text    ${LOGIN_USERNAME_INPUT}    ${username}

Preencher Senha
    [Arguments]    ${password}
    Preencher Campo Sigiloso    ${LOGIN_PASSWORD_INPUT}    ${password}

Submeter Login
    Click    ${LOGIN_BUTTON}

Fazer Login
    [Documentation]    Executa o fluxo completo de login.
    [Arguments]    ${username}    ${password}
    Preencher Usuário    ${username}
    Preencher Senha    ${password}
    Submeter Login

Fazer Login Com Credenciais
    [Documentation]    Recebe o dicionário retornado por "Obter Credenciais Do Usuário".
    [Arguments]    ${credentials}
    Fazer Login    ${credentials}[username]    ${credentials}[password]

A Mensagem De Erro Do Login Deve Ser
    [Arguments]    ${message}
    Get Text    ${LOGIN_ERROR_MESSAGE}    ==    ${message}

Não Deve Haver Mensagem De Erro No Login
    Get Element Count    ${LOGIN_ERROR_MESSAGE}    ==    0
