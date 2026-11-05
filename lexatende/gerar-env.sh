#!/bin/sh
# LexAtende: gera o .env de produção com segredos novos, NO SERVIDOR.
# Uso:  sh lexatende/gerar-env.sh > .env && chmod 600 .env
# Nunca commite o .env nem cole seu conteúdo em chats ou tickets.
set -eu

FRONTEND_HOST="${FRONTEND_HOST:-lexatende.useconts.com.br}"
API_HOST="${API_HOST:-lexatende-api.useconts.com.br}"

hex() { head -c "$1" /dev/urandom | od -An -tx1 | tr -d ' \n'; }
b64url() { head -c 32 /dev/urandom | base64 | tr '+/' '-_' | tr -d '\n'; }

if [ -t 1 ]; then
  echo "Redirecione a saída para um arquivo: sh $0 > .env" >&2
  exit 1
fi

cat <<EOF
# Gerado em $(date -u +%Y-%m-%dT%H:%M:%SZ) por lexatende/gerar-env.sh
# ---------------------------------------------------------------- Endereços
FRONTEND_URL=https://${FRONTEND_HOST}
BACKEND_URL=https://${API_HOST}
CORS_ORIGINS=https://${FRONTEND_HOST}
ACTIVE_STORAGE_SERVICE=local
ACTIVE_STORAGE_URL=https://${API_HOST}

# ---------------------------------------------------------------- Banco e Redis
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USERNAME=lexatende
POSTGRES_PASSWORD=$(hex 24)
POSTGRES_DATABASE=lexatende
POSTGRES_SSLMODE=disable
REDIS_PASSWORD=$(hex 24)

# ---------------------------------------------------------------- Segredos (iguais em Auth e CRM)
SECRET_KEY_BASE=$(hex 64)
JWT_SECRET_KEY=$(hex 32)
ENCRYPTION_KEY=$(b64url)
EVOAI_CRM_API_TOKEN=$(hex 32)
DOORKEEPER_JWT_SECRET_KEY=$(hex 32)
DOORKEEPER_JWT_ALGORITHM=hs256
DOORKEEPER_JWT_ISS=evo-auth-service
OAUTH_TOKEN_EXPIRES_IN=28800
MFA_ISSUER=LexAtende

# ---------------------------------------------------------------- Evolution Go
EVOLUTION_GO_ADMIN_SECRET=$(hex 32)

# ---------------------------------------------------------------- Comportamento
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=0
LOG_LEVEL=info
DISABLE_TELEMETRY=true
ENABLE_ACCOUNT_SIGNUP=false
ENABLE_PUSH_RELAY_SERVER=false
ENABLE_INBOX_EVENTS=true

# ---------------------------------------------------------------- E-mail (preencher depois, se usar)
MAILER_SENDER_EMAIL=
SMTP_ADDRESS=
SMTP_PORT=587
SMTP_DOMAIN=
SMTP_USERNAME=
SMTP_PASSWORD=
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true
EOF
