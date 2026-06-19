# Comentarios en Azure DevOps con imágenes inline

Procedimiento validado en el proyecto **Reto BBolivariano** (bug #29984, jun 2026).

## Resumen

Para que las imágenes **se vean inline** (no solo en la sección Attachments), hay que:

1. **Subir** cada imagen con la API de adjuntos.
2. **Vincular** cada adjunto al work item (`AttachedFile`).
3. **Publicar en Discussion** vía `System.History` con URLs completas del proyecto (formato validado en #29984 y #29985).

> **Pestaña Discussion (recomendada):** usar `System.History` con  
> `https://dev.azure.com/BayteqDev/f07bef20-…/_apis/wit/attachments/{guid}?fileName=…`  
> La API de **Comments** (`vstfs://`) es un canal distinto; ADO puede duplicar `System.History` en Comments con URLs rotas — ignorar esa copia y revisar **Discussion**.

## Script reutilizable

```bash
export ADO_PAT_BAYTEQ_JUANCA_ALTAMIRANO='<pat>'

./scripts/ado-post-comment-with-images.sh 29984 "Evidencia bug 29984" \
  user-stories/US-29912-microfrontend/evidence/bug-29984/variant-a-desktop-initial.png \
  user-stories/US-29912-microfrontend/evidence/bug-29984/variant-a-desktop-mfe.png \
  user-stories/US-29912-microfrontend/evidence/bug-29984/variant-a-desktop-coverages.png
```

El script publica **Comments (`vstfs://`) + Discussion (`System.History`)**.  
Si solo necesitas **Discussion**, usa el flujo manual del §4 o `./scripts/ado-post-discussion-with-images.sh`.

## Constantes del proyecto

| Variable | Valor |
|----------|-------|
| Organización | `BayteqDev` |
| Proyecto | `Reto BBolivariano` |
| Project ID | `f07bef20-7f19-4f7d-ad5f-5022ff3db3a0` |
| PAT (env) | `ADO_PAT_BAYTEQ_JUANCA_ALTAMIRANO` |

## Flujo manual (paso a paso)

### 1. Subir imagen

```http
POST https://dev.azure.com/BayteqDev/_apis/wit/attachments?fileName=evidencia.png&api-version=7.1
Content-Type: application/octet-stream
Authorization: Basic <PAT en base64>

<bytes del PNG>
```

Respuesta → campo `url` y GUID en la ruta (`.../attachments/{guid}`).

### 2. Vincular al work item

```http
PATCH https://dev.azure.com/BayteqDev/Reto%20BBolivariano/_apis/wit/workitems/{id}?api-version=7.1
Content-Type: application/json-patch+json

[
  {
    "op": "add",
    "path": "/relations/-",
    "value": {
      "rel": "AttachedFile",
      "url": "https://dev.azure.com/BayteqDev/_apis/wit/attachments/{guid}",
      "attributes": { "comment": "Evidencia visual" }
    }
  }
]
```

> **Importante:** sin este paso, las referencias `vstfs://` en el comentario no renderizan la imagen.

### 3. Publicar comentario con imágenes inline (forma correcta)

```http
POST https://dev.azure.com/BayteqDev/Reto%20BBolivariano/_apis/wit/workitems/{id}/comments?api-version=7.1-preview.4
Content-Type: application/json

{
  "text": "<div><b>Evidencia</b></div><div><img src=\"vstfs:///Attachments/{guid}\" alt=\"captura\"></div>",
  "format": "html"
}
```

### 4. Discussion (pestaña recomendada para evidencia visual)

```http
PATCH .../workitems/{id}?api-version=7.1

[
  {
    "op": "add",
    "path": "/fields/System.History",
    "value": "<div><b>Evidencia</b> </div><div><img src=\"https://dev.azure.com/BayteqDev/f07bef20-7f19-4f7d-ad5f-5022ff3db3a0/_apis/wit/attachments/{guid}?fileName=evidencia.png\" alt=\"captura\"> </div>"
  }
]
```

Aparece en la pestaña **Discussion** del work item. Usar siempre la URL con **project ID** y `?fileName=`.

## Qué NO funciona

| Enfoque | Problema |
|---------|----------|
| Solo adjuntar archivos al work item | Las imágenes quedan en **Attachments**, no en el cuerpo del comentario |
| Comentario solo en Markdown/texto plano | No embebe imágenes |
| `<img src="data:image/png;base64,...">` | ADO elimina o trunca el `src` |
| `<img src="https://dev.azure.com/.../attachments/{guid}">` en **Comments API** | ADO reescribe la URL a una ruta relativa rota |
| `vstfs://` sin vincular el adjunto al work item | La imagen no resuelve en la UI |

## Dónde ver las imágenes en ADO

1. **Discussion** → entrada con `System.History` y URLs completas (**canal principal**).
2. **Attachments** → descarga directa (respaldo).
3. **Comments** → solo si se publicó con `vstfs://` vía Comments API (canal distinto; no confundir con Discussion).

## Captura de evidencia (Playwright)

Para generar PNG antes de subirlos a ADO:

```bash
cd challenge-ab-testing-host
npx playwright test e2e/bug-29984-evidence.spec.ts --project=chromium-desktop
```

Salida por defecto: `challenge-ab-testing-specs/user-stories/US-29912-microfrontend/evidence/bug-29984/`.

## Checklist para agentes

- [ ] Capturas generadas y guardadas en `challenge-ab-testing-specs/.../evidence/`
- [ ] Imágenes subidas y **vinculadas** al work item
- [ ] Entrada en `System.History` (Discussion) con URL completa + `?fileName=`
- [ ] Verificar en ADO pestaña **Discussion** (hard refresh si hace falta)
