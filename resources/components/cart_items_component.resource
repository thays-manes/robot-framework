*** Settings ***
Documentation    Lista de produtos exibida no carrinho e no resumo do pedido.

Resource         ../common/browser.resource
Resource         ../keywords/element_keywords.resource


*** Variables ***
${CART_ITEMS}          data-test=inventory-item
${CART_ITEM_NAMES}     data-test=inventory-item-name
${CART_ITEM_PRICES}    data-test=inventory-item-price


*** Keywords ***
Obter Nomes Dos Itens
    ${names}=    Obter Textos Dos Elementos    ${CART_ITEM_NAMES}
    RETURN    ${names}

Obter Preços Dos Itens
    ${prices}=    Obter Preços Dos Elementos    ${CART_ITEM_PRICES}
    RETURN    ${prices}

Os Itens Devem Ser
    [Documentation]    Compara os produtos listados, na ordem, com os esperados.
    [Arguments]    @{expected_products}
    ${names}=    Obter Nomes Dos Itens
    Lists Should Be Equal    ${names}    ${expected_products}

A Quantidade De Itens Deve Ser
    [Arguments]    ${quantity}
    Get Element Count    ${CART_ITEMS}    ==    ${quantity}
