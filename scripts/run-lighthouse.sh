#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-5500}"
URL="${LIGHTHOUSE_URL:-http://127.0.0.1:${PORT}/}"
REPORT_PATH="${LIGHTHOUSE_REPORT_PATH:-.lighthouse-report.json}"
THRESHOLD="${LIGHTHOUSE_THRESHOLD:-0.9}"
LIGHTHOUSE_TMP_DIR="${LIGHTHOUSE_TMP_DIR:-/tmp/isbhuvan-lighthouse}"
LIGHTHOUSE_WSL_APPDATA_DIR="${LIGHTHOUSE_WSL_APPDATA_DIR:-/mnt/d/Users/${USER:-isbhuvan}/AppData/Local}"

mkdir -p "${LIGHTHOUSE_TMP_DIR}"
export TMPDIR="${LIGHTHOUSE_TMP_DIR}"
export TMP="${LIGHTHOUSE_TMP_DIR}"
export TEMP="${LIGHTHOUSE_TMP_DIR}"
export APPDATA="${LIGHTHOUSE_TMP_DIR}"
export LOCALAPPDATA="${LIGHTHOUSE_TMP_DIR}"

if mkdir -p "${LIGHTHOUSE_WSL_APPDATA_DIR}" 2>/dev/null; then
  export PATH="${LIGHTHOUSE_WSL_APPDATA_DIR}:${PATH}"
fi

python3 -m http.server "${PORT}" >/tmp/isbhuvan-lighthouse.log 2>&1 &
SERVER_PID=$!

cleanup() {
  kill "${SERVER_PID}" 2>/dev/null || true
  rm -f "${REPORT_PATH}"
}

trap cleanup EXIT

for _ in $(seq 1 20); do
  if curl --silent --fail "${URL}" >/dev/null; then
    break
  fi
  sleep 1
done

npx lighthouse "${URL}" \
  --quiet \
  --chrome-flags="--headless=new --no-sandbox" \
  --only-categories=performance,accessibility,best-practices,seo \
  --output=json \
  --output-path="${REPORT_PATH}"

node -e '
const fs = require("fs");
const report = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
const threshold = Number(process.argv[2]);
const categories = ["performance", "accessibility", "best-practices", "seo"];
const failures = [];

for (const key of categories) {
  const score = report.categories[key]?.score ?? 0;
  console.log(`${key}: ${Math.round(score * 100)}`);
  if (score < threshold) {
    failures.push(`${key} (${Math.round(score * 100)}/${Math.round(threshold * 100)})`);
  }
}

if (failures.length > 0) {
  console.error(`Lighthouse thresholds failed: ${failures.join(", ")}`);
  process.exit(1);
}
' "${REPORT_PATH}" "${THRESHOLD}"
