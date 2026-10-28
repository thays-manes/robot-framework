*** Settings ***
Documentation    Página do carrinho.

Resource         ../common/browser.resource
Resource         ../components/cart_items_component.resource
Resource         ../components/header_component.resource
Resource         ../keywords/wait_keywords.resource
Resource         ../variables/test_data.resource


*** Variables ***
${CART_CONTINUE_SHOPPING_BUTTON}    data-test=continue-shopping
${CART_CHECKOUT_BUTTON}             data-test=checkout


*** Keywords ***
Validar Que O Carrinho Foi Carregado
    Aguardar Página Com Título    ${TITLE_CART}

Remover Item Do Carrinho
    [Arguments]    ${product}
    ${button}=    Montar Seletor Do Botão Do Produto    ${product}    Remove
    Click    ${button}

Continuar Comprando
    Click    ${CART_CONTINUE_SHOPPING_BUTTON}

Iniciar Checkout
    Click    ${CART_CHECKOUT_BUTTON}
