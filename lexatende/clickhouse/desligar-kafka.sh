#!/bin/sh
# LexAtende: desliga as filas Kafka que o Evo Flow cria no ClickHouse.
#
# O Evo Flow 1.0.0 cria duas tabelas com engine Kafka (contact_events e
# gatilhos de Jornadas). Sem broker Kafka na stack, elas tentam conectar sem
# parar: ~1.000 linhas de log por minuto e 3-4% de CPU constantes. Com
# WRITE_MODE=ch-sync os eventos vão direto ao ClickHouse, e Jornadas estão
# ocultas, então as duas filas não têm uso.
#
# DETACH ... PERMANENTLY sobrevive a reinícios. O Evo Flow registra um erro de
# "journey trigger queue" no boot e segue normalmente. Para desfazer:
#   ATTACH TABLE evo_campaign.<tabela>
#
# Rodar uma vez em cada servidor novo, depois da primeira subida do evo-flow:
#   sh lexatende/clickhouse/desligar-kafka.sh
set -eu
cd "$(dirname "$0")/../.."

P=$(grep '^CLICKHOUSE_PASSWORD=' .env | cut -d= -f2)
C=$(docker compose -f docker-compose.lexatende.yml ps -q clickhouse)

for t in contact_events_kafka_queue journey_trigger_kafka_queue; do
  if docker exec "$C" clickhouse-client --password "$P" \
       -q "EXISTS TABLE evo_campaign.$t" </dev/null | grep -q 1; then
    docker exec "$C" clickhouse-client --password "$P" \
      -q "DETACH TABLE evo_campaign.$t PERMANENTLY" </dev/null
    echo "desligada: $t"
  else
    echo "já desligada: $t"
  fi
done
