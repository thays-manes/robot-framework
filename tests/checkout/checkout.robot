*** Settings ***
Documentation     Fluxo de compra: carrinho, dados do comprador, resumo e confirmação.
...               Todos os cenários criam ou alteram pedidos, por isso têm a tag "destructive"
...               e são ignorados automaticamente no ambiente de produção.

Resource          ../../resources/common/setup_teardown.resource
Resource          ../../resources/keywords/authentication_keywords.resource
Resource          ../../resources/pages/cart_page.resource
Resource          ../../resources/pages/checkout_complete_page.resource
Resource          ../../resources/pages/checkout_information_page.resource
Resource          ../../resources/pages/checkout_overview_page.resource
Resource          ../../resources/pages/home_page.resource
Library           libraries.test_data_factory.TestDataFactory

Suite Setup       Iniciar Suíte
Suite Teardown    Finalizar Suíte
Test Setup        Acessar Página Inicial Autenticado
Test Teardown     Finalizar Teste

Test Tags         checkout    destructive    regression


*** Test Cases ***
Deve concluir uma compra de ponta a ponta com sucesso
    [Tags]    smoke    e2e
    Adicionar Os Produtos E Conferir O Carrinho    ${PRODUCT_BACKPACK}    ${PRODUCT_BIKE_LIGHT}
    Informar Os Dados Do Comprador
    Conferir O Resumo Do Pedido    ${PRODUCT_BACKPACK}    ${PRODUCT_BIKE_LIGHT}
    Finalizar E Validar A Confirmação Do Pedido
    Voltar Para A Página Inicial
    Validar Que A Página Inicial Foi Carregada

Deve calcular corretamente subtotal, taxa e total do pedido
    Adicionar Produtos Ao Carrinho    ${PRODUCT_BACKPACK}    ${PRODUCT_BOLT_TSHIRT}    ${PRODUCT_FLEECE_JACKET}
    Abrir Carrinho
    Validar Que O Carrinho Foi Carregado
    ${cart_prices}=    Obter Preços Dos Itens
    Informar Os Dados Do Comprador
    Validar Que O Resumo Do Pedido Foi Carregado
    Os Preços Do Resumo Devem Ser Iguais Aos Do Carrinho    ${cart_prices}
    Os Valores Do Pedido Devem Estar Corretos    ${cart_prices}

Deve remover um produto do carrinho antes do checkout
    Adicionar Produtos Ao Carrinho    ${PRODUCT_BACKPACK}    ${PRODUCT_BOLT_TSHIRT}
    Abrir Carrinho
    Validar Que O Carrinho Foi Carregado
    Remover Item Do Carrinho    ${PRODUCT_BOLT_TSHIRT}
    A Quantidade De Itens Deve Ser    1
    Os Itens Devem Ser    ${PRODUCT_BACKPACK}
    O Contador Do Carrinho Deve Ser    1

Deve voltar ao carrinho ao cancelar o checkout
    Adicionar Produtos Ao Carrinho    ${PRODUCT_BACKPACK}
    Abrir Carrinho
    Validar Que O Carrinho Foi Carregado
    Iniciar Checkout
    Cancelar Checkout
    Validar Que O Carrinho Foi Carregado
    A Quantidade De Itens Deve Ser    1

Deve exigir o preenchimento do nome do comprador
    [Tags]    validation    negative
    [Template]    Validar Campo Obrigatório Do Comprador
    first_name    ${MSG_FIRST_NAME_REQUIRED}

Deve exigir o preenchimento do sobrenome do comprador
    [Tags]    validation    negative
    [Template]    Validar Campo Obrigatório Do Comprador
    last_name    ${MSG_LAST_NAME_REQUIRED}

Deve exigir o preenchimento do CEP do comprador
    [Tags]    validation    negative
    [Template]    Validar Campo Obrigatório Do Comprador
    postal_code    ${MSG_POSTAL_CODE_REQUIRED}


*** Keywords ***
Adicionar Os Produtos E Conferir O Carrinho
    [Arguments]    @{products}
    Adicionar Produtos Ao Carrinho    @{products}
    ${quantity}=    Get Length    ${products}
    O Contador Do Carrinho Deve Ser    ${quantity}
    Abrir Carrinho
    Validar Que O Carrinho Foi Carregado
    Os Itens Devem Ser    @{products}

Informar Os Dados Do Comprador
    [Documentation]    Inicia o checkout a partir do carrinho e envia dados gerados para o comprador.
    Iniciar Checkout
    Validar Que Os Dados Do Comprador Foram Solicitados
    ${customer}=    Gerar Dados Do Comprador
    Informar Dados Do Comprador E Continuar    ${customer}

Conferir O Resumo Do Pedido
    [Arguments]    @{products}
    Validar Que O Resumo Do Pedido Foi Carregado
    Os Itens Devem Ser    @{products}
    Validar Informações De Pagamento E Entrega

Finalizar E Validar A Confirmação Do Pedido
    Finalizar Pedido
    Validar Confirmação Do Pedido
    O Carrinho Deve Estar Vazio

Os Preços Do Resumo Devem Ser Iguais Aos Do Carrinho
    [Arguments]    ${cart_prices}
    ${overview_prices}=    Obter Preços Dos Itens
    Lists Should Be Equal    ${overview_prices}    ${cart_prices}

Os Valores Do Pedido Devem Estar Corretos
    [Documentation]    Subtotal = soma dos itens; total = subtotal + taxa.
    [Arguments]    ${item_prices}
    ${expected_subtotal}=    Somar Preços    ${item_prices}
    ${subtotal}=    Obter Subtotal Do Pedido
    ${tax}=    Obter Taxa Do Pedido
    ${total}=    Obter Total Do Pedido
    ${expected_total}=    Somar Preços    ${subtotal}    ${tax}
    Should Be Equal    ${subtotal}    ${expected_subtotal}
    Should Be True    $tax > 0
    Should Be Equal    ${total}    ${expected_total}

Validar Campo Obrigatório Do Comprador
    [Documentation]    Deixa um campo do comprador vazio e verifica a mensagem de erro.
    [Arguments]    ${empty_field}    ${expected_message}
    Adicionar Produto Ao Carrinho    ${PRODUCT_BACKPACK}
    Abrir Carrinho
    Validar Que O Carrinho Foi Carregado
    Iniciar Checkout
    ${customer}=    Gerar Dados Do Comprador Sem O Campo    ${empty_field}
    Informar Dados Do Comprador E Continuar    ${customer}
    A Mensagem De Erro Do Checkout Deve Ser    ${expected_message}
    Validar Que Os Dados Do Comprador Foram Solicitados
