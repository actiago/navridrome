# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado no [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [Não lançado]

### Removido

- Workflow de release automatizado (`.github/workflows/release.yml`)
- Configuração do Dependabot (`.github/dependabot.yml`)

### Alterado

- Workflow de CI simplificado: removidas validações de Docker Compose e Markdown lint
- Adicionado scan de credenciais com Gitleaks ao workflow de CI
- README atualizado para refletir a nova estrutura

[Não lançado]: https://github.com/actiago/navridrome/compare/v0.0.0...HEAD
