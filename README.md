# Automação de Testes Web com Robot Framework + Browser Library

![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.5-000000?logo=robotframework&logoColor=white)
![Browser Library](https://img.shields.io/badge/Browser%20Library-20.6-2EAD33?logo=playwright&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.13-3776AB?logo=python&logoColor=white)

## 1. Objetivo

Projeto de automação de testes E2E com **Robot Framework** e **Browser Library** (Playwright), organizado
em uma arquitetura modular inspirada em **Page Objects**. Os cenários são escritos em português, como
especificações de negócio, e os detalhes técnicos ficam encapsulados em páginas, componentes e keywords.

A aplicação alvo é o [Sauce Demo](https://www.saucedemo.com), um e-commerce público criado para a prática de
automação de testes.

| Suíte | Cenários |
| --- | --- |
| Login | acesso válido, usuário bloqueado, logout |
| Validações de login | credenciais inválidas, usuário obrigatório, senha obrigatória, rota protegida |
| Página inicial | elementos principais, contador do carrinho, ordenação por preço e por nome |
| Checkout | **compra de ponta a ponta**, cálculo de subtotal/taxa/total, remoção de item, cancelamento, campos obrigatórios do comprador |

São 18 cenários, executados em **Chromium, Firefox e WebKit**.

## 2. Tecnologias utilizadas

| Tecnologia | Uso |
| --- | --- |
| [Python 3.13](https://www.python.org) | Linguagem base e bibliotecas personalizadas |
| [Robot Framework 7.5](https://robotframework.org) | Framework de testes orientado a keywords |
| [Browser Library 20.6](https://robotframework-browser.org) | Automação web com Playwright |
| [Pabot 5.2](https://pabot.org) | Execução paralela |
| [python-dotenv](https://pypi.org/project/python-dotenv/) | Leitura do arquivo `.env` |
| [Ruff](https://docs.astral.sh/ruff/) | Lint e formatação do código Python |
| [Robocop](https://robocop.readthedocs.io) | Lint e formatação dos arquivos `.robot` e `.resource` |

## 3. Pré-requisitos

- **Python 3.10 a 3.14**. Recomendado: 3.13. No Python 3.15, algumas dependências da Browser Library
  ainda não publicaram pacotes prontos (wheels) e a instalação falha.
- **Node.js 20 ou superior**, usado pela Browser Library para executar o Playwright.
- **Git**.

```bash
python --version
```

```bash
node --version
```

> **Windows:** se `python` abrir a Microsoft Store, use o inicializador `py` (ex.: `py -3.13`) ou desative o
> alias em *Configurações > Aplicativos > Configurações avançadas de aplicativos > Aliases de execução*.
> Para instalar o Python 3.13 pelo gerenciador oficial: `py install 3.13`.

## 4. Criar e ativar o ambiente virtual

Windows (PowerShell):

```powershell
py -3.13 -m venv .venv
```

```powershell
.\.venv\Scripts\Activate.ps1
```

Linux/macOS:

```bash
python3 -m venv .venv
```

```bash
source .venv/bin/activate
```

> Se o PowerShell bloquear a ativação, rode uma vez:
> `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

## 5. Instalar as dependências

```bash
python -m pip install --upgrade pip
```

Para executar os testes:

```bash
python -m pip install -r requirements.txt
```

Para desenvolver (inclui Ruff e Robocop):

```bash
python -m pip install -r requirements-dev.txt
```

## 6. Instalar os navegadores com `rfbrowser init`

Instala o Playwright e os navegadores Chromium, Firefox e WebKit usados pela Browser Library:

```bash
rfbrowser init
```

No Linux, os navegadores podem exigir bibliotecas do sistema:

```bash
npx playwright install-deps
```

## 7. Estrutura de diretórios

```text
robot_teste/
├── .github/workflows/robot.yml   # CI: qualidade + testes nos 3 navegadores
├── config/
│   ├── default.args              # Opções padrão do robot (--argumentfile)
│   └── environments.py           # Arquivo de variáveis: lê .env e escolhe o ambiente
├── data/
│   └── users.json                # Perfis de usuário (só os NOMES das variáveis de ambiente)
├── docs/
│   └── architecture.md           # Decisões arquiteturais
├── libraries/
│   ├── environment_library.py    # Credenciais a partir de variáveis de ambiente
│   ├── price_library.py          # Conversão e soma de preços com Decimal
│   └── test_data_factory.py      # Geração de dados dinâmicos
├── resources/
│   ├── common/
│   │   ├── assertions.resource       # Verificações compartilhadas
│   │   ├── browser.resource          # Importação e configuração da Browser Library
│   │   └── setup_teardown.resource   # Ciclo de vida de suítes e testes
│   ├── components/
│   │   ├── cart_items_component.resource  # Lista de itens (carrinho e resumo)
│   │   ├── header_component.resource      # Cabeçalho: logo, carrinho, menu
│   │   └── menu_component.resource        # Menu lateral: logout, reset
│   ├── keywords/
│   │   ├── authentication_keywords.resource  # Pré-condição "logado"
│   │   ├── element_keywords.resource         # Listas de textos e preços
│   │   ├── form_keywords.resource            # Preenchimento de formulários
│   │   ├── navigation_keywords.resource      # Navegação por rotas
│   │   └── wait_keywords.resource            # Espera por carregamento de página
│   ├── pages/
│   │   ├── cart_page.resource
│   │   ├── checkout_complete_page.resource
│   │   ├── checkout_information_page.resource
│   │   ├── checkout_overview_page.resource
│   │   ├── home_page.resource
│   │   └── login_page.resource
│   └── variables/
│       ├── environment_variables.resource  # Importa config/environments.py
│       └── test_data.resource              # Rotas, títulos, produtos e mensagens
├── tests/
│   ├── checkout/checkout.robot
│   ├── home/home.robot
│   └── login/
│       ├── login.robot
│       └── login_validation.robot
├── .env.example
├── pyproject.toml                # Configuração do Ruff e do Robocop
├── requirements.txt
└── requirements-dev.txt
```

`results/` é criada na execução e não é versionada.

## 8. Arquitetura Page Objects no Robot Framework

```text
tests/*.robot  ──►  pages/*.resource  ──►  components/*.resource
     │                    │
     │                    └──►  keywords/*.resource  ──►  common/browser.resource ──► Browser Library
     │
     └──►  common/setup_teardown.resource  (navegador por suíte, contexto por teste)
```

- **Testes** descrevem o comportamento esperado em linguagem de negócio, sem nenhum seletor.
- **Páginas** encapsulam os locators (variáveis em `*** Variables ***`) e as ações de uma tela.
- **Componentes** representam partes repetidas em várias páginas, como cabeçalho, menu e lista de itens.
- **Keywords genéricas** servem a qualquer página: navegação, formulário, leitura de listas e espera.
- **Bibliotecas Python** guardam apenas a lógica que fica melhor em Python.

Exemplo de cenário:

```robotframework
Deve concluir uma compra de ponta a ponta com sucesso
    [Tags]    smoke    e2e
    Adicionar Os Produtos E Conferir O Carrinho    ${PRODUCT_BACKPACK}    ${PRODUCT_BIKE_LIGHT}
    Informar Os Dados Do Comprador
    Conferir O Resumo Do Pedido    ${PRODUCT_BACKPACK}    ${PRODUCT_BIKE_LIGHT}
    Finalizar E Validar A Confirmação Do Pedido
    Voltar Para A Página Inicial
    Validar Que A Página Inicial Foi Carregada
```

As decisões completas estão em [docs/architecture.md](docs/architecture.md).

## 9. Responsabilidade de cada arquivo

| Arquivo | Responsabilidade |
| --- | --- |
| `common/browser.resource` | Importa a Browser Library (timeout, screenshot em falha, modo estrito) e abre navegador e contexto |
| `common/setup_teardown.resource` | `Iniciar Suíte`, `Finalizar Suíte`, `Iniciar Teste`, `Finalizar Teste`, `Exigir Usuário Configurado` |
| `common/assertions.resource` | `A URL Atual Deve Ser A Rota`, `A Lista Deve Estar Ordenada` |
| `keywords/navigation_keywords.resource` | `Acessar Rota` |
| `keywords/form_keywords.resource` | `Preencher Campos Do Formulário`, `Preencher Campo Sigiloso` |
| `keywords/wait_keywords.resource` | `Aguardar Página Com Título` |
| `keywords/element_keywords.resource` | Textos e preços de listas, seletor do botão de um produto |
| `keywords/authentication_keywords.resource` | `Acessar Página Inicial Autenticado` (Test Setup) |
| `pages/*.resource` | Locators, ações e validações de cada página |
| `components/*.resource` | Locators e ações de partes compartilhadas |
| `variables/environment_variables.resource` | Expõe `BASE_URL`, `BROWSER`, `HEADLESS`, `TIMEOUT`, `IS_PRODUCTION` |
| `variables/test_data.resource` | Rotas, títulos, produtos e mensagens esperadas |
| `config/environments.py` | Lê `.env`/variáveis do sistema e resolve o ambiente |
| `config/default.args` | Opções padrão: `--pythonpath .`, nível de log, xUnit e nome da suíte |
| `data/users.json` | Perfis `standard` e `locked_out` |
| `libraries/*.py` | Keywords em Python (credenciais, dados dinâmicos, preços) |

## 10. Configuração dos ambientes

Copie o arquivo de exemplo e preencha:

Windows:

```powershell
Copy-Item .env.example .env
```

Linux/macOS:

```bash
cp .env.example .env
```

| Variável | Descrição | Padrão |
| --- | --- | --- |
| `TEST_ENV` | `demo`, `dev`, `qa`, `hml` ou `prod` | `demo` |
| `BASE_URL` | URL do ambiente `demo` | `https://www.saucedemo.com` |
| `BASE_URL_DEV`, `BASE_URL_QA`, `BASE_URL_HML`, `BASE_URL_PROD` | URL dos demais ambientes | — |
| `TEST_USERNAME`, `TEST_PASSWORD` | Usuário padrão | — |
| `TEST_LOCKED_USERNAME` | Usuário bloqueado | — |
| `BROWSER` | `chromium`, `firefox` ou `webkit` | `chromium` |
| `HEADLESS` | `true` (sem janela) ou `false` | `true` |
| `TIMEOUT` | Espera máxima da Browser Library | `10s` |

No Sauce Demo, os usuários e a senha de demonstração aparecem na própria tela de login.

**Ordem de prioridade:** `--variable` na linha de comando > variáveis do sistema > `.env` > padrão.

- O Robot Framework não lê `.env` sozinho. Quem faz isso é o `config/environments.py`, com `python-dotenv`.
- Sem credenciais, os testes que precisam de login são marcados como **SKIP** com uma mensagem explicativa.
- Testes com a tag `destructive` são ignorados automaticamente quando `TEST_ENV=prod`.
- O `.env` está no `.gitignore`. **Nunca versione credenciais.**

## 11. Como executar os testes

Sempre a partir da raiz do projeto, com o ambiente virtual ativado.

Toda a suíte:

```bash
python -m robot --argumentfile config/default.args --outputdir results tests
```

Um arquivo específico:

```bash
python -m robot --argumentfile config/default.args --outputdir results tests/login/login.robot
```

Uma pasta específica:

```bash
python -m robot --argumentfile config/default.args --outputdir results tests/checkout
```

Um teste pelo nome (aceita `*` como curinga):

```bash
python -m robot --argumentfile config/default.args --outputdir results --test "Deve concluir uma compra*" tests
```

Outro navegador:

```bash
python -m robot --argumentfile config/default.args --outputdir results --variable BROWSER:firefox tests
```

Outro ambiente:

```bash
python -m robot --argumentfile config/default.args --outputdir results --variable TEST_ENV:hml tests
```

Em paralelo com Pabot (um processo por suíte):

```bash
pabot --processes 4 --argumentfile config/default.args --outputdir results tests
```

Validar a estrutura sem abrir o navegador (resolve imports e keywords):

```bash
python -m robot --argumentfile config/default.args --outputdir results --dryrun tests
```

## 12. Filtrar cenários por tags

| Tag | Significado |
| --- | --- |
| `smoke` | Fluxos principais, para verificação rápida |
| `regression` | Toda a regressão |
| `login`, `home`, `checkout` | Funcionalidade |
| `positive`, `negative`, `validation` | Tipo de cenário |
| `e2e` | Jornada completa |
| `destructive` | Altera dados; nunca roda em produção |

```bash
python -m robot --argumentfile config/default.args --outputdir results --include smoke tests
```

```bash
python -m robot --argumentfile config/default.args --outputdir results --include checkoutANDnegative tests
```

```bash
python -m robot --argumentfile config/default.args --outputdir results --exclude destructive tests
```

## 13. Modo headed e headless

Ver o navegador abrindo e executando:

```bash
python -m robot --argumentfile config/default.args --outputdir results --variable HEADLESS:False tests
```

Sem janela (padrão):

```bash
python -m robot --argumentfile config/default.args --outputdir results --variable HEADLESS:True tests
```

Também é possível definir `HEADLESS=false` no `.env`.

## 14. Relatórios

Cada execução gera em `results/`:

| Arquivo | Conteúdo |
| --- | --- |
| `report.html` | Visão geral: estatísticas por suíte e por tag, aprovados e reprovados |
| `log.html` | Passo a passo de cada teste, com keywords, argumentos, tempos e **screenshots** |
| `output.xml` | Resultado bruto, usado para gerar relatórios e reexecutar falhas |
| `xunit.xml` | Formato xUnit, para integração com CI |
| `browser/screenshot/` | Imagens capturadas |

- **Teste aprovado:** screenshot da página inteira no final do teste.
- **Teste reprovado:** screenshot automático no momento da falha.

Abrir o relatório no Windows:

```powershell
start results\report.html
```

No Linux/macOS:

```bash
open results/report.html
```

Juntar resultados de várias execuções (ex.: um por navegador):

```bash
python -m robot.rebot --outputdir results/combined --name "Todos os navegadores" results/chromium/output.xml results/firefox/output.xml
```

## 15. Depurar falhas

1. Abra `results/log.html`, expanda o teste que falhou e veja a keyword em vermelho e o screenshot.
2. Rode só o teste com o navegador visível e mais tempo de espera:

   ```bash
   python -m robot --argumentfile config/default.args --outputdir results --variable HEADLESS:False --variable TIMEOUT:30s --test "Nome do teste" tests
   ```

3. Aumente o detalhe do log:

   ```bash
   python -m robot --argumentfile config/default.args --outputdir results --loglevel TRACE --test "Nome do teste" tests
   ```

4. Reexecute apenas os testes que falharam na última execução:

   ```bash
   python -m robot --argumentfile config/default.args --outputdir results --rerunfailed results/output.xml --output rerun.xml tests
   ```

5. Pause a execução em um ponto específico adicionando, no teste, a keyword
   `Pause Execution` da biblioteca `Dialogs` (`Library    Dialogs`).
6. Consulte `results/playwright-log.txt` para o log interno do Playwright.

## 16. Como criar uma nova página

Crie `resources/pages/<nome>_page.resource`:

```robotframework
*** Settings ***
Documentation    Página de detalhes do produto.

Resource         ../common/browser.resource
Resource         ../keywords/wait_keywords.resource


*** Variables ***
${PRODUCT_DETAILS_NAME}           data-test=inventory-item-name
${PRODUCT_DETAILS_BACK_BUTTON}    data-test=back-to-products


*** Keywords ***
O Nome Do Produto Deve Ser
    [Arguments]    ${product}
    Get Text    ${PRODUCT_DETAILS_NAME}    ==    ${product}

Voltar Para Os Produtos
    Click    ${PRODUCT_DETAILS_BACK_BUTTON}
```

Regras:

- Prefixe os locators com o nome da página (`${PRODUCT_DETAILS_...}`).
- Prefira `data-test=...`, `role=...` ou `id=...`; evite classes visuais e XPath por posição.
- Não use `Sleep`: as ações da Browser Library já esperam o elemento ficar pronto.

## 17. Como criar e reutilizar keywords

| Se a keyword... | Coloque em |
| --- | --- |
| usa locators de uma única página | `resources/pages/` |
| atua em uma parte repetida (cabeçalho, menu) | `resources/components/` |
| serve para qualquer página (navegar, preencher formulário) | `resources/keywords/` |
| verifica algo usado em vários lugares | `resources/common/assertions.resource` |
| é um passo de negócio usado só por uma suíte | `*** Keywords ***` do próprio `.robot` |
| precisa de lógica de programação | `libraries/*.py` |

Para reutilizar, importe o arquivo com `Resource` na seção `*** Settings ***`. Antes de criar uma keyword,
verifique se a Browser Library já oferece o comportamento (ex.: `Get Text    seletor    ==    valor` já
espera e compara).

## 18. Como criar novos testes

Crie um arquivo `.robot` em `tests/<funcionalidade>/`:

```robotframework
*** Settings ***
Documentation       Detalhes do produto.

Resource            ../../resources/common/setup_teardown.resource
Resource            ../../resources/keywords/authentication_keywords.resource
Resource            ../../resources/pages/product_details_page.resource

Suite Setup         Iniciar Suíte
Suite Teardown      Finalizar Suíte
Test Setup          Acessar Página Inicial Autenticado
Test Teardown       Finalizar Teste

Test Tags           product    regression


*** Test Cases ***
Deve exibir os detalhes do produto selecionado
    Abrir Detalhes Do Produto    ${PRODUCT_BACKPACK}
    O Nome Do Produto Deve Ser    ${PRODUCT_BACKPACK}
```

- Nomeie o cenário pelo comportamento esperado ("Deve ...").
- Use `Iniciar Teste` (sem login) ou `Acessar Página Inicial Autenticado` (logado) como Test Setup.
- Adicione a tag `destructive` se o teste alterar dados.
- Todo teste precisa terminar com uma verificação real.

## 19. Bibliotecas Python personalizadas

As bibliotecas são classes importadas pelo caminho do módulo:

```robotframework
Library    libraries.test_data_factory.TestDataFactory
```

| Keyword | Biblioteca | Retorno |
| --- | --- | --- |
| `Obter Credenciais Do Usuário    standard` | `EnvironmentLibrary` | `{username, password}` lidos do ambiente |
| `Usuário Está Configurado    standard` | `EnvironmentLibrary` | `True`/`False` |
| `Obter Variável De Ambiente Obrigatória    NOME` | `EnvironmentLibrary` | valor, ou erro claro se ausente |
| `Gerar Dados Do Comprador` | `TestDataFactory` | `{first_name, last_name, postal_code}` |
| `Gerar Dados Do Comprador Sem O Campo    postal_code` | `TestDataFactory` | o mesmo, com um campo vazio |
| `Gerar Credenciais Inválidas` | `TestDataFactory` | `{username, password}` inexistentes |
| `Converter Texto Em Preço    Total: $43.18` | `PriceLibrary` | `Decimal('43.18')` |
| `Somar Preços    ${lista}` | `PriceLibrary` | soma arredondada em centavos |

Criando uma keyword nova:

```python
from robot.api.deco import keyword, library


@library(scope="GLOBAL")
class MinhaBiblioteca:
    @keyword("Nome Da Keyword Em Português")
    def my_function(self, value: str) -> str:
        """Documentação exibida no libdoc."""
        return value.upper()
```

Para o import funcionar, execute a partir da raiz com `python -m robot` ou use `--pythonpath .`
(já incluído no `config/default.args`).

## 20. Solução de problemas comuns

| Problema | Solução |
| --- | --- |
| `Failed building wheel for PyYAML` na instalação | Python novo demais; use 3.13 (`py install 3.13`) e recrie a `.venv` |
| `python` abre a Microsoft Store | Use `py -3.13` ou desative o alias de execução do Windows |
| `No keyword with name ... found` | Falta o `Resource` correto no `*** Settings ***` |
| `Importing library 'libraries...' failed: ModuleNotFoundError` | Execute da raiz com `python -m robot` ou `--argumentfile config/default.args --outputdir results` |
| `Could not connect to the playwright process` | Rode `rfbrowser init` novamente e confira `node --version` |
| `TimeoutError: ... Timeout 10000ms exceeded` | Seletor errado ou página lenta; confira no log/screenshot e ajuste `TIMEOUT` |
| `strict mode violation` | O seletor encontrou mais de um elemento; torne-o mais específico |
| Testes como **SKIP** | Credenciais ausentes no `.env` |
| `TEST_ENV inválido` / `Defina a variável BASE_URL_...` | Ambiente inexistente ou URL não configurada |
| Execução trava sem saída ao usar `--output NONE` | A Browser Library precisa da pasta de saída; mantenha `--outputdir results` |
| `LookupError: unknown encoding` no terminal | Defina `PYTHONIOENCODING=utf-8` |

## Qualidade de código

Python:

```bash
ruff check .
```

```bash
ruff format .
```

Robot Framework:

```bash
robocop check tests resources
```

```bash
robocop format tests resources
```

O Robocop substitui o Robotidy, que foi integrado a ele e descontinuado como ferramenta separada.

## Integração contínua

O workflow `.github/workflows/robot.yml` roda em cada push e pull request:

1. **quality**: Ruff e Robocop (lint e formatação);
2. **test**: a suíte completa em Chromium, Firefox e WebKit, em paralelo com Pabot.

Os resultados de cada navegador (`report.html`, `log.html`, screenshots) ficam disponíveis como artefatos
da execução. Cadastre em **Settings → Secrets and variables → Actions** os secrets `TEST_USERNAME`,
`TEST_PASSWORD` e `TEST_LOCKED_USERNAME`; sem eles, os testes que exigem login são marcados como SKIP.
