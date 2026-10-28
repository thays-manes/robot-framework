*** Settings ***
Documentation    Leitura de listas de elementos, usada por catálogo, carrinho e resumo do pedido.

Resource         ../common/browser.resource
Library          Collections
Library          libraries.price_library.PriceLibrary


*** Keywords ***
Montar Seletor Do Botão Do Produto
    [Documentation]    Retorna o seletor de um botão dentro do card do produto, identificando o card
    ...    pelo nome exato do produto (catálogo, carrinho e resumo usam a mesma estrutura).
    [Arguments]    ${product}    ${button_name}
    VAR    ${card}
    ...    css=[data-test="inventory-item"]:has([data-test="inventory-item-name"]:text-is("${product}"))
    RETURN    ${card} >> role=button[name="${button_name}"]

Obter Textos Dos Elementos
    [Documentation]    Retorna o texto de todos os elementos que correspondem ao seletor.
    [Arguments]    ${locator}
    ${elements}=    Get Elements    ${locator}
    VAR    @{texts}    @{EMPTY}
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        Append To List    ${texts}    ${text}
    END
    RETURN    ${texts}

Obter Preços Dos Elementos
    [Documentation]    Retorna os valores numéricos de uma lista de preços (ex.: "$29.99" -> 29.99).
    [Arguments]    ${locator}
    ${texts}=    Obter Textos Dos Elementos    ${locator}
    ${prices}=    Converter Textos Em Preços    ${texts}
    RETURN    ${prices}
