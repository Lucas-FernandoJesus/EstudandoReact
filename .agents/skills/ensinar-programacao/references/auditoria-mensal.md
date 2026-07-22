# Auditoria mensal de eficiência

Executar no último dia de cada mês ou, se a data tiver sido perdida, uma única vez na primeira sessão posterior. Considerar a auditoria concluída quando existir `learning/audits/YYYY-MM.md` para o mês avaliado.

## Verificações

1. Executar `scripts/auditar-eficiencia.ps1`.
2. Confirmar se `learning/state/` continua sendo a fonte operacional e se README, roadmap, índices ou logs passaram a competir com ela.
3. Verificar tamanho, tempo e quantidade de arquivos carregados para retomada, planejamento e revisão de tentativa.
4. Revisar se cada agente mantém responsabilidade distinta, modo somente leitura e delegação útil.
5. Validar a skill, sua descrição de acionamento, o roteamento progressivo e a codificação UTF-8.
6. Comparar com o relatório mensal anterior, quando existir.

## Relatório autorizado

Criar ou atualizar apenas `learning/audits/YYYY-MM.md` com:

- data e escopo;
- métricas observadas;
- inconsistências e duplicações;
- resultado dos agentes e da skill;
- recomendações ainda não aplicadas.

Para cada recomendação opcional, informar problema, alteração proposta, arquivos ou ferramenta afetados, benefício esperado, risco ou efeito colateral e como o comportamento da ferramenta mudará. Pedir autorização antes de aplicar melhorias, otimizações ou mudanças de comportamento; erros e inconsistências objetivamente comprovados seguem a exceção permanente de correções em `AGENTS.md` e devem ser relatados após a validação.

Se não houver melhoria necessária, registrar isso objetivamente. Não criar mudanças apenas para preencher o relatório.
