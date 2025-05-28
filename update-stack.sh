#!/bin/bash

# Controlla che siano stati passati tutti e 3 i parametri
if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <nome-stack> <template.yaml> <parametri.json> <region>"
  exit 1
fi

STACK_NAME="$1"
TEMPLATE_FILE="$2"
PARAMETERS_FILE="$3"
REGION="$4"

# Esegui update-stack
aws cloudformation update-stack \
  --stack-name "$STACK_NAME" \
  --template-body "file://$TEMPLATE_FILE" \
  --parameters "file://$PARAMETERS_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ Stack aggiornato con successo: $STACK_NAME"
elif [ $EXIT_CODE -eq 255 ]; then
  echo "⚠️ Nessuna modifica da apportare allo stack: $STACK_NAME"
else
  echo "❌ Errore durante l'aggiornamento dello stack ($STACK_NAME), codice: $EXIT_CODE"
fi
