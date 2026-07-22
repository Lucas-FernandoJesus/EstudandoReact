# Exercícios do módulo 04 — JavaScript

## Retomada autossuficiente

Esta atividade é uma reconstrução equivalente criada após uma auditoria de integridade. Ela preserva a dificuldade registrada, mas não é apresentada como transcrição da tentativa original do estudante.

Analise o código sem executar inicialmente:

```javascript
const pedidos = [
    { valor: 40, pago: true },
    { valor: 60, pago: true },
    { valor: 25, pago: false }
];

function pagar(pedidos) {
    let total = 0;

    for (const pedido of pedidos) {
        if (pedidos.pago) {
            total += pedidos.valor;
        }
    }

    return total;
}

const valorPago = pagar(pedidos);
console.log(valorPago);
```

### Primeira tentativa

1. Na primeira repetição, qual objeto completo está guardado em `pedido`?
2. As duas consultas de propriedade dentro do laço estão sendo feitas no conjunto inteiro ou no item atual?
3. Faça somente os ajustes que considerar necessários.
4. Antes de executar, preveja o valor retornado. A meta registrada para esta variação é `100`.
5. Explique separadamente qual é o parâmetro, qual é o argumento, qual valor volta pelo `return` e qual variável recebe esse retorno.

Não há gabarito neste arquivo. Registrar a tentativa e a explicação antes de aplicar qualquer pista.
