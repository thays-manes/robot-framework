*** Settings ***
Documentation     Página inicial (catálogo de produtos) com usuário autenticado.

Resource          ../../resources/common/setup_teardown.resource
Resource          ../../resources/keywords/authentication_keywords.resource
Resource          ../../resources/pages/home_page.resource

Suite Setup       Iniciar Suíte
Suite Teardown    Finalizar Suíte
Test Setup        Acessar Página Inicial Autenticado
Test Teardown     Finalizar Teste

Test Tags         home    regression


*** Test Cases ***
Deve carregar os elementos principais da página inicial
    [Tags]    smoke
    Validar Elementos Principais Da Página Inicial

Deve atualizar o contador do carrinho ao adicionar e remover produtos
    [Tags]    destructive
    O Carrinho Deve Estar Vazio
    Adicionar Produtos Ao Carrinho    ${PRODUCT_BACKPACK}    ${PRODUCT_BIKE_LIGHT}
    O Contador Do Carrinho Deve Ser    2
    Remover Produto Do Catálogo    ${PRODUCT_BACKPACK}
    O Contador Do Carrinho Deve Ser    1

Deve ordenar os produtos por preço crescente
    Ordenar Produtos Por    ${SORT_PRICE_ASC}
    ${prices}=    Obter Preços Dos Produtos
    A Lista Deve Estar Ordenada    ${prices}    crescente

Deve ordenar os produtos por nome de Z a A
    Ordenar Produtos Por    ${SORT_NAME_DESC}
    ${names}=    Obter Nomes Dos Produtos
    A Lista Deve Estar Ordenada    ${names}    decrescente
