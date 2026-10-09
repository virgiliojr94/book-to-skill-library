# book-to-skill-library

Skills de agente geradas por conversão de fonte (livro/documento via `book-to-skill`, posts via `x-to-skill`).
Repo biblioteca: a fonte da verdade vive aqui; os diretórios de skill dos agents apontam pra cá por symlink.

## Conteúdo

### `books/` — convertidas de livro/documento
| Skill | Fonte |
|---|---|
| `mrbeast-production` | "How to Succeed in MrBeast Production" — Jimmy Donaldson |
| `normas-abnt-ufrr` | Normas ABNT + Resolução CEPE/UFRR nº 133/2025 |

### `x/` — convertidas de posts no X
| Skill | Conta | Janela |
|---|---|---|
| `karpathy-x` | @karpathy | 2024-06 → 2026-08 |
| `levelsio-x` | @levelsio | 2026-07 → 2026-08 |
| `adam-delduca-x` | @Adam_DelDuca | 2026-07-12 → 2026-09-13 |
| `eptwts-business-systems` | @eptwts | 2026-01 → 2026-08 |

## Estrutura de uma skill convertida
```
<skill>/
  SKILL.md          # entrypoint (frontmatter name + description)
  chapters/         # um arquivo por capítulo/tema
  cheatsheet.md     # referência rápida
  glossary.md       # termos
  patterns.md       # padrões aplicáveis
  corpus.md         # (x-to-skill) posts com proveniência
  analysis.md       # (x-to-skill) análise de recorrência
```

## Instalar numa máquina nova
```sh
git clone <este-repo> ~/book-to-skill-library
~/book-to-skill-library/link.sh
```

`link.sh` cria os symlinks em `~/.agents/skills/`, `~/.claude/skills/` e
`~/.config/opencode/skills/`. Idempotente.

## Adicionar skill nova
1. Rodar `book-to-skill` (ou `x-to-skill`) gerando em `books/` ou `x/`.
2. Rodar `./link.sh`.
3. Atualizar a tabela acima.
