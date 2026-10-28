*** Settings ***
Documentation    Dados fixos da aplicação sob teste: rotas, títulos, produtos e mensagens.
...              Dados dinâmicos são gerados por libraries/test_data_factory.py e
...              credenciais vêm de variáveis de ambiente (data/users.json).


*** Variables ***
# Rotas relativas à BASE_URL
${ROUTE_LOGIN}                   /
${ROUTE_INVENTORY}               /inventory.html
${ROUTE_CART}                    /cart.html
${ROUTE_CHECKOUT_INFORMATION}    /checkout-step-one.html
${ROUTE_CHECKOUT_OVERVIEW}       /checkout-step-two.html
${ROUTE_CHECKOUT_COMPLETE}       /checkout-complete.html

# Títulos exibidos no topo de cada página
${APP_TITLE}                     Swag Labs
${TITLE_INVENTORY}               Products
${TITLE_CART}                    Your Cart
${TITLE_CHECKOUT_INFORMATION}    Checkout: Your Information
${TITLE_CHECKOUT_OVERVIEW}       Checkout: Overview
${TITLE_CHECKOUT_COMPLETE}       Checkout: Complete!

# Produtos do catálogo
${PRODUCT_BACKPACK}              Sauce Labs Backpack
${PRODUCT_BIKE_LIGHT}            Sauce Labs Bike Light
${PRODUCT_BOLT_TSHIRT}           Sauce Labs Bolt T-Shirt
${PRODUCT_FLEECE_JACKET}         Sauce Labs Fleece Jacket

# Opções de ordenação do catálogo
${SORT_NAME_ASC}                 az
${SORT_NAME_DESC}                za
${SORT_PRICE_ASC}                lohi
${SORT_PRICE_DESC}               hilo

# Mensagens de login
${MSG_USERNAME_REQUIRED}         Epic sadface: Username is required
${MSG_PASSWORD_REQUIRED}         Epic sadface: Password is required
${MSG_INVALID_CREDENTIALS}       Epic sadface: Username and password do not match any user in this service
${MSG_LOCKED_OUT}                Epic sadface: Sorry, this user has been locked out.
${MSG_PROTECTED_INVENTORY}       Epic sadface: You can only access '/inventory.html' when you are logged in.

# Mensagens de checkout
${MSG_FIRST_NAME_REQUIRED}       Error: First Name is required
${MSG_LAST_NAME_REQUIRED}        Error: Last Name is required
${MSG_POSTAL_CODE_REQUIRED}      Error: Postal Code is required
${MSG_ORDER_COMPLETE}            Thank you for your order!

# Valores usados nos cenários de campos obrigatórios
${ANY_USERNAME}                  usuario_qualquer
${ANY_PASSWORD}                  senha_qualquer
