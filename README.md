# 🎵 Navidrome

<div align="center">

[![CI](https://github.com/actiago/navridrome/actions/workflows/ci.yml/badge.svg)](https://github.com/actiago/navridrome/actions/workflows/ci.yml)
[![Licença: MIT](https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/deluan/navidrome)
[![Podman](https://img.shields.io/badge/Podman-892CA0?logo=podman&logoColor=white)](https://podman.io)

**Navidrome** é um servidor de música moderno e streamer compatível com a API Subsonic.
Este repositório fornece configurações de implantação para executar o Navidrome com **Docker** e **Podman**.

</div>

---

## 📋 Índice

- [Pré-requisitos](#pré-requisitos)
- [Início Rápido](#início-rápido)
  - [Usando Docker](#usando-docker)
  - [Usando Podman](#usando-podman)
- [Docker Compose](#docker-compose)
- [Podman Compose](#podman-compose)
- [Configuração](#configuração)
- [Scripts de Implantação](#scripts-de-implantação)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Contribuindo](#contribuindo)
- [Licença](#licença)

---

## ✅ Pré-requisitos

Antes de começar, certifique-se de ter um dos seguintes instalados:

- **Docker** (20.10+) e Docker Compose — [Instalar Docker](https://docs.docker.com/engine/install/)
- **Podman** (3.0+) e Podman Compose — [Instalar Podman](https://podman.io/docs/installation)

> 💡 **Nota:** Podman é um mecanismo de contêiner sem daemon que substitui diretamente o Docker. É particularmente adequado para execução de contêineres sem root.

---

## 🚀 Início Rápido

### Usando Docker

Execute o Navidrome com um único comando:

```bash
docker run -d \
  --name navidrome \
  --restart=unless-stopped \
  -v $(pwd)/navidrome-data:/data \
  -v /caminho/para/sua/musica:/music:ro \
  -p 4533:4533 \
  -e ND_SCANSCHEDULE=1h \
  -e ND_LOGLEVEL=info \
  docker.io/deluan/navidrome:latest
```

Em seguida, acesse o Navidrome em **http://localhost:4533**.

### Usando Podman

Execute o Navidrome com um único comando:

```bash
podman run -d \
  --name navidrome \
  --restart=unless-stopped \
  -v $(pwd)/navidrome-data:/data:Z \
  -v /caminho/para/sua/musica:/music:ro,Z \
  -p 4533:4533 \
  -e ND_SCANSCHEDULE=1h \
  -e ND_LOGLEVEL=info \
  docker.io/deluan/navidrome:latest
```

> 🔒 A flag `:Z` nos volumes é específica para sistemas Podman/SELinux e define automaticamente o contexto SELinux correto.

---

## 🐳 Docker Compose

Para uma configuração mais estruturada, use o Docker Compose:

1. **Clone este repositório:**

   ```bash
   git clone https://github.com/actiago/navridrome.git
   cd navridrome
   ```

2. **Configure o ambiente (opcional):**

   ```bash
   cp .env.example .env
   # Edite .env com suas credenciais da API do Last.fm, se desejar
   ```

3. **Edite `docker-compose.yml`** e atualize o caminho do volume de música:

   ```yaml
   volumes:
     - ./navidrome-data:/data
     - /caminho/para/sua/musica:/music:ro   # ← Altere este caminho
   ```

4. **Inicie o Navidrome:**

   ```bash
   docker compose up -d
   ```

5. **Veja os logs:**

   ```bash
   docker compose logs -f
   ```

6. **Pare o Navidrome:**

   ```bash
   docker compose down
   ```

---

## 🦭 Podman Compose

Para usuários do Podman, use o arquivo `podman-compose.yml` fornecido:

1. **Clone este repositório:**

   ```bash
   git clone https://github.com/actiago/navridrome.git
   cd navridrome
   ```

2. **Configure o ambiente (opcional):**

   ```bash
   cp .env.example .env
   # Edite .env com suas credenciais da API do Last.fm, se desejar
   ```

3. **Edite `podman-compose.yml`** e atualize o caminho do volume de música:

   ```yaml
   volumes:
     - ./navidrome-data:/data:Z
     - /caminho/para/sua/musica:/music:ro,Z   # ← Altere este caminho
   ```

4. **Inicie o Navidrome:**

   ```bash
   podman-compose up -d
   ```

   Ou usando a compatibilidade do Podman com Docker Compose:

   ```bash
   podman compose up -d
   ```

5. **Veja os logs:**

   ```bash
   podman-compose logs -f
   ```

6. **Pare o Navidrome:**

   ```bash
   podman-compose down
   ```

---

## ⚙️ Configuração

### Variáveis de Ambiente

O Navidrome pode ser configurado usando variáveis de ambiente. Todas as variáveis são prefixadas com `ND_`.

| Variável | Padrão | Descrição |
|---|---|---|
| `ND_SCANSCHEDULE` | `1h` | Com que frequência escanear novas músicas (ex.: `30m`, `1h`, `6h`) |
| `ND_LOGLEVEL` | `info` | Nível de log: `debug`, `info`, `warning`, `error` |
| `ND_LASTFM_ENABLED` | `false` | Habilitar scrobbling do Last.fm |
| `ND_LASTFM_APIKEY` | — | Sua chave da API do Last.fm |
| `ND_LASTFM_SECRET` | — | Seu segredo compartilhado do Last.fm |
| `ND_MUSICFOLDER` | `/music` | Caminho para o diretório de música dentro do contêiner |
| `ND_DATAFOLDER` | `/data` | Caminho para o diretório de dados dentro do contêiner |

Para uma lista completa de opções de configuração, veja a [documentação oficial do Navidrome](https://www.navidrome.org/docs/usage/configuration-options/).

### Usando Arquivo `.env`

Copie o arquivo de ambiente de exemplo e personalize-o:

```bash
cp .env.example .env
```

Em seguida, edite `.env` com suas configurações preferidas. Os arquivos do Docker Compose carregarão automaticamente as variáveis deste arquivo.

---

## 📜 Scripts de Implantação

Este repositório inclui scripts auxiliares para implantação rápida:

### Script Docker

```bash
# Torne o script executável
chmod +x scripts/docker-run.sh

# Execute com o diretório de música obrigatório
./scripts/docker-run.sh --music /caminho/para/sua/musica

# Com opções personalizadas
./scripts/docker-run.sh \
  --music /media/music \
  --data /opt/navidrome-data \
  --port 8080 \
  --env ND_LOGLEVEL=debug \
  --env ND_SCANSCHEDULE=30m
```

### Script Podman

```bash
# Torne o script executável
chmod +x scripts/podman-run.sh

# Execute com o diretório de música obrigatório
./scripts/podman-run.sh --music /caminho/para/sua/musica

# Com opções personalizadas
./scripts/podman-run.sh \
  --music /media/music \
  --data /opt/navidrome-data \
  --port 8080 \
  --env ND_LOGLEVEL=debug \
  --env ND_SCANSCHEDULE=30m
```

### Opções dos Scripts

| Opção | Descrição | Padrão |
|---|---|---|
| `-m, --music CAMINHO` | Caminho para o diretório de música **(obrigatório)** | — |
| `-d, --data CAMINHO` | Caminho para os dados do Navidrome | `./navidrome-data` |
| `-p, --port PORTA` | Porta do host para vincular | `4533` |
| `-e, --env CHAVE=VALOR` | Variáveis de ambiente adicionais | — |
| `-t, --tag TAG` | Tag da imagem do contêiner | `latest` |
| `-h, --help` | Mostrar mensagem de ajuda | — |

---

## 📁 Estrutura do Projeto

```
navidrome/
├── .editorconfig              # Configuração do editor
├── .env.example               # Modelo de variáveis de ambiente
├── .gitignore                 # Regras do Git ignore
├── .github/
│   ├── dependabot.yml         # Configuração do Dependabot
│   └── workflows/
│       ├── ci.yml             # Workflow de CI (lint, validar)
│       └── release.yml        # Workflow de release
├── CHANGELOG.md               # Histórico de versões
├── LICENSE                    # Licença MIT
├── README.md                  # Este arquivo
├── docker-compose.yml         # Configuração do Docker Compose
├── podman-compose.yml         # Configuração do Podman Compose
└── scripts/
    ├── docker-run.sh          # Script de implantação Docker
    └── podman-run.sh          # Script de implantação Podman
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Veja como você pode ajudar:

1. **Faça um Fork** do repositório
2. **Crie** um branch de funcionalidade: `git checkout -b feature/minha-funcionalidade`
3. **Commit** suas alterações: `git commit -am 'Adiciona minha funcionalidade'`
4. **Push** para o branch: `git push origin feature/minha-funcionalidade`
5. **Abra** um Pull Request

Por favor, certifique-se de que seu código segue o estilo existente e inclui documentação apropriada.

---

## 📄 Licença

Este projeto está licenciado sob a **Licença MIT** — veja o arquivo [LICENSE](LICENSE) para detalhes.

---

<div align="center">
  Feito com ❤️ para a comunidade Navidrome
</div>
