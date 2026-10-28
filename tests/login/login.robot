*** Settings ***
Documentation     Login com usuários cadastrados na aplicação.

Resource          ../../resources/common/setup_teardown.resource
Resource          ../../resources/components/menu_component.resource
Resource          ../../resources/pages/home_page.resource
Resource          ../../resources/pages/login_page.resource

Suite Setup       Iniciar Suíte
Suite Teardown    Finalizar Suíte
Test Setup        Iniciar Teste    ${ROUTE_LOGIN}
Test Teardown     Finalizar Teste

Test Tags         login    regression


*** Test Cases ***
Deve permitir acesso com credenciais válidas
    [Tags]    smoke    positive
    Exigir Usuário Configurado    standard
    ${credentials}=    Obter Credenciais Do Usuário    standard
    Fazer Login Com Credenciais    ${credentials}
    Validar Que A Página Inicial Foi Carregada
    Não Deve Haver Mensagem De Erro No Login

Deve bloquear o acesso de usuário bloqueado
    [Tags]    negative
    Exigir Usuário Configurado    locked_out
    ${credentials}=    Obter Credenciais Do Usuário    locked_out
    Fazer Login Com Credenciais    ${credentials}
    A Mensagem De Erro Do Login Deve Ser    ${MSG_LOCKED_OUT}
    Validar Que A Página De Login Foi Carregada

Deve encerrar a sessão ao fazer logout
    [Tags]    positive
    Exigir Usuário Configurado    standard
    ${credentials}=    Obter Credenciais Do Usuário    standard
    Fazer Login Com Credenciais    ${credentials}
    Validar Que A Página Inicial Foi Carregada
    Fazer Logout
    Validar Que A Página De Login Foi Carregada
