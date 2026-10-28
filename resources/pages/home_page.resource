*** Settings ***
Documentation    Página inicial após o login: catálogo de produtos.

Resource         ../common/browser.resource
Resource         ../common/assertions.resource
Resource         ../components/header_component.resource
Resource         ../keywords/element_keywords.resource
Resource         ../keywords/navigation_keywords.resource
Resource         ../keywords/wait_keywords.resource
Resource         ../variables/test_data.resource


*** Variables ***
${HOME_PRODUCT_ITEMS}     data-test=inventory-item
${HOME_PRODUCT_NAMES}     data-test=inventory-item-name
${HOME_PRODUCT_PRICES}    data-test=inventory-item-price
${HOME_SORT_SELECT}       data-test=product-sort-container


*** Keywords ***
Abrir Página Inicial
    Acessar Rota    ${ROUTE_INVENTORY}

Validar Que A Página Inicial Foi Carregada
    Aguardar Página Com Título    ${TITLE_INVENTORY}
    A URL Atual Deve Ser A Rota    ${ROUTE_INVENTORY}

Validar Elementos Principais Da Página Inicial
    Get Title    ==    ${APP_TITLE}
    Validar Cabeçalho
    Wait For Elements State    ${HOME_SORT_SELECT}    visible
    Get Element Count    ${HOME_PRODUCT_ITEMS}    >    0

Adicionar Produto Ao Carrinho
    [Arguments]    ${product}
    ${button}=    Montar Seletor Do Botão Do Produto    ${product}    Add to cart
    Click    ${button}

Remover Produto Do Catálogo
    [Arguments]    ${product}
    ${button}=    Montar Seletor Do Botão Do Produto    ${product}    Remove
    Click    ${button}

Adicionar Produtos Ao Carrinho
    [Arguments]    @{products}
    FOR    ${product}    IN    @{products}
        Adicionar Produto Ao Carrinho    ${product}
    END

Ordenar Produtos Por
    [Documentation]    Opções: az, za, lohi, hilo (veja test_data.resource).
    [Arguments]    ${option}
    Select Options By    ${HOME_SORT_SELECT}    value    ${option}

Obter Nomes Dos Produtos
    ${names}=    Obter Textos Dos Elementos    ${HOME_PRODUCT_NAMES}
    RETURN    ${names}

Obter Preços Dos Produtos
    ${prices}=    Obter Preços Dos Elementos    ${HOME_PRODUCT_PRICES}
    RETURN    ${prices}
