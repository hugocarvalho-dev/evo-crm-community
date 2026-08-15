#!/usr/bin/env bash
# =============================================================================
# Validação das montagens declaradas no docker-compose.override.yml
# =============================================================================
# Por que isto existe:
# Quando um caminho de origem de um bind mount não existe, o Docker NÃO avisa —
# ele cria um DIRETÓRIO vazio naquele caminho. O container então falha ao subir
# com "not a directory: Are you trying to mount a directory onto a file?", e
# ainda sobra lixo em branding/assets/.
#
# O erro real acontece ao renomear arte: o catálogo _ops.sh é atualizado e o
# override é esquecido. Esta verificação fecha essa lacuna, apontando o problema
# antes de o Docker rodar.
#
# Define: verificar_montagens  → imprime problemas, devolve 1 se houver algum
# =============================================================================

verificar_montagens() {
  local root="$1"
  local override="$root/docker-compose.override.yml"
  local problemas=0 caminho

  [ -f "$override" ] || return 0

  # Extrai o lado esquerdo (origem no host) de cada volume que aponte para a
  # pasta de marca.
  while IFS= read -r caminho; do
    [ -n "$caminho" ] || continue
    if [ -d "$root/$caminho" ]; then
      echo "  MONTAGEM  $caminho — é um DIRETÓRIO, deveria ser arquivo."
      echo "            Provável diretório fantasma criado pelo Docker. Remova com:"
      echo "            rmdir '$caminho'"
      problemas=$((problemas+1))
    elif [ ! -f "$root/$caminho" ]; then
      echo "  MONTAGEM  $caminho — não existe."
      echo "            O docker-compose.override.yml aponta para arte que foi"
      echo "            renomeada ou removida. Atualize o override."
      problemas=$((problemas+1))
    fi
  done < <(grep -oE '\./branding/[^:]+' "$override" | sed 's|^\./||' | sort -u)

  return $((problemas > 0))
}
