*** Settings ***
Documentation    Checkout, etapa 1 de 3: dados do comprador.

Resource         ../common/browser.resource
Resource         ../keywords/form_keywords.resource
Resource         ../keywords/wait_keywords.resource
Resource         ../variables/test_data.resource


*** Variables ***
${CHECKOUT_FIRST_NAME_INPUT}     data-test=firstName
${CHECKOUT_LAST_NAME_INPUT}      data-test=lastName
${CHECKOUT_POSTAL_CODE_INPUT}    data-test=postalCode
${CHECKOUT_CONTINUE_BUTTON}      data-test=continue
${CHECKOUT_CANCEL_BUTTON}        data-test=cancel
${CHECKOUT_ERROR_MESSAGE}        data-test=error


*** Keywords ***
Validar Que Os Dados Do Comprador Foram Solicitados
    Aguardar Página Com Título    ${TITLE_CHECKOUT_INFORMATION}

Preencher Dados Do Comprador
    [Documentation]    Recebe o dicionário retornado por "Gerar Dados Do Comprador".
    [Arguments]    ${customer}
    VAR    &{fields}
    ...    ${CHECKOUT_FIRST_NAME_INPUT}=${customer}[first_name]
    ...    ${CHECKOUT_LAST_NAME_INPUT}=${customer}[last_name]
    ...    ${CHECKOUT_POSTAL_CODE_INPUT}=${customer}[postal_code]
    Preencher Campos Do Formulário    ${fields}

Continuar Para O Resumo
    Click    ${CHECKOUT_CONTINUE_BUTTON}

Informar Dados Do Comprador E Continuar
    [Arguments]    ${customer}
    Preencher Dados Do Comprador    ${customer}
    Continuar Para O Resumo

Cancelar Checkout
    Click    ${CHECKOUT_CANCEL_BUTTON}

A Mensagem De Erro Do Checkout Deve Ser
    [Arguments]    ${message}
    Get Text    ${CHECKOUT_ERROR_MESSAGE}    ==    ${message}
