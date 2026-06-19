#!/usr/bin/env bash
# Publica evidencia visual en la pestaña Discussion de Azure DevOps (System.History).
#
# Uso:
#   export ADO_PAT_BAYTEQ_JUANCA_ALTAMIRANO='<pat>'
#   ./ado-post-discussion-with-images.sh <work-item-id> <titulo> <imagen1.png> [imagen2.png ...]
#
# Ejemplo (bug 29985):
#   ./ado-post-discussion-with-images.sh 29985 "Evidencia bug 29985" \
#     user-stories/US-29912-microfrontend/evidence/bug-29985/variant-b-mobile-initial.png \
#     user-stories/US-29912-microfrontend/evidence/bug-29985/variant-b-mobile-header.png
#
# Requisitos: curl, python3
# Referencia: challenge-ab-testing-specs/scripts/README-ado-comments.md

set -euo pipefail

ORG="BayteqDev"
PROJECT="Reto%20BBolivariano"
PROJECT_ID="f07bef20-7f19-4f7d-ad5f-5022ff3db3a0"
API_VERSION_ATTACH="7.1"
API_VERSION_WI="7.1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ -z "${ADO_PAT_BAYTEQ_JUANCA_ALTAMIRANO:-}" ]]; then
  echo "Error: define ADO_PAT_BAYTEQ_JUANCA_ALTAMIRANO" >&2
  exit 1
fi

if [[ $# -lt 3 ]]; then
  echo "Uso: $0 <work-item-id> <titulo> <imagen> [imagen...]" >&2
  exit 1
fi

WORK_ITEM_ID="$1"
TITLE="$2"
shift 2

AUTH_HEADER="Authorization: Basic ${ADO_PAT_BAYTEQ_JUANCA_ALTAMIRANO}"
BASE_URL="https://dev.azure.com/${ORG}"

declare -a GUIDS=()
declare -a NAMES=()

upload_and_link() {
  local file_path="$1"
  local file_name
  file_name="$(basename "${file_path}")"

  local response
  response="$(curl -sS -X POST \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/octet-stream" \
    --data-binary @"${file_path}" \
    "${BASE_URL}/_apis/wit/attachments?fileName=${file_name}&api-version=${API_VERSION_ATTACH}")"

  local url guid
  url="$(python3 -c "import json,sys; print(json.load(sys.stdin)['url'])" <<< "${response}")"
  guid="$(python3 -c "import re,sys; m=re.search(r'/attachments/([0-9a-f-]+)', sys.stdin.read()); print(m.group(1))" <<< "${url}")"

  local patch
  patch="$(python3 -c "import json; print(json.dumps([{'op':'add','path':'/relations/-','value':{'rel':'AttachedFile','url':'${url}','attributes':{'comment':'${TITLE} — ${file_name}'}}}]))")"

  curl -sS -X PATCH \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/json-patch+json" \
    -d "${patch}" \
    "${BASE_URL}/${PROJECT}/_apis/wit/workitems/${WORK_ITEM_ID}?api-version=${API_VERSION_WI}" \
    > /dev/null

  GUIDS+=("${guid}")
  NAMES+=("${file_name}")
}

resolve_path() {
  local input="$1"
  if [[ -f "${input}" ]]; then
    printf '%s\n' "${input}"
    return
  fi
  if [[ -f "${SPECS_ROOT}/${input}" ]]; then
    printf '%s\n' "${SPECS_ROOT}/${input}"
    return
  fi
  echo "No se encontró la imagen: ${input}" >&2
  exit 1
}

for image_arg in "$@"; do
  resolved="$(resolve_path "${image_arg}")"
  upload_and_link "${resolved}"
done

export TITLE ORG PROJECT_ID
GUIDS_JSON="$(python3 -c "import json,sys; print(json.dumps(sys.argv[1:]))" "${GUIDS[@]}")"
NAMES_JSON="$(python3 -c "import json,sys; print(json.dumps(sys.argv[1:]))" "${NAMES[@]}")"
export GUIDS_JSON NAMES_JSON

HISTORY_PAYLOAD="$(python3 << 'PY'
import json, os
org = os.environ['ORG']
project_id = os.environ['PROJECT_ID']
guids = json.loads(os.environ['GUIDS_JSON'])
names = json.loads(os.environ['NAMES_JSON'])
title = os.environ['TITLE']
parts = [f'<div><b>{title}</b> </div>', '<div><br> </div>']
for i, (guid, name) in enumerate(zip(guids, names), start=1):
    caption = name.rsplit('.', 1)[0]
    url = f"https://dev.azure.com/{org}/{project_id}/_apis/wit/attachments/{guid}?fileName={name}"
    parts.append(f'<div><b>{i}. {caption}</b> </div>')
    parts.append(f'<div><img src="{url}" alt="{caption}"> </div>')
    parts.append('<div><br> </div>')
print(json.dumps([{'op': 'add', 'path': '/fields/System.History', 'value': '\n'.join(parts)}]))
PY
)"

curl -sS -X PATCH \
  -H "${AUTH_HEADER}" \
  -H "Content-Type: application/json-patch+json" \
  -d "${HISTORY_PAYLOAD}" \
  "${BASE_URL}/${PROJECT}/_apis/wit/workitems/${WORK_ITEM_ID}?api-version=${API_VERSION_WI}" \
  > /dev/null

echo "Work item: ${WORK_ITEM_ID}"
echo "Discussion actualizada (System.History)"
echo "URL: ${BASE_URL}/${PROJECT}/_workitems/edit/${WORK_ITEM_ID}"
