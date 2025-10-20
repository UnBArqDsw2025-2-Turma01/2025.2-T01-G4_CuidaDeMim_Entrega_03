#!/bin/bash
set -e

# Espera o Postgres estar pronto
until pg_isready -h ${DATABASE_HOST:-db} -U ${DATABASE_USER:-postgres} >/dev/null 2>&1; do
  echo "Aguardando Postgres..."
  sleep 1
done

# Cria/migra o banco, se Rails já estiver instalado
if [ -f "bin/rails" ]; then
  bundle exec rails db:create || true
  bundle exec rails db:migrate || true
fi

# Inicia o servidor Rails
bundle exec rails server -b 0.0.0.0 -p 3000
