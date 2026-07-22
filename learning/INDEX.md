# Índice de aprendizagem

Este arquivo é um mapa de navegação. Ele não replica o módulo atual nem a próxima atividade; essas informações mudam em `state/`.

## Retomar uma sessão

1. Execute o resumidor para obter módulo, ponto de retomada e revisões prioritárias sem carregar o estado completo.
2. Abra [`state/progresso.json`](state/progresso.json) somente quando precisar de habilidades ou evidências não incluídas no resumo.
3. Consulte [`state/revisoes.json`](state/revisoes.json) somente para detalhes das revisões relacionadas à sessão.
4. Abra o registro correspondente em [`logs/`](logs/) apenas quando precisar da tentativa ou da evidência completa.

Na raiz do projeto, use:

```powershell
pwsh -NoLogo -NoProfile -File .agents\skills\ensinar-programacao\scripts\resumir-contexto.ps1
```

Após clonar o projeto ou executar `git pull` em uma máquina ainda não preparada, execute conscientemente `setup\install.cmd` na raiz. O Git não executa esse arquivo automaticamente.

## Fontes de informação

| Necessidade | Fonte canônica |
| --- | --- |
| Objetivo, preferências e ambiente | [`state/perfil.json`](state/perfil.json) |
| Módulo, domínio e próxima atividade | [`state/progresso.json`](state/progresso.json) |
| Revisões pendentes e histórico de revisão | [`state/revisoes.json`](state/revisoes.json) |
| Evidências completas de cada sessão | [`logs/`](logs/) |
| Ordem curricular e critérios de avanço | [`roadmap.md`](roadmap.md) |
| Conteúdos e exercícios autorizados | [`modules/`](modules/) |

Os relatórios de eficiência de agentes, skills e acesso às informações são criados mensalmente em `audits/`; eles não fazem parte do estado pedagógico.

## Especialistas disponíveis

- `diagnostico_ambiente`: verifica ferramentas e pré-requisitos sem instalar ou configurar.
- `pesquisador_documentacao`: consulta documentação oficial e informações dependentes de versão.
- `revisor_aprendizado`: avalia tentativas e calibra exercícios sem entregar respostas prontas.

As definições ficam em [`.codex/agents/`](../.codex/agents/).
