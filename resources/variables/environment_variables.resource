*** Settings ***
Documentation    Configuração do ambiente de execução (URL, navegador, modo headless e timeout).
...              Os valores vêm de config/environments.py, que lê o .env e as variáveis do sistema.
...              Qualquer valor pode ser sobrescrito com --variable NOME:valor na linha de comando.

Variables        ../../config/environments.py    ${TEST_ENV}


*** Variables ***
# Ambiente alvo: demo | dev | qa | hml | prod. Vazio usa TEST_ENV do .env (padrão: demo).
${TEST_ENV}    ${EMPTY}
