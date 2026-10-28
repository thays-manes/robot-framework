*** Settings ***
Documentation    Checkout, etapa 2 de 3: resumo do pedido com itens e valores.

Resource         ../common/browser.resource
Resource         ../components/cart_items_component.resource
Resource         ../keywords/wait_keywords.resource
Resource         ../variables/test_data.resource
Library          libraries.price_library.PriceLibrary


*** Variables ***
${OVERVIEW_PAYMENT_INFO}     data-test=payment-info-value
${OVERVIEW_SHIPPING_INFO}    data-test=shipping-info-value
${OVERVIEW_SUBTOTAL}         data-test=subtotal-label
${OVERVIEW_TAX}              data-test=tax-label
${OVERVIEW_TOTAL}            data-test=total-label
${OVERVIEW_FINISH_BUTTON}    data-test=finish


*** Keywords ***
Validar Que O Resumo Do Pedido Foi Carregado
    Aguardar Página Com Título    ${TITLE_CHECKOUT_OVERVIEW}

Validar Informações De Pagamento E Entrega
    Get Text    ${OVERVIEW_PAYMENT_INFO}    !=    ${EMPTY}
    Get Text    ${OVERVIEW_SHIPPING_INFO}    !=    ${EMPTY}

Obter Subtotal Do Pedido
    ${text}=    Get Text    ${OVERVIEW_SUBTOTAL}
    ${value}=    Converter Texto Em Preço    ${text}
    RETURN    ${value}

Obter Taxa Do Pedido
    ${text}=    Get Text    ${OVERVIEW_TAX}
    ${value}=    Converter Texto Em Preço    ${text}
    RETURN    ${value}

Obter Total Do Pedido
    ${text}=    Get Text    ${OVERVIEW_TOTAL}
    ${value}=    Converter Texto Em Preço    ${text}
    RETURN    ${value}

Finalizar Pedido
    Click    ${OVERVIEW_FINISH_BUTTON}
