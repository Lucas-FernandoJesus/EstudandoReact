# Estudando React

Repositório pessoal dedicado ao aprendizado progressivo de desenvolvimento web, partindo dos fundamentos de JavaScript até a criação de aplicações com React e a integração full-stack.

> Este projeto está em desenvolvimento e funciona como um diário de aprendizagem. No momento, o foco está nos fundamentos de JavaScript; a etapa prática com React virá depois da consolidação dos pré-requisitos.

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

O módulo atual é **JavaScript**, com prática dos seguintes conceitos:

- variáveis, tipos primitivos e reatribuição;
- comparações e operadores lógicos;
- estruturas condicionais com `if` e `else`;
- funções, parâmetros, argumentos e valores de retorno;
- arrays, índices, `.length`, `.push()` e `.pop()`;
- repetição com `for...of`, contadores, acumuladores e médias;
- criação, acesso e alteração de objetos;
- integração de arrays de objetos com condições, acumuladores e funções.

O próximo passo é consolidar a diferença entre a coleção e o item atual dentro de `for...of`, concluindo a função de pedidos e revisando o fluxo entre parâmetro, argumento, retorno e variável receptora.

O acompanhamento detalhado pode ser consultado em [`learning/state/progresso.json`](learning/state/progresso.json).

## Histórico de etapas concluídas

Este histórico é cumulativo. Cada nova etapa concluída será registrada em uma nova linha ao final da tabela, preservando todos os registros anteriores.

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
│   └── skills/                 # Metodologia reutilizável de tutoria
├── learning/
│   ├── logs/                   # Registros das sessões de estudo
│   ├── modules/                # Conteúdos e exercícios dos módulos
│   ├── state/                  # Perfil, progresso e revisões pendentes
│   └── roadmap.md              # Sequência planejada de aprendizagem
├── AGENTS.md                   # Orientações para tutores de IA
└── README.md
```

## Como acompanhar o projeto

Não é necessário instalar dependências neste estágio. Para explorar o conteúdo:

1. consulte o [`roteiro de aprendizagem`](learning/roadmap.md);
2. veja os conteúdos e exercícios disponíveis em [`learning/modules`](learning/modules);
3. acompanhe a evolução em [`learning/state`](learning/state);
4. leia os registros das sessões em [`learning/logs`](learning/logs).

Para obter uma cópia local do repositório:

```bash
git clone URL_DO_REPOSITORIO
cd EstudandoReact
```

Substitua `URL_DO_REPOSITORIO` pela URL disponibilizada pelo GitHub após a criação do repositório.

## Status

Em andamento. A estrutura e os conteúdos serão ampliados conforme o avanço na trilha e a criação dos primeiros projetos práticos.
