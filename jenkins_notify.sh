#!/bin/bash
# ---------------------------------------------------
# ✅ Jenkins Gmail Notification Script (msmtp version)
# ✅ Designed & Developed by: sak_shetty
# ---------------------------------------------------

LOG_DIR="./notify_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/jenkins_notify_$(date +%F).log"

STATUS="$1"
JOB_NAME="$2"
BUILD_ID="$3"
TO_EMAIL="$4"

GMAIL_USER="${GMAIL_USER}"
GMAIL_APP_PASS="${GMAIL_APP_PASS}"

if [ -z "$STATUS" ] || [ -z "$JOB_NAME" ] || [ -z "$BUILD_ID" ] || [ -z "$TO_EMAIL" ]; then
  echo "❌ Missing arguments. Usage:" | tee -a "$LOG_FILE"
  echo "./jenkins_notify.sh <STATUS> <JOB_NAME> <BUILD_ID> <TO_EMAIL>" | tee -a "$LOG_FILE"
  exit 1
fi

# ✅ Install msmtp if missing
if ! command -v msmtp >/dev/null 2>&1; then
  echo "📦 Installing msmtp & mailutils..." | tee -a "$LOG_FILE"
  sudo apt-get update -y >> "$LOG_FILE" 2>&1
  sudo apt-get install -y msmtp mailutils >> "$LOG_FILE" 2>&1
fi

# ✅ Configure msmtp
cat > ./msmtprc <<EOF
defaults
auth           on
tls            on
tls_starttls   on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account        gmail
host           smtp.gmail.com
port           587
from           $GMAIL_USER
user           $GMAIL_USER
password       $GMAIL_APP_PASS
account default : gmail
logfile        $LOG_FILE
EOF

chmod 600 ./msmtprc

SUBJECT="Jenkins Build - $JOB_NAME (#$BUILD_ID) - $STATUS"

# ✅ HTML Email body
EMAIL_CONTENT=$(cat <<EOF
Subject: $SUBJECT
From: $GMAIL_USER
To: $TO_EMAIL
Content-Type: text/html

<!DOCTYPE html>
<html>
<head>
<style>
body { font-family: Arial, sans-serif; background:#f7f7f7; padding:25px; }
.card {
  background:#ffffff; padding:20px; border-radius:8px;
  border:1px solid #ddd; max-width:500px;
}
h2 { color:#2e7d32; margin-top:0; }
p { font-size:14px; }
.status-success { color:#28a745; font-weight:bold; }
.status-failure { color:#d32f2f; font-weight:bold; }
.footer { font-size:12px; margin-top:20px; color:#555; }
</style>
</head>

<body>
<div class="card">
<h2>Jenkins Build Notification</h2>

<p><b>Project:</b> $JOB_NAME</p>
<p><b>Build ID:</b> $BUILD_ID</p>
<p><b>Status:</b>
  <span class="status-$([ "$STATUS" = "SUCCESS" ] && echo "success" || echo "failure")">
  $STATUS
  </span>
</p>
<p><b>Timestamp:</b> $(date)</p>

<hr>
<p class="footer">🚀 Designed & Developed by <b>sak_shetty</b></p>
</div>
</body>
</html>
EOF
)

echo "$EMAIL_CONTENT" | msmtp --file=./msmtprc -a gmail "$TO_EMAIL"

echo "✅ HTML Email sent at $(date)" | tee -a "$LOG_FILE"
exit 0
