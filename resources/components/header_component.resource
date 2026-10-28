*** Settings ***
Documentation    Cabeçalho exibido em todas as páginas autenticadas: logo, menu e carrinho.

Resource         ../common/browser.resource
Resource         ../variables/test_data.resource


*** Variables ***
${HEADER_LOGO}           css=.app_logo
${HEADER_MENU_BUTTON}    id=react-burger-menu-btn
${HEADER_CART_LINK}      data-test=shopping-cart-link
${HEADER_CART_BADGE}     data-test=shopping-cart-badge


*** Keywords ***
Validar Cabeçalho
    Get Text    ${HEADER_LOGO}    ==    ${APP_TITLE}
    Wait For Elements State    ${HEADER_MENU_BUTTON}    visible
    Wait For Elements State    ${HEADER_CART_LINK}    visible

Abrir Carrinho
    Click    ${HEADER_CART_LINK}

O Contador Do Carrinho Deve Ser
    [Documentation]    Aceita a quantidade como texto ou número (ex.: retorno de Get Length).
    [Arguments]    ${quantity}
    ${expected}=    Convert To String    ${quantity}
    Get Text    ${HEADER_CART_BADGE}    ==    ${expected}

O Carrinho Deve Estar Vazio
    Get Element Count    ${HEADER_CART_BADGE}    ==    0
