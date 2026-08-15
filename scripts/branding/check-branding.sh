#!/usr/bin/env bash
# =============================================================================
# LexAtende — verifica se a personalização está intacta (não escreve nada)
# =============================================================================
# Use para responder rápido a "a marca ainda está aplicada?", tipicamente logo
# depois de uma atualização ou de um deploy.
#
#     ./scripts/branding/check-branding.sh
#
# Código de saída 0 = tudo certo. 1 = há pendências (rode apply-branding.sh).
# =============================================================================

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."
ROOT="$PWD"

if [ -t 1 ]; then
  C_OK=$'\033[32m'; C_ERR=$'\033[31m'; C_OFF=$'\033[0m'
else
  C_OK=""; C_ERR=""; C_OFF=""
fi

PENDING=0
PENDENCIES=()

pending() {
  PENDING=$((PENDING+1)); PENDENCIES+=("$1")
  printf '%s  pendente %s  %s\n' "$C_ERR" "$C_OFF" "$1"
}

_contains() { grep -qF -- "$2" "$1" 2>/dev/null; }

op_copy() {
  local src="$ROOT/$1" dst="$ROOT/$2"
  if [ ! -f "$src" ]; then
    case "$1" in
      branding/generated/*)
        pending "$2 — ícone não gerado (./scripts/branding/generate-icons.sh)" ;;
      *)
        pending "$2 — arte de origem ausente: $1" ;;
    esac
    return
  fi
  if [ ! -f "$dst" ]; then pending "$2 — ausente"; return; fi
  cmp -s "$src" "$dst" || pending "$2 — conteúdo diferente do esperado"
}

op_subst() {
  local file="$ROOT/$1" new="$3"
  if [ ! -f "$file" ]; then pending "$1 — arquivo ausente"; return; fi
  _contains "$file" "$new" || pending "$1 — falta «$new»"
}

op_subst_glob() {
  local pattern="$1" old="$2" f
  for f in $ROOT/$pattern; do
    [ -f "$f" ] || continue
    _contains "$f" "$old" && pending "${f#$ROOT/} — ainda contém «$old»"
  done
}

op_inject() {
  local file="$ROOT/$1" line="$3"
  if [ ! -f "$file" ]; then pending "$1 — arquivo ausente"; return; fi
  _contains "$file" "$line" || pending "$1 — falta a linha injetada"
}

echo
echo "LexAtende — verificando personalização"
echo "════════════════════════════════════════════════════════════════"

# shellcheck source=./_ops.sh
source "$ROOT/scripts/branding/_ops.sh"
branding_ops

# Montagens do Docker: um caminho inexistente aqui derruba o container na
# subida, com uma mensagem que não deixa óbvia a causa.
source "$ROOT/scripts/branding/_mounts.sh"
if ! verificar_montagens "$ROOT"; then
  PENDING=$((PENDING+1))
fi

echo "════════════════════════════════════════════════════════════════"

if [ "$PENDING" -gt 0 ]; then
  printf '%d pendência(s). Rode: ./scripts/branding/apply-branding.sh\n' "$PENDING"
  exit 1
fi

echo "${C_OK}Personalização LexAtende íntegra.${C_OFF}"
echo
