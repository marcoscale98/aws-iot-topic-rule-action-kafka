#!/usr/bin/env bash

# Script guidato per generare keystore e truststore, codificarli in Base64
# e preparare i valori per il template CloudFormation di AWS IoT → MSK.
#
# Questo programma ti guiderà passo-passo:
# 1) Verifica che keytool e base64 siano installati.
# 2) Genera un keystore JKS per l'autenticazione TLS (client).
# 3) Importa un certificato CA in un truststore JKS.
# 4) Converte entrambi i file in Base64.
# 5) Stampa i parametri da incollare nel template CloudFormation.
#
# Usa parole semplici, ogni passaggio è descritto chiaramente.

echo "Benvenuto! Questo script ti aiuta a creare i segreti (keystore e truststore)"
echo "necessari per configurare la tua IoT Topic Rule con Amazon MSK."
echo "Segui le istruzioni semplici a video per ottenere i valori pronti da incollare nel tuo template CFN."
echo

set -e

# Funzione per controllare la presenza di un tool
check_tool() {
  local tool=$1
  if ! command -v "$tool" &> /dev/null; then
    echo "Errore: '$tool' non è installato. Per favore, installalo prima di procedere." >&2
    exit 1
  fi
}

echo "=== Passo 0: Verifica degli strumenti necessari ==="
echo "Controllo se 'keytool' e 'base64' sono disponibili nel sistema..."
check_tool keytool
check_tool base64
echo

echo "Ok! Tutti gli strumenti richiesti sono installati."
echo

# Passo 1: Generazione del keystore
echo "=== Passo 1: Generazione del Keystore JKS ==="
echo "Ti verrà chiesto di inserire un nome file per il keystore e una password a tua scelta."
read -p "Inserisci il nome del keystore (es. keystore.jks): " KEYSTORE_FILE
read -s -p "Scegli una password per il keystore (KeystorePassword): " KEYSTORE_PASS
echo -e "\n"
echo "Genero il keystore '$KEYSTORE_FILE' con keytool..."
keytool -genkeypair \
  -alias iot-client \
  -keyalg RSA \
  -keystore "$KEYSTORE_FILE" \
  -storepass "$KEYSTORE_PASS" \
  -dname "CN=iot-client" \
  -validity 365

if [[ -f "$KEYSTORE_FILE" ]]; then
  echo "✅ Keystore '$KEYSTORE_FILE' creato con successo."
else
  echo "❌ Errore nella creazione del keystore." >&2
  exit 1
fi

echo

echo
# Passo 3: Codifica Base64
echo "=== Passo 3: Codifica in Base64 ==="
echo "Sto convertendo '$KEYSTORE_FILE' in stringhe Base64..."
KEYSTORE_B64=$(base64 -w0 "$KEYSTORE_FILE")
echo "Conversione completata."

echo
# Passo 4: Output dei valori
echo "=== Passo 4: Valori finali per CloudFormation ==="
echo "Copia i seguenti valori e incollali nei parametri del tuo template CloudFormation:"
echo

echo "-- KeystoreBase64 (contenuto base64 di $KEYSTORE_FILE):"
echo "$KEYSTORE_B64"
echo

echo "-- KeystorePassword (la password scelta per il keystore):"
echo "$KEYSTORE_PASS"
echo

echo "=== Script completato! ==="
echo "Ora hai tutti i valori necessari per il deployment."
