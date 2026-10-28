# Arquitetura e decisões

Este documento registra as decisões arquiteturais do projeto e o motivo de cada uma.

## Visão geral das camadas

```text
tests/*.robot                 Cenários de negócio (o QUE é testado)
   │
   ├── resources/keywords/authentication_keywords.resource   Fluxos reutilizados como pré-condição
   │
   ├── resources/pages/*.resource         Uma página = locators + ações + validações da página
   │      └── resources/components/*.resource   Partes repetidas em várias páginas
   │
   ├── resources/keywords/*.resource      Keywords genéricas (navegação, formulário, espera, listas)
   ├── resources/common/*.resource        Navegador, ciclo de vida e asserções compartilhadas
   ├── resources/variables/*.resource     Ambiente e dados fixos da aplicação
   │
   └── libraries/*.py                     Lógica que fica melhor em Python
          config/environments.py          Arquivo de variáveis: .env + variáveis do sistema
          data/users.json                 Perfis de usuário (apenas NOMES das variáveis de ambiente)
```

Regra de dependência: uma camada só importa camadas abaixo dela. Páginas nunca importam testes, e
`common/` nunca importa páginas.

## Decisões

### Browser Library em vez de SeleniumLibrary

A Browser Library usa o Playwright, que espera automaticamente os elementos ficarem prontos antes de
cada ação. Isso elimina a maior causa de testes instáveis: `Sleep` e esperas manuais. Ela também
oferece contextos isolados, que são rápidos de criar e mantêm cada teste independente.

### Um navegador por suíte, um contexto por teste

- `Suite Setup` abre o navegador (operação lenta) uma vez por arquivo `.robot`.
- `Test Setup` cria um `New Context`, com cookies e storage zerados, e uma `New Page`.
- `Test Teardown` fecha o contexto.

Assim cada teste começa sem login e sem carrinho, sem pagar o custo de abrir o navegador de novo.
Isso também permite rodar suítes em paralelo com o Pabot.

### Seletores

A aplicação expõe o atributo `data-test`, criado justamente para automação. Por isso ele é a
estratégia principal (`data-test=username`). Para botões dentro de um card de produto, usamos o
papel acessível (`role=button[name="Add to cart"]`), filtrando o card pelo texto do produto.
Nenhum seletor depende de classes visuais ou da posição dos elementos.

### Validações nas páginas

As keywords de validação de uma página (ex.: `Validar Que A Página Inicial Foi Carregada`) ficam no
arquivo da própria página, porque conhecem os locators dela. Os testes chamam essas keywords e as
asserções da Browser Library (`Get Text    seletor    ==    valor`), que já esperam a condição se
tornar verdadeira.

### Configuração por arquivo de variáveis Python

O Robot Framework não lê arquivos `.env`. O `config/environments.py` é um *variable file* que:

1. carrega o `.env` com `python-dotenv` sem sobrescrever variáveis já definidas no sistema
   (assim os secrets do CI têm prioridade);
2. escolhe o ambiente pelo `TEST_ENV`;
3. expõe `BASE_URL`, `BROWSER`, `HEADLESS`, `TIMEOUT` e `IS_PRODUCTION` para o Robot.

Qualquer valor ainda pode ser sobrescrito com `--variable`, que tem a maior prioridade.

### Credenciais

`data/users.json` descreve os perfis (`standard`, `locked_out`) apontando para os **nomes** das
variáveis de ambiente. A `EnvironmentLibrary` resolve os valores em tempo de execução. Nenhuma senha
é versionada, e a senha é digitada com `Fill Secret`, que não a registra no `log.html`.

Quando as credenciais não estão configuradas, o teste é marcado como **SKIP** com uma mensagem
explicando o que preencher, em vez de falhar com um erro difícil de entender.

### Proteção de produção

Testes que alteram dados recebem a tag `destructive`. O `Iniciar Teste` pula esses testes quando
`TEST_ENV=prod`.

### Screenshots

- Em falhas: `run_on_failure=Take Screenshot`, configurado na importação da Browser Library.
- Em sucesso: `Finalizar Teste` registra a tela final no `log.html`.

### Arquivo de argumentos em vez de `robot.yaml`

O Robot Framework não lê `robot.yaml` (esse formato é do RCC/Robocorp). As opções padrão de
execução ficam em `config/default.args`, usado com `--argumentfile`, que é o mecanismo nativo.

### Arquivos não criados

- `modal_component.resource`: a aplicação não tem modais.
- `config/logging_config.py`: as bibliotecas Python usam o logger do próprio Robot
  (`robot.api.logger`), que escreve direto no `log.html`. Um logging paralelo duplicaria isso.

### Bibliotecas Python

Só existe código Python onde ele traz vantagem real:

| Biblioteca | Por que em Python |
| --- | --- |
| `environment_library.py` | Leitura de JSON e variáveis de ambiente com mensagens de erro claras |
| `test_data_factory.py` | Geração de dados aleatórios (`uuid`, `secrets`) |
| `price_library.py` | Soma de preços com `Decimal`, sem erros de arredondamento de ponto flutuante |

As bibliotecas são classes importadas pelo caminho `libraries.modulo.Classe`, por isso os comandos
devem rodar a partir da raiz do projeto com `python -m robot` (que coloca a pasta atual no
`PYTHONPATH`) ou com `--pythonpath .` (já incluído no `config/default.args`).

## Convenções de nomes

| Item | Convenção | Exemplo |
| --- | --- | --- |
| Arquivos | `snake_case`, em inglês | `checkout_overview_page.resource` |
| Keywords | Português, iniciais maiúsculas, descrevendo a ação | `Adicionar Produto Ao Carrinho` |
| Validações | Começam com `Validar` ou descrevem o estado esperado | `O Carrinho Deve Estar Vazio` |
| Variáveis de locator | `MAIÚSCULAS`, prefixo da página ou componente | `${LOGIN_PASSWORD_INPUT}` |
| Variáveis de dados | `MAIÚSCULAS` com prefixo do tipo | `${ROUTE_CART}`, `${MSG_LOCKED_OUT}` |
| Variáveis locais | `minúsculas` | `${credentials}` |
| Funções Python | `snake_case`, em inglês, expostas com `@keyword("Nome Em Português")` | `parse_price` |
| Cenários | Português, começando com "Deve" | `Deve concluir uma compra de ponta a ponta com sucesso` |

## Tags

| Tag | Uso |
| --- | --- |
| `smoke` | Verificação rápida dos fluxos principais |
| `regression` | Toda a suíte de regressão |
| `login`, `home`, `checkout` | Funcionalidade |
| `positive`, `negative`, `validation` | Tipo de cenário |
| `e2e` | Jornada completa de ponta a ponta |
| `destructive` | Altera dados; nunca roda em produção |
