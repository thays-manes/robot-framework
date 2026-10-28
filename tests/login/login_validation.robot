*** Settings ***
Documentation     Validações do formulário de login e proteção de páginas internas.

Resource          ../../resources/common/setup_teardown.resource
Resource          ../../resources/pages/home_page.resource
Resource          ../../resources/pages/login_page.resource
Library           libraries.test_data_factory.TestDataFactory

Suite Setup       Iniciar Suíte
Suite Teardown    Finalizar Suíte
Test Setup        Iniciar Teste    ${ROUTE_LOGIN}
Test Teardown     Finalizar Teste

Test Tags         login    validation    negative    regression


*** Test Cases ***
Deve exibir erro para credenciais inválidas
    [Tags]    smoke
    ${credentials}=    Gerar Credenciais Inválidas
    Fazer Login Com Credenciais    ${credentials}
    A Mensagem De Erro Do Login Deve Ser    ${MSG_INVALID_CREDENTIALS}
    Validar Que A Página De Login Foi Carregada

Deve validar o preenchimento do usuário obrigatório
    Fazer Login    ${EMPTY}    ${ANY_PASSWORD}
    A Mensagem De Erro Do Login Deve Ser    ${MSG_USERNAME_REQUIRED}

Deve validar o preenchimento da senha obrigatória
    Fazer Login    ${ANY_USERNAME}    ${EMPTY}
    A Mensagem De Erro Do Login Deve Ser    ${MSG_PASSWORD_REQUIRED}

Deve impedir o acesso direto à página interna sem autenticação
    Abrir Página Inicial
    Validar Que A Página De Login Foi Carregada
    A Mensagem De Erro Do Login Deve Ser    ${MSG_PROTECTED_INVENTORY}
