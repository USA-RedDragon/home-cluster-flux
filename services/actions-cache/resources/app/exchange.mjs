import { readFileSync, writeFileSync, renameSync } from "node:fs"

const tokenUrl = process.env.AUTHENTIK_TOKEN_URL
const clientId = process.env.AUTHENTIK_CLIENT_ID
const saTokenFile = process.env.SA_TOKEN_FILE
const outFile = process.env.EXCHANGED_TOKEN_FILE
const minRefreshSeconds = Number(process.env.MIN_REFRESH_SECONDS ?? 30)
const maxRefreshSeconds = Number(process.env.MAX_REFRESH_SECONDS ?? 1800)
const scope = process.env.AUTHENTIK_SCOPE ?? "openid profile"

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

async function exchange() {
  const assertion = readFileSync(saTokenFile, "utf8").trim()
  const body = new URLSearchParams({
    grant_type: "client_credentials",
    client_id: clientId,
    client_assertion_type: "urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
    client_assertion: assertion,
    scope,
  })

  const res = await fetch(tokenUrl, {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body,
  })
  if (!res.ok) {
    throw new Error(`authentik ${res.status}: ${(await res.text()).slice(0, 400)}`)
  }

  const payload = await res.json()
  const token = payload.id_token ?? payload.access_token
  if (!token) throw new Error("authentik returned neither id_token nor access_token")

  writeFileSync(`${outFile}.tmp`, token, { mode: 0o600 })
  renameSync(`${outFile}.tmp`, outFile)

  const claims = JSON.parse(Buffer.from(token.split(".")[1], "base64url").toString())
  console.log(`exchanged: user=${claims.preferred_username} aud=${claims.aud} exp=${new Date(claims.exp * 1000).toISOString()}`)
  if (!claims.preferred_username) console.error("WARNING: no preferred_username claim; MinIO writes will be denied")

  const lifetime = claims.exp - claims.iat
  const next = Math.min(Math.max(Math.floor(lifetime / 2), minRefreshSeconds), maxRefreshSeconds)
  console.log(`token lifetime ${lifetime}s, next exchange in ${next}s`)
  return next
}

let backoff = 5
for (;;) {
  try {
    const next = await exchange()
    backoff = 5
    await sleep(next * 1000)
  } catch (err) {
    console.error(`exchange failed: ${err.message}`)
    await sleep(backoff * 1000)
    backoff = Math.min(backoff * 2, 120)
  }
}
