*** Settings ***
Documentation    Checkout, etapa 3 de 3: confirmação do pedido.

Resource         ../common/browser.resource
Resource         ../keywords/wait_keywords.resource
Resource         ../variables/test_data.resource


*** Variables ***
${COMPLETE_HEADER}              data-test=complete-header
${COMPLETE_TEXT}                data-test=complete-text
${COMPLETE_BACK_HOME_BUTTON}    data-test=back-to-products


*** Keywords ***
Validar Confirmação Do Pedido
    Aguardar Página Com Título    ${TITLE_CHECKOUT_COMPLETE}
    Get Text    ${COMPLETE_HEADER}    ==    ${MSG_ORDER_COMPLETE}
    Get Text    ${COMPLETE_TEXT}    !=    ${EMPTY}

Voltar Para A Página Inicial
    Click    ${COMPLETE_BACK_HOME_BUTTON}
