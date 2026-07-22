# Módulo 04 — JavaScript

## Objetivo atual

Distinguir uma coleção do item atual durante uma repetição e explicar o fluxo completo de uma função: parâmetro, argumento, processamento, retorno e variável receptora.

## Pré-requisitos observados

- criar e percorrer arrays com `for...of`;
- acessar propriedades de objetos;
- usar condição e acumulador;
- criar uma função com parâmetros e `return`.

## Modelo mental

Uma coleção é o conjunto inteiro; a variável declarada no `for...of` representa somente um item desse conjunto em cada repetição.

Em uma biblioteca, por exemplo:

```javascript
for (const livro of biblioteca) {
    console.log(livro.titulo);
}
```

`biblioteca` continua representando todos os livros. `livro` representa o objeto atual e é nele que uma propriedade individual deve ser consultada.

## Critério da retomada

A retomada estará concluída quando o estudante conseguir, sem pista decisiva:

1. descrever o primeiro item recebido pela variável do laço;
2. distinguir propriedades do item de operações sobre a coleção;
3. prever o valor retornado;
4. identificar parâmetro, argumento, retorno e variável receptora.

O estado e o agendamento dessa atividade continuam nas fontes canônicas de `learning/state/`.
