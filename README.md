# Navidrome

<div align="center">

[![CI](https://github.com/actiago/navridrome/actions/workflows/ci.yml/badge.svg)](https://github.com/actiago/navridrome/actions/workflows/ci.yml)
[![Licenca: MIT](https://img.shields.io/badge/Licenca-MIT-yellow.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/deluan/navidrome)
[![Podman](https://img.shields.io/badge/Podman-892CA0?logo=podman&logoColor=white)](https://podman.io)

**Navidrome** e um servidor de musica moderno e streamer compativel com a API Subsonic.
Este repositorio fornece configuracoes de implantacao para executar o Navidrome com **Docker** e **Podman**.

</div>

---

## Indice

- [Pre-requisitos](#pre-requisitos)
- [Inicio Rapido](#inicio-rapido)
  - [Usando Docker](#usando-docker)
  - [Usando Podman](#usando-podman)
- [Docker Compose](#docker-compose)
- [Podman Compose](#podman-compose)
- [Configuracao](#configuracao)
- [Scripts de Implantacao](#scripts-de-implantacao)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Contribuindo](#contribuindo)
- [Licenca](#licenca)

---

## Pre-requisitos

Antes de comecar, certifique-se de ter um dos seguintes instalados:

- **Docker** (20.10+) e Docker Compose — [Instalar Docker](https://docs.docker.com/engine/install/)
- **Podman** (3.0+) e Podman Compose — [Instalar Podman](https://podman.io/docs/installation)

> **Nota:** Podman e um mecanismo de contêiner sem daemon que substitui diretamente o Docker. E particularmente adequado para execucao de contêineres sem root.

---

## Inicio Rapido

### Usando Docker

Execute o Navidrome com um unico comando:

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

Execute o Navidrome com um unico comando:

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

> A flag `:Z` nos volumes e especifica para sistemas Podman/SELinux e define automaticamente o contexto SELinux correto.

---

## Docker Compose

Para uma configuracao mais estruturada, use o Docker Compose:

1. **Clone este repositorio:**

   ```bash
   git clone https://github.com/actiago/navridrome.git
   cd navridrome
   ```

2. **Configure o ambiente (opcional):**

   ```bash
   cp .env.example .env
   # Edite .env com suas credenciais da API do Last.fm, se desejar
   ```

3. **Edite `docker-compose.yml`** e atualize o caminho do volume de musica:

   ```yaml
   volumes:
     - ./navidrome-data:/data
     - /caminho/para/sua/musica:/music:ro   # Altere este caminho
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

## Podman Compose

Para usuarios do Podman, use o arquivo `podman-compose.yml` fornecido:

1. **Clone este repositorio:**

   ```bash
   git clone https://github.com/actiago/navridrome.git
   cd navridrome
   ```

2. **Configure o ambiente (opcional):**

   ```bash
   cp .env.example .env
   # Edite .env com suas credenciais da API do Last.fm, se desejar
   ```

3. **Edite `podman-compose.yml`** e atualize o caminho do volume de musica:

   ```yaml
   volumes:
     - ./navidrome-data:/data:Z
     - /caminho/para/sua/musica:/music:ro,Z   # Altere este caminho
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

## Configuracao

### Variaveis de Ambiente

O Navidrome pode ser configurado usando variaveis de ambiente. Todas as variaveis sao prefixadas com `ND_`.

| Variavel | Padrao | Descricao |
|---|---|---|
| `ND_SCANSCHEDULE` | `1h` | Com que frequencia escanear novas musicas (ex.: `30m`, `1h`, `6h`) |
| `ND_LOGLEVEL` | `info` | Nivel de log: `debug`, `info`, `warning`, `error` |
| `ND_LASTFM_ENABLED` | `false` | Habilitar scrobbling do Last.fm |
| `ND_LASTFM_APIKEY` | — | Sua chave da API do Last.fm |
| `ND_LASTFM_SECRET` | — | Seu segredo compartilhado do Last.fm |
| `ND_MUSICFOLDER` | `/music` | Caminho para o diretorio de musica dentro do contêiner |
| `ND_DATAFOLDER` | `/data` | Caminho para o diretorio de dados dentro do contêiner |

Para uma lista completa de opcoes de configuracao, veja a [documentacao oficial do Navidrome](https://www.navidrome.org/docs/usage/configuration-options/).

### Usando Arquivo `.env`

Copie o arquivo de ambiente de exemplo e personalize-o:

```bash
cp .env.example .env
```

Em seguida, edite `.env` com suas configuracoes preferidas. Os arquivos do Docker Compose carregarao automaticamente as variaveis deste arquivo.

---

## Scripts de Implantacao

Este repositorio inclui scripts auxiliares para implantacao rapida:

### Script Docker

```bash
# Torne o script executavel
chmod +x scripts/docker-run.sh

# Execute com o diretorio de musica obrigatorio
./scripts/docker-run.sh --music /caminho/para/sua/musica

# Com opcoes personalizadas
./scripts/docker-run.sh \
  --music /media/music \
  --data /opt/navidrome-data \
  --port 8080 \
  --env ND_LOGLEVEL=debug \
  --env ND_SCANSCHEDULE=30m
```

### Script Podman

```bash
# Torne o script executavel
chmod +x scripts/podman-run.sh

# Execute com o diretorio de musica obrigatorio
./scripts/podman-run.sh --music /caminho/para/sua/musica

# Com opcoes personalizadas
./scripts/podman-run.sh \
  --music /media/music \
  --data /opt/navidrome-data \
  --port 8080 \
  --env ND_LOGLEVEL=debug \
  --env ND_SCANSCHEDULE=30m
```

### Opcoes dos Scripts

| Opcao | Descricao | Padrao |
|---|---|---|
| `-m, --music CAMINHO` | Caminho para o diretorio de musica **(obrigatorio)** | — |
| `-d, --data CAMINHO` | Caminho para os dados do Navidrome | `./navidrome-data` |
| `-p, --port PORTA` | Porta do host para vincular | `4533` |
| `-e, --env CHAVE=VALOR` | Variaveis de ambiente adicionais | — |
| `-t, --tag TAG` | Tag da imagem do contêiner | `latest` |
| `-h, --help` | Mostrar mensagem de ajuda | — |

---

## Estrutura do Projeto

```
navidrome/
├── .editorconfig              # Configuracao do editor
├── .env.example               # Modelo de variaveis de ambiente
├── .gitignore                 # Regras do Git ignore
├── .github/
│   └── workflows/
│       └── ci.yml             # Workflow de CI (lint, secrets scan)
├── CHANGELOG.md               # Historico de versoes
├── LICENSE                    # Licenca MIT
├── README.md                  # Este arquivo
├── docker-compose.yml         # Configuracao do Docker Compose
├── podman-compose.yml         # Configuracao do Podman Compose
└── scripts/
    ├── docker-run.sh          # Script de implantacao Docker
    └── podman-run.sh          # Script de implantacao Podman
```

---

## Contribuindo

Contribuicoes sao bem-vindas! Veja como voce pode ajudar:

1. **Faca um Fork** do repositorio
2. **Crie** um branch de funcionalidade: `git checkout -b feature/minha-funcionalidade`
3. **Commit** suas alteracoes: `git commit -am 'Adiciona minha funcionalidade'`
4. **Push** para o branch: `git push origin feature/minha-funcionalidade`
5. **Abra** um Pull Request

Por favor, certifique-se de que seu codigo segue o estilo existente e inclui documentacao apropriada.

---

## Licenca

Este projeto esta licenciado sob a **Licenca MIT** — veja o arquivo [LICENSE](LICENSE) para detalhes.

---
