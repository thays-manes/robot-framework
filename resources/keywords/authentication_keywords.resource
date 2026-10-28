*** Settings ***
Documentation    Fluxos de autenticação reutilizados como pré-condição em várias suítes.

Resource         ../common/setup_teardown.resource
Resource         ../pages/home_page.resource
Resource         ../pages/login_page.resource


*** Keywords ***
Acessar Página Inicial Autenticado
    [Documentation]    Test Setup para cenários que começam logados com o usuário padrão.
    Iniciar Teste    ${ROUTE_LOGIN}
    Exigir Usuário Configurado    standard
    ${credentials}=    Obter Credenciais Do Usuário    standard
    Fazer Login Com Credenciais    ${credentials}
    Validar Que A Página Inicial Foi Carregada
