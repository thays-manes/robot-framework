*** Settings ***
Documentation    Preparação e finalização padrão de suítes e testes.
...              Use nas suítes:
...              Suite Setup    Iniciar Suíte
...              Suite Teardown    Finalizar Suíte
...              Test Setup    Iniciar Teste
...              Test Teardown    Finalizar Teste

Resource         browser.resource
Library          libraries.environment_library.EnvironmentLibrary


*** Keywords ***
Iniciar Suíte
    Abrir Navegador

Finalizar Suíte
    Close Browser    ALL

Iniciar Teste
    [Documentation]    Abre um contexto limpo na página informada.
    ...    Testes com a tag "destructive" nunca rodam em produção.
    [Arguments]    ${route}=/
    Skip If    $IS_PRODUCTION and 'destructive' in $TEST_TAGS
    ...    Teste destrutivo ignorado no ambiente de produção.
    Abrir Nova Sessão    ${route}

Finalizar Teste
    [Documentation]    Registra a tela final dos testes aprovados (as falhas já têm screenshot automático)
    ...    e fecha o contexto para isolar o próximo teste.
    Run Keyword If Test Passed    Capturar Tela
    Close Context

Exigir Usuário Configurado
    [Documentation]    Pula o teste com uma mensagem clara quando as credenciais do perfil não estão no .env.
    [Arguments]    ${profile}
    ${configured}=    Usuário Está Configurado    ${profile}
    Skip If    not $configured
    ...    Credenciais do perfil "${profile}" não configuradas. Preencha o .env (veja .env.example).
