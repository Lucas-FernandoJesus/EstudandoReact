# Estudando React

Repositório pessoal dedicado ao aprendizado progressivo de desenvolvimento web, partindo dos fundamentos de JavaScript até a criação de aplicações com React e a integração full-stack.

> Este projeto está em desenvolvimento e funciona como um diário de aprendizagem. O foco atual e o ponto de retomada são mantidos na fonte operacional de progresso.

## Objetivo

Construir uma base sólida em programação para desenvolver projetos próprios, preparar um portfólio e buscar oportunidades profissionais como desenvolvedor ou freelancer.

A trilha foi organizada para avançar de forma gradual por:

- fundamentos da Web, HTML e CSS;
- JavaScript e TypeScript;
- React e Tailwind CSS;
- Node.js e APIs;
- SQL, PostgreSQL e modelagem de dados;
- autenticação, segurança e testes;
- integração e entrega de aplicações full-stack.

## Progresso atual

O estado operacional não é duplicado neste arquivo para evitar resumos desatualizados. Consulte:

- o [`índice de aprendizagem`](learning/INDEX.md) para navegar pelo projeto;
- o [`progresso atual`](learning/state/progresso.json) para módulo, última sessão e ponto de retomada;
- a [`fila de revisões`](learning/state/revisoes.json) para práticas pendentes.

## Histórico de etapas concluídas

Este histórico é cumulativo. Cada nova etapa ou checkpoint realizado será registrado em uma nova linha ao final da tabela, preservando todos os registros anteriores. “Concluída” significa que a atividade descrita foi finalizada com a evidência indicada; não significa necessariamente domínio consolidado. O nível de domínio e as revisões pendentes permanecem nas fontes canônicas de `learning/state/`.

| Data | Etapa concluída | Evidência |
| --- | --- | --- |
| 2026-07-21 | Arrays: índices, limites, `push()` e `pop()` | Previu corretamente `length`, o último índice, o acesso fora do limite como `undefined` e os efeitos de `push()` e `pop()`; após uma pista, distinguiu consulta de alteração do array. |
| 2026-07-21 | Introdução ao `for...of` | Em uma nova variação, separou autonomamente o array do elemento individual, percorreu os valores e identificou corretamente `Firefox` na segunda repetição. |
| 2026-07-21 | Integração de `for...of` com `if` | Percorreu pontuações, aplicou autonomamente o filtro `>= 60` e previu a saída `72`, seguida de `90`, preservando a ordem do array. |
| 2026-07-21 | Contador com `for...of` e `if` | Inicializou um contador com `let`, incrementou-o somente para idades maiores ou iguais a `18` e previu corretamente o resultado final `3`. |
| 2026-07-21 | Acumulador de soma com `for...of` | Somou cada venda ao acumulador, previu corretamente o total `400` e explicou por que o `console.log` fora do laço exibe somente o resultado final. |
| 2026-07-21 | Média com `for...of`, acumulador e `length` | Após pistas, corrigiu a soma do elemento atual, rastreou o total `180`, usou `length` como divisor, calculou a média `45` e exibiu o resultado. |
| 2026-07-21 | Introdução à criação e ao acesso de objetos | Criou autonomamente um objeto com propriedades `string`, `number` e `boolean`, acessou `paginas` com notação de ponto e explicou a busca pelo nome da propriedade. |
| 2026-07-21 | Alteração de propriedades em objetos com `const` | Alterou autonomamente `conta.ativa` de `true` para `false`, exibiu o novo valor e explicou que a referência ao objeto permaneceu a mesma. |
| 2026-07-21 | Criação e atualização de propriedades | Criou `conta.saldo` com valor `250`, atualizou a mesma propriedade para `300`, exibiu ambos os estados e explicou como o JavaScript distingue criação de atualização. |
| 2026-07-21 | Integração de arrays, objetos e `for...of` | Criou três objetos em um array, percorreu-os autonomamente, exibiu apenas a propriedade `nome` e explicou que a variável do laço recebe cada objeto completo. |
| 2026-07-21 | Objetos com condição em `for...of` | Adicionou a propriedade booleana `disponivel`, filtrou os objetos com `if`, exibiu apenas os nomes disponíveis e previu corretamente `Acao` e `Aventura`. |
| 2026-07-21 | Acumulador filtrado em array de objetos | Percorreu os cursos, somou apenas a duração dos disponíveis, previu corretamente o total `24` e explicou por que o curso indisponível não contribuiu. |
| 2026-07-21 | Função integradora com array de objetos | Criou uma função que recebe cursos, filtra os disponíveis, acumula e retorna `24`; após pistas, distinguiu parâmetro, argumento, retorno e variável receptora. |

## Metodologia de aprendizagem

O estudo segue uma abordagem prática e orientada por evidências:

1. apresentação de um conceito pequeno e observável;
2. construção de um modelo mental em linguagem simples;
3. demonstração por meio de um exemplo análogo;
4. tentativa prática sem solução pronta;
5. uso de pistas graduais quando necessário;
6. registro das evidências e revisão dos pontos que precisam ser fortalecidos.

O avanço não depende de um prazo fixo. Cada habilidade é revisada até que possa ser aplicada em uma situação nova e explicada com pouca ou nenhuma ajuda.

## Estrutura do repositório

```text
.
├── .agents/
│   └── skills/                 # Metodologia e scripts reutilizáveis de tutoria
├── .codex/
│   ├── agents/                 # Especialistas somente leitura
│   └── config.toml             # Limites de paralelismo e profundidade
├── learning/
│   ├── INDEX.md                # Mapa de navegação sem duplicar o estado
│   ├── audits/                 # Relatórios mensais, criados quando necessários
│   ├── logs/                   # Registros das sessões de estudo
│   ├── modules/                # Conteúdos e exercícios dos módulos
│   ├── state/                  # Perfil, progresso e revisões pendentes
│   └── roadmap.md              # Sequência planejada de aprendizagem
├── setup/                      # Preparação automatizada e verificável da máquina
│   ├── install.cmd             # Entrada simples para preparar o ambiente
│   ├── requirements-tools.txt  # Dependências Python das ferramentas
│   └── setup-environment.ps1   # Bootstrap seguro para reexecução
├── .editorconfig               # Regras de codificação e finais de linha
├── AGENTS.md                   # Orientações para tutores de IA
└── README.md
```

## Como acompanhar o projeto

Não é necessário instalar dependências neste estágio. Para explorar o conteúdo:

1. comece pelo [`índice de aprendizagem`](learning/INDEX.md);
2. consulte o [`roteiro de aprendizagem`](learning/roadmap.md) para a sequência curricular;
3. veja os conteúdos e exercícios disponíveis em [`learning/modules`](learning/modules);
4. acompanhe a evolução em [`learning/state`](learning/state);
5. leia os registros das sessões em [`learning/logs`](learning/logs).

## Preparar outra máquina

Depois de clonar ou atualizar o repositório, execute na raiz:

```powershell
.\setup\install.cmd
```

O bootstrap instala a distribuição ZIP oficial do PowerShell 7 em `%LOCALAPPDATA%\Programs\PowerShell` quando necessário, adiciona a versão ativa ao PATH do usuário, define `RemoteSigned` para esse usuário, cria uma `.venv`, instala as dependências fixadas e valida a skill e os scripts. Ele pode ser executado novamente sem recriar o que já estiver correto.

O único pré-requisito externo é uma instalação oficial do Python 3.8 ou superior acessível como `python` ou `py`. O bootstrap não instala ou substitui o Python do computador; ele isola as dependências deste projeto na `.venv`.

O `git pull` não executa o bootstrap automaticamente. Essa separação é intencional: executar código recém-baixado sem uma ação consciente seria um risco de segurança.

A pasta `setup/` é uma receita pequena e versionada, necessária para preparar ou reparar o ambiente em qualquer máquina. Mantenha-a no projeto; os arquivos baixados durante a instalação são temporários e já são excluídos automaticamente pelo bootstrap.

As configurações locais não são transferidas entre computadores. O Git transfere somente o bootstrap, as regras de codificação e a lista de dependências; execute o mesmo comando em cada máquina.

Para obter uma cópia local do repositório:

```bash
git clone URL_DO_REPOSITORIO
cd EstudandoReact
```

Substitua `URL_DO_REPOSITORIO` pela URL disponibilizada pelo GitHub após a criação do repositório.

## Status

Em andamento. A estrutura e os conteúdos serão ampliados conforme o avanço na trilha e a criação dos primeiros projetos práticos.
