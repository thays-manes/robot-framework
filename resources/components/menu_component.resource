*** Settings ***
Documentation    Menu lateral (hambúrguer), disponível em todas as páginas autenticadas.

Resource         ../common/browser.resource


*** Variables ***
${MENU_OPEN_BUTTON}       id=react-burger-menu-btn
${MENU_CLOSE_BUTTON}      id=react-burger-cross-btn
${MENU_ALL_ITEMS_LINK}    data-test=inventory-sidebar-link
${MENU_LOGOUT_LINK}       data-test=logout-sidebar-link
${MENU_RESET_LINK}        data-test=reset-sidebar-link


*** Keywords ***
Abrir Menu Lateral
    Click    ${MENU_OPEN_BUTTON}
    Wait For Elements State    ${MENU_LOGOUT_LINK}    visible

Fechar Menu Lateral
    Click    ${MENU_CLOSE_BUTTON}
    Wait For Elements State    ${MENU_LOGOUT_LINK}    hidden

Fazer Logout
    Abrir Menu Lateral
    Click    ${MENU_LOGOUT_LINK}

Restaurar Estado Da Aplicação
    Abrir Menu Lateral
    Click    ${MENU_RESET_LINK}
    Fechar Menu Lateral
