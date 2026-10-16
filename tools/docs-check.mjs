#!/usr/bin/env node
// tools/docs-check.mjs — the framework repository's mechanical documentation check.
//
// Why it exists: the payload — the files setup copies into a project — must carry nothing
// that only makes sense in this repository, and the documentation must agree with what
// exists. Every drift of that kind was found by reading, release after release, some of it
// only at a project's upgrade: a number of this repository's IMP backlog colliding with the
// project's own, a pointer to a file a project does not have, a checklist that called
// itself complete and missed six slots, a release tagged with its CHANGELOG entry still
// unwritten. This check finds them in the release that writes them.
//
// What it promises:
//   - it READS the repository — its files, its tags, its commits — and writes nothing;
//   - each finding is a line OK, FAIL (a rule below is broken) or CHECK (a human looks);
//     the exit code is 1 when any line is FAIL, 2 on a usage or environment error, 0
//     otherwise;
//   - what its rules cannot tell apart is declared in ALLOW, each entry with its reason;
//     an entry that no longer matches anything fails, so an exception never outlives its
//     cause.
//
// It lives in tools/, outside the payload: setup never copies it into a project. `make
// test-scripts` runs it here, after its self-test (tools/test-docs-check.sh), and skips
// both where tools/ is absent. Run it from anywhere inside the repository:
//   node tools/docs-check.mjs
// Needs git and Node.js 22.12 or later, the framework's minimum; no dependency.

import { execFileSync } from 'node:child_process'
import { existsSync, readFileSync, statSync } from 'node:fs'
import { join, posix } from 'node:path'

// --- Reporting: the lines of tools/upgrade-check.sh, so the two read alike ---------------
let nFail = 0
let nCheck = 0
const say = (tag, m) => console.log(`${tag.padEnd(6)} ${m}`)
const ok = (m) => say('OK', m)
const fail = (m) => { say('FAIL', m); nFail++ }
const check = (m) => { say('CHECK', m); nCheck++ }
const section = (m) => console.log(`\n== ${m}`)
const die = (m) => { console.error(`docs-check: ${m}`); process.exit(2) }
// An error of the check itself — a file it needs missing, a bug — is never a verdict: it
// exits 2, wherever it happens, before the checks or during them.
process.on('uncaughtException', (e) => die(`the check itself failed — ${e?.stack ?? e}`))
const plural = (n, one, many = `${one}s`) => `${n} ${n === 1 ? one : many}`

// --- The repository ----------------------------------------------------------------------
// Every git call reads a fixed format, whatever the user's configuration.
const GIT_FIXED = ['-c', 'color.ui=false', '-c', 'core.quotePath=false', '-c', 'log.showSignature=false',
  '-c', 'i18n.logOutputEncoding=UTF-8']
const gitAt = (cwd, args) => execFileSync('git', [...GIT_FIXED, ...args], {
  cwd, encoding: 'utf8', maxBuffer: 256 << 20, stdio: ['ignore', 'pipe', 'pipe'],
})
let ROOT
try { ROOT = gitAt(process.cwd(), ['rev-parse', '--show-toplevel']).trim() } catch {
  die('not inside a git repository: run it inside the framework repository')
}
const git = (args) => gitAt(ROOT, args)
// gitOr(args): git's output, or null when the command fails (a missing revision).
const gitOr = (args) => { try { return git(args) } catch { return null } }
// blob(rev, path): a file at a revision, its line ends normalised; null when absent.
const blob = (rev, path) => gitOr(['show', `${rev}:${path}`])?.replace(/\r\n/g, '\n') ?? null

// The working tree as it is: tracked and new files, never ignored or deleted ones — so a
// file is checked before its first commit.
const FILES = [...new Set(git(['ls-files', '-z', '--cached', '--others', '--exclude-standard']).split('\0'))]
  .filter((p) => p && existsSync(join(ROOT, p)) && statSync(join(ROOT, p)).isFile())
  .sort()
const FILESET = new Set(FILES)
const isDir = (d) => FILES.some((p) => p.startsWith(`${d.replace(/\/$/, '')}/`))
const cache = new Map()
// text(p): a file's text, its line ends normalised (a Windows checkout writes CRLF); ''
// for a binary one.
function text(p) {
  if (!cache.has(p)) {
    const buf = readFileSync(join(ROOT, p))
    cache.set(p, buf.includes(0) ? '' : buf.toString('utf8').replace(/\r\n/g, '\n'))
  }
  return cache.get(p)
}
const lines = (p) => text(p).split('\n')
const isMd = (p) => p.endsWith('.md')
const isSelfTest = (p) => /^(scripts|tools)\/test-[^/]+\.sh$/.test(p)

// --- The payload -------------------------------------------------------------------------
// What setup copies into a project. Its paths are read from tools/upgrade-check.sh, where a
// program already reads them; SECURITY.md is the scaffold setup offers next to them. Of the
// framework's own memory, setup copies the templates only: no session note, and of
// LEARNINGS.md only the header, the titles and the format comment.
const UPGRADE_CHECK = 'tools/upgrade-check.sh'
if (!FILESET.has(UPGRADE_CHECK)) die(`${UPGRADE_CHECK} not found: run it inside the framework repository`)
const PAYLOAD_PATHS = (() => {
  const m = /^readonly PAYLOAD_PATHS=\(([^)]*)\)/m.exec(text(UPGRADE_CHECK))
  if (!m) die(`no PAYLOAD_PATHS in ${UPGRADE_CHECK}`)
  return m[1].trim().split(/\s+/)
})()
const SCAFFOLDS = ['SECURITY.md']
const LEARNINGS = '.claude/memory/LEARNINGS.md'
const CHANGELOG = 'CHANGELOG.md'
const SETUP = 'SETUP.md'
const underPayload = (p) => PAYLOAD_PATHS.some((r) => p === r || p.startsWith(`${r}/`))
const isLiveNote = (p) => /^\.claude\/memory\/sessions\/(?!README\.md$)[^/]+$/.test(p)
const isPayload = (p) => SCAFFOLDS.includes(p) || (underPayload(p) && !isLiveNote(p))
const PAYLOAD = FILES.filter(isPayload)
if (PAYLOAD.length < 30) die(`only ${PAYLOAD.length} payload files under ${PAYLOAD_PATHS.join(' ')}: the payload's paths are wrong`)

// The lines of LEARNINGS.md that are the template: the header (before the first "## ") and
// the format comment (the <!-- --> blocks of the body). The rest is the backlog itself.
function learningsTemplate() {
  let header = true
  let comment = false
  return lines(LEARNINGS).map((l) => {
    if (header && /^## /.test(l)) header = false
    if (/^<!--/.test(l)) comment = true
    const keep = header || comment
    if (comment && /-->\s*$/.test(l)) comment = false
    return keep
  })
}
// payloadMask(p): for each line of a file, whether it is payload text.
const payloadMask = (p) => (p === LEARNINGS ? learningsTemplate() : lines(p).map(() => isPayload(p)))
// History by nature: what records past states is never rewritten to match the present —
// the CHANGELOG, the session notes, the IMP entries.
const isHistory = (p) => p === CHANGELOG || isLiveNote(p)
// presentMask(p): for each line, whether it describes the present (LEARNINGS.md: its template).
const presentMask = (p) => (p === LEARNINGS ? learningsTemplate() : lines(p).map(() => !isHistory(p)))
const allMask = (p) => lines(p).map(() => true)
const PRESENT = FILES.filter((p) => !isHistory(p) && p !== 'LICENSE')
// This check's own files: their word lists, legacy forms and planted defects are data.
const OWN = ['tools/docs-check.mjs', 'tools/test-docs-check.sh']

// --- Markdown, just enough of it ---------------------------------------------------------
// fencedMask(lines): true on every line of a fenced code block, its fences included.
function fencedMask(ls) {
  let fence = null
  return ls.map((l) => {
    const m = /^\s*(`{3,}|~{3,})(.*)$/.exec(l)
    if (fence) {
      if (m && m[1][0] === fence[0] && m[1].length >= fence.length && !m[2].trim()) fence = null
      return true
    }
    if (m) { fence = m[1]; return true }
    return false
  })
}
// blankOut(s, re): s with every match of re turned into spaces, so the offsets hold.
const blankOut = (s, re) => s.replace(re, (m) => ' '.repeat(m.length))
const CODE_SPAN = /`[^`\n]*`/g
// units(p, mask): the text of a file as units a sentence cannot cross — in markdown a
// paragraph, a list item with its continuation lines, a heading, a table row, outside fenced
// code and without the blockquote markers; in any other file, a line. Only the lines the
// mask keeps. A unit remembers the line of each of its characters, so a finding is reported
// where it is written.
function units(p, mask) {
  const ls = lines(p)
  const md = isMd(p)
  const fenced = md ? fencedMask(ls) : ls.map(() => false)
  const out = []
  let cur = null
  const flush = () => { if (cur) out.push(cur); cur = null }
  ls.forEach((raw, i) => {
    if (!mask[i] || fenced[i]) { flush(); return }
    if (!md) { out.push({ text: raw, at: Array.from({ length: raw.length + 1 }, () => i + 1) }); return }
    const l = raw.replace(/^\s*(>\s?)+/, '')
    if (!l.trim()) { flush(); return }
    if (/^\s*(#{1,6}\s|[-*+]\s|\d+[.)]\s|\|)/.test(l) || (cur && /^#{1,6}\s/.test(cur.text))) flush()
    if (!cur) cur = { text: '', at: [] }
    const piece = (cur.text ? ' ' : '') + l.trim()
    for (let k = 0; k < piece.length; k++) cur.at.push(i + 1)
    cur.text += piece
  })
  flush()
  for (const u of out) u.at.push(u.at[u.at.length - 1])
  return out
}
// sentenceAround(s, i): the bounds of the sentence of s that holds the offset i.
function sentenceAround(s, i) {
  let start = 0
  let end = s.length
  for (const m of s.matchAll(/[.!?;](?=\s+[\p{Lu}(*`"“[])/gu)) {
    if (/\b(?:e\.g|i\.e|etc|vs|cf)\.$/.test(s.slice(0, m.index + 1))) continue
    if (m.index < i) start = m.index + 1
    else { end = m.index + 1; break }
  }
  return [start, end]
}
// headings(p): the headings of a markdown file, outside fenced code.
function headings(p) {
  const ls = lines(p)
  const fenced = fencedMask(ls)
  return ls.flatMap((l, i) => {
    const m = !fenced[i] && /^(#{1,6})\s+(.*?)\s*#*\s*$/.exec(l)
    return m ? [{ level: m[1].length, title: m[2], line: i + 1 }] : []
  })
}
// slug(heading): the anchor GitHub gives a heading — its text without markup, lower-cased,
// punctuation dropped (letters, digits, '-', '_' and spaces kept), spaces made hyphens.
const slug = (h) => h.replace(/!?\[([^\]]*)\]\([^)]*\)/g, '$1').replace(/[`*]/g, '').trim()
  .toLowerCase().replace(/[^\p{L}\p{M}\p{N}\s_-]/gu, '').replace(/\s/g, '-')
// anchors(p): every anchor of a markdown file, the duplicates numbered as GitHub does.
function anchors(p) {
  const seen = new Map()
  return new Set(headings(p).map(({ title }) => {
    const base = slug(title)
    const n = seen.get(base) ?? 0
    seen.set(base, n + 1)
    return n ? `${base}-${n}` : base
  }))
}
// region(p, start, stop): the lines of p after the first line matching start, up to the
// next line matching stop (both excluded), with their numbers.
function region(p, start, stop) {
  const ls = lines(p)
  const from = ls.findIndex((l) => start.test(l))
  if (from < 0) return []
  const out = []
  for (let i = from + 1; i < ls.length && !stop.test(ls[i]); i++) out.push({ text: ls[i], line: i + 1 })
  return out
}
// item(p, re): the list item or paragraph whose first line matches re, with its
// continuation lines, as one string and its first line's number.
function item(p, re) {
  const ls = lines(p)
  const i = ls.findIndex((l) => re.test(l))
  if (i < 0) return null
  let j = i + 1
  while (j < ls.length && ls[j].trim() && !/^\s*([-*+]|\d+\.)\s/.test(ls[j]) && !/^#/.test(ls[j])) j++
  return { text: ls.slice(i, j).join(' '), line: i + 1 }
}
const backticked = (s) => [...s.matchAll(/`([^`\n]+)`/g)].map((m) => m[1])
const NUMBER_WORDS = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten',
  'eleven', 'twelve']

// --- Versions ----------------------------------------------------------------------------
const cmpVer = (a, b) => {
  const x = a.split('.').map(Number)
  const y = b.split('.').map(Number)
  for (let i = 0; i < Math.max(x.length, y.length); i++) if ((x[i] ?? 0) !== (y[i] ?? 0)) return (x[i] ?? 0) - (y[i] ?? 0)
  return 0
}
// The release tags, vX.Y.Z: their object type (an annotated tag is a "tag" object) and the
// tagger's date, in the tagger's own time zone.
const TAGS = git(['for-each-ref', '--format=%(refname:lstrip=2)%09%(objecttype)%09%(taggerdate:short)', 'refs/tags'])
  .split('\n').filter(Boolean).map((l) => l.split('\t'))
  .filter(([name]) => /^v\d+\.\d+\.\d+$/.test(name))
  .map(([name, type, date]) => ({ name, version: name.slice(1), type, date }))
  .sort((a, b) => cmpVer(b.version, a.version))
const LATEST_TAG = TAGS[0]
const ENTRY_RE = /^## \[(\d+\.\d+\.\d+)\] — (\d{4}-\d{2}-\d{2})$/
const ENTRIES = lines(CHANGELOG).flatMap((l, i) => {
  const m = ENTRY_RE.exec(l)
  return m ? [{ version: m[1], date: m[2], line: i + 1 }] : []
})
// The latest date a pending entry may carry: tomorrow, by this machine's clock — its author
// dated it in their own time zone, which may be a day ahead of this one.
const LATEST_DATE = (() => {
  const d = new Date(Date.now() + 864e5)
  const p = (n) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`
})()
// The release being prepared: the topmost CHANGELOG entry without a tag, when it is one
// SemVer step above the latest tag — its tag comes after the merge.
const PENDING = (() => {
  const top = ENTRIES[0]
  if (!top || !LATEST_TAG || TAGS.some((t) => t.version === top.version)) return null
  const [a, b, c] = LATEST_TAG.version.split('.').map(Number)
  return [`${a}.${b}.${c + 1}`, `${a}.${b + 1}.0`, `${a + 1}.0.0`].includes(top.version) ? top : null
})()
const CURRENT = PENDING?.version ?? LATEST_TAG?.version

// --- Findings and the allow-list ---------------------------------------------------------
// A finding is {file, line, text, message}, text being the line it is on (for a file name,
// the name). An ALLOW entry covers the findings of its check in its file ('*': any file)
// whose MESSAGE holds its `text` — the subject of the finding, never the rest of its line,
// so another finding on the same line stays visible; with `line`, those whose line holds
// it; with `section`, every finding under the heading that holds it. Each entry carries its
// reason, and must cover at least one finding.
const findings = new Map()
function report(id, file, line, message, textOverride) {
  const t = textOverride ?? (file && line ? lines(file)[line - 1] ?? '' : '')
  if (!findings.has(id)) findings.set(id, [])
  findings.get(id).push({ file, line, text: t, message })
}
// headingOver(p, line): the text of the last heading at or above a line.
function headingOver(p, line) {
  const hs = headings(p).filter((h) => h.line <= line)
  return hs.length ? hs[hs.length - 1].title : ''
}
const covers = (a, id, f) => a.check === id && (a.file === '*' || a.file === f.file)
  && (a.section ? Boolean(f.file && f.line) && headingOver(f.file, f.line).includes(a.section)
    : a.line ? f.text.includes(a.line) : f.message.includes(a.text))
// settle(id, what): the check's findings, minus what ALLOW declares — a FAIL line for each,
// or one OK line saying what was checked.
function settle(id, what) {
  let declared = 0
  const left = (findings.get(id) ?? []).filter((f) => {
    const a = ALLOW.find((e) => covers(e, id, f))
    if (!a) return true
    a.used = (a.used ?? 0) + 1
    declared++
    return false
  })
  for (const f of left) fail(f.file ? `${f.file}${f.line ? `:${f.line}` : ''}: ${f.message}` : f.message)
  if (!left.length) ok(`${what}${declared ? ` (${plural(declared, 'declared exception')})` : ''}`)
}
// compareSets(id, file, line, label, truth, listed, source): a list against the set it
// enumerates, both ways.
function compareSets(id, file, line, label, truth, listed, source) {
  for (const x of truth) if (!listed.has(x)) report(id, file, line, `${label} lacks ${x} (${source})`)
  for (const x of listed) if (!truth.has(x)) report(id, file, line, `${label} names ${x}, which is not in ${source}`)
}

// --- The payload: no framework IMP number ------------------------------------------------
// A project numbers its own IMPs from 001: a number of this repository's backlog is an
// orphan there, or collides with an unrelated lesson of the project's. The why stays in
// prose; the provenance in the CHANGELOG, LEARNINGS.md and the commits.
function checkImpNumbers() {
  section('Payload — no IMP number of the framework\'s backlog')
  let scanned = 0
  for (const p of PAYLOAD) {
    const mask = payloadMask(p)
    lines(p).forEach((l, i) => {
      if (!mask[i]) return
      scanned++
      for (const m of l.matchAll(/\bIMP-\d+\b/g)) report('imp-number', p, i + 1, `${m[0]}: a number of the framework's backlog in the payload — keep the why in prose`)
    })
  }
  settle('imp-number', `no framework IMP number in ${plural(PAYLOAD.length, 'payload file')} (${scanned} lines)`)
}


// --- The payload: no pointer to a file a project does not have ---------------------------
// A project has none of the framework repository's own files: its README, SETUP.md,
// CONTRIBUTING.md, CHANGELOG.md, LICENSE, tools/, its session notes. A pointer that assumes
// one is local is rephrased; one that must cross to the framework says so — "the
// framework's `SETUP.md`" — in the same sentence; a conditional one ("where present", "if
// the project keeps one") is harmless. A pointer is a name or a section of those files, or
// a link, a cited path, an @-import or a wikilink that resolves to one.
const OUTSIDE = [
  { re: /(?<![\w./-])SETUP\.md\b|(?<![\w./-])SETUP\s*§|(?<![\w./-])§\s?\d/g, target: () => 'SETUP.md' },
  { re: /\b[Ss]tep \d+ of the upgrade\b|\bupgrade(?:'s)? [Ss]tep \d+\b|\bsetup step \d+\b|\*Hardening\*/g, target: () => 'SETUP.md' },
  { re: /(?<![\w./-])CONTRIBUTING(?:\.md)?\b/g, target: () => 'CONTRIBUTING.md' },
  { re: /(?<![\w./-])CHANGELOG(?:\.md)?\b/g, target: () => 'CHANGELOG.md' },
  { re: /(?<![\w./-])LICENSE\b/g, target: () => 'LICENSE' },
  { re: /(?<![\w./-]|this |This |its )README(?:\.md)?\b(?! of\b)/g, target: () => 'README.md' },
  { re: /`tools\/`?|(?<![\w./-])tools\/[\w.-]+\.(?:sh|mjs|md)\b/g, target: (m) => m.replace(/`/g, '') },
]
const LABEL = /\bthe framework(?:'s|’s)\b|\bframework(?:'s|’s)? repo(?:sitory)?\b|\bof the framework\b/gi
const CONDITION = /\b(?:where present|if present|when present|where (?:a copy|one) is kept|if (?:the|a) project keeps|if (?:a |the )?`?[\w./-]+`? exists)\b|\bif \[ -[efd] /i
// outsideOf(paths): the first of the paths a token resolves to, when none is in the
// payload — a directory counts as payload when it holds a payload file.
const inPayload = (x) => (FILESET.has(x) ? isPayload(x) : FILES.some((f) => f.startsWith(`${x.replace(/\/$/, '')}/`) && isPayload(f)))
const outsideOf = (paths) => (paths && paths.length && !paths.some(inPayload) ? paths[0] : null)
function checkPointers() {
  section('Payload — no pointer to a file outside it, unless labelled or conditional')
  let pointers = 0
  for (const p of PAYLOAD) {
    for (const u of units(p, payloadMask(p))) {
      // Every mention is judged on its own sentence; a line names a target once in the
      // report, however many of its mentions are bare.
      const hits = new Map()
      const hit = (index, token, target) => {
        if (!target) return
        const key = `${u.at[index]}|${target.replace(/\/$/, '')}`
        if (!hits.has(key)) hits.set(key, [])
        hits.get(key).push({ index, token, target })
      }
      for (const { re, target } of OUTSIDE) for (const m of u.text.matchAll(re)) hit(m.index, m[0], target(m[0]))
      const s = blankOut(u.text, CODE_SPAN)
      for (const m of s.matchAll(/\]\(([^)\s#?]+)[^)]*\)/g)) {
        if (/^[a-z][\w+.-]*:/i.test(m[1])) continue
        const c = posix.normalize(posix.join(posix.dirname(p), m[1]))
        hit(m.index, m[1], outsideOf(FILESET.has(c) || isDir(c) ? [c] : null))
      }
      for (const m of u.text.matchAll(/`([^`\n]+)`/g)) {
        if (m[1].includes('/') && PATHLIKE.test(m[1]) && !NOT_A_PATH.test(m[1])) hit(m.index, m[1], outsideOf(resolvePath(m[1], p)))
      }
      for (const m of u.text.matchAll(/(?:^|\s)@(\.claude\/[\w./-]+\.md)/g)) hit(m.index, m[1], outsideOf(FILESET.has(m[1]) ? [m[1]] : null))
      for (const m of s.matchAll(/\[\[([^\]|#\n]+)/g)) {
        const r = resolveWikilink(m[1])
        hit(m.index, m[1], r && r !== 'ambiguous' ? outsideOf([r]) : null)
      }
      for (const mentions of hits.values()) {
        pointers++
        const bare = mentions.find(({ index, token }) => {
          const [a, b] = sentenceAround(u.text, index)
          const labelled = [...u.text.slice(a, index + token.length + 40).matchAll(LABEL)]
            .some((l) => Math.abs(a + l.index - index) <= 80)
          return !labelled && !CONDITION.test(u.text.slice(a, b))
        })
        if (bare) report('pointer', p, u.at[bare.index], `"${bare.token.trim()}" points at ${bare.target}, which a project does not have: rephrase it, or say it is the framework's`)
      }
    }
  }
  settle('pointer', `${plural(pointers, 'pointer')} out of the payload, each labelled as the framework's or conditional`)
}

// --- The payload: every slot in the full form --------------------------------------------
// The setup and the upgrade find the slots with a grep for the full marker, in its English
// and its legacy Italian form. A slot in a short form, or broken by a line wrap anywhere
// inside its brackets, escapes both, and the upgrade check's slot tracking. The wraps are
// those tools/upgrade-check.sh already knows (BROKEN_MARKER_RE), read from it.
const MARKER_RE = /TO BE DEFINED AT SETUP|DA DEFINIRE AL SETUP/
const BROKEN_MARKER = (() => {
  const m = /^readonly BROKEN_MARKER_RE='([^']*)'/m.exec(text(UPGRADE_CHECK))
  if (!m) die(`no BROKEN_MARKER_RE in ${UPGRADE_CHECK}`)
  const js = m[1].replace(/\[\[:space:\]\]/g, '\\s')
  // Only [[:space:]] is translated: another POSIX class would silently mean something else.
  if (js.includes('[[:')) die(`BROKEN_MARKER_RE of ${UPGRADE_CHECK} uses a POSIX class this check does not translate`)
  return new RegExp(js)
})()
function checkShortSlots() {
  section('Payload — every slot in the full, grep-visible form')
  let slots = 0
  for (const p of PAYLOAD) {
    const mask = payloadMask(p)
    lines(p).forEach((l, i) => {
      if (!mask[i]) return
      slots += (l.match(new RegExp(MARKER_RE.source, 'g')) ?? []).length
      const short = /\[(TO BE DEFINED|DA DEFINIRE)(?! A[TL] SETUP\b)/.exec(l)
      const broken = BROKEN_MARKER.exec(l)
      const at = short ?? broken
      if (at) report('short-slot', p, i + 1, `"${l.slice(at.index, at.index + 24).trim()}…": a slot the setup and upgrade greps cannot see — write [TO BE DEFINED AT SETUP] on one line`)
    })
  }
  settle('short-slot', `${plural(slots, 'marker')} in the full form, none short or broken by a wrap`)
}

// --- Inventories: the documents' lists against the files they enumerate ------------------
// The mechanical twin of /fw:lint-memory's check 11, which projects run by hand.
const childrenOf = (dir) => new Set(FILES.filter((p) => p.startsWith(`${dir}/`))
  .map((p) => p.slice(dir.length + 1).split('/')[0] + (p.slice(dir.length + 1).includes('/') ? '/' : '')))
const globSet = (names, truth) => new Set([...names].flatMap((n) => {
  if (!n.includes('*')) return [n]
  const re = new RegExp(`^${n.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '[^/]*')}$`)
  return [...truth].filter((t) => re.test(t))
}))
// The Makefile's process targets: those whose recipe runs something in scripts/ — a
// structural test, which survives the project's own targets being added below them.
function processTargets() {
  const out = new Set()
  let target = null
  for (const l of lines('Makefile')) {
    const t = /^([A-Za-z0-9_.-]+):/.exec(l)
    if (t) target = t[1]
    else if (/^\t/.test(l) && target && /\bscripts\//.test(l)) out.add(target)
    else if (!/^\t/.test(l)) target = t ? target : null
  }
  return out
}
// The README's Structure tree: name -> its listed children, by depth.
function readmeTree() {
  const block = region('README.md', /^### Structure/, /^## /)
  const tree = new Map([['', new Set()]])
  const stack = ['']
  let line = 0
  for (const { text: l, line: n } of block) {
    const m = /^((?:│   |    )*)(?:├── |└── )(\S+)/.exec(l)
    if (!m) continue
    line ||= n
    const depth = m[1].length / 4
    stack.length = depth + 1
    const parent = stack[depth]
    tree.get(parent)?.add(m[2])
    const path = `${parent}${m[2]}`
    if (m[2].endsWith('/')) { tree.set(path, new Set()); stack[depth + 1] = path }
  }
  return { tree, line }
}
function checkInventories() {
  section('Inventories — commands, targets, self-tests, tables and trees against the files')
  // A command's name is its path under .claude/commands/, each / a : — Claude Code's own rule
  // for a file in a subdirectory: .claude/commands/fw/checkpoint.md runs as /fw:checkpoint.
  const commands = new Set(FILES.map((p) => /^\.claude\/commands\/(.+)\.md$/.exec(p)?.[1]).filter(Boolean).map((c) => `/${c.replace(/\//g, ':')}`))
  // Every command of the method lives under fw/: a bare name can be one of Claude Code's own,
  // which a project command replaces, silently (CONTRIBUTING.md, This repo's workflow).
  for (const p of FILES.filter((f) => /^\.claude\/commands\/.+\.md$/.test(f) && !f.startsWith('.claude/commands/fw/'))) {
    report('inventory', p, 1, `a command outside .claude/commands/fw/: it would run under a name Claude Code may also use`)
  }
  const slash = item('CLAUDE.md', /^- Slash commands:/)
  if (!slash) report('inventory', 'CLAUDE.md', 1, 'no "- Slash commands:" item in Quick commands')
  else compareSets('inventory', 'CLAUDE.md', slash.line, 'the Slash commands of Quick commands', commands,
    new Set(backticked(slash.text).filter((t) => t.startsWith('/'))), '.claude/commands/')
  const { tree, line: treeLine } = readmeTree()
  const cmdLine = region('README.md', /^### Structure/, /^## /).find((l) => /commands\/\s+\//.test(l.text))
  if (!cmdLine) report('inventory', 'README.md', treeLine || 1, 'no commands/ line in the Structure tree')
  else compareSets('inventory', 'README.md', cmdLine.line, 'the Structure tree\'s commands/ line', commands,
    new Set(cmdLine.text.slice(cmdLine.text.indexOf('commands/') + 'commands/'.length).match(/\/[a-z][a-z0-9-]*(?::[a-z][a-z0-9-]*)*/g)), '.claude/commands/')
  // Any command cited by name in the present documents must exist.
  for (const p of PRESENT.filter(isMd)) {
    for (const u of units(p, presentMask(p))) {
      for (const m of u.text.matchAll(/`(\/[a-z][a-z0-9-]*(?::[a-z][a-z0-9-]*)*)`/g)) {
        if (!commands.has(m[1])) report('inventory', p, u.at[m.index], `${m[1]}: no such command in .claude/commands/`)
      }
    }
  }
  // The process targets, wherever they are listed.
  const targets = processTargets()
  if (targets.size < 3) report('inventory', 'Makefile', 1, `only ${targets.size} process targets found: the recipe test is wrong`)
  const quick = region('CLAUDE.md', /^## Quick commands/, /^(## |---)/)
  compareSets('inventory', 'CLAUDE.md', quick[0]?.line ?? 1, 'Quick commands', targets,
    new Set(quick.flatMap((l) => [...l.text.matchAll(/`make ([a-z][a-z0-9-]*)/g)].map((m) => m[1]))), 'the Makefile\'s process targets')
  const mk = region('README.md', /^### Structure/, /^## /).find((l) => /Makefile\s/.test(l.text))
  if (mk) compareSets('inventory', 'README.md', mk.line, 'the Structure tree\'s Makefile line', targets,
    new Set((/\(([^)]*)\)/.exec(mk.text)?.[1] ?? '').split(/,\s*/).filter(Boolean)), 'the Makefile\'s process targets')
  const row = lines(SETUP).findIndex((l) => /^\| `Makefile` \|/.test(l))
  if (row >= 0) compareSets('inventory', SETUP, row + 1, 'the brownfield Makefile row', targets,
    new Set(backticked(lines(SETUP)[row]).filter((t) => /^[a-z][a-z0-9-]+$/.test(t))), 'the Makefile\'s process targets')
  // The self-tests make test-scripts runs, against scripts/test-*.sh.
  const recipe = []
  let inTarget = false
  for (const l of lines('Makefile')) {
    if (/^test-scripts:/.test(l)) inTarget = true
    else if (inTarget && !/^\t/.test(l)) inTarget = false
    else if (inTarget) recipe.push(...[...l.matchAll(/bash (scripts\/test-[\w-]+\.sh)/g)].map((m) => m[1]))
  }
  compareSets('inventory', 'Makefile', lines('Makefile').findIndex((l) => /^test-scripts:/.test(l)) + 1,
    'the test-scripts recipe', new Set(FILES.filter((p) => /^scripts\/test-[^/]+\.sh$/.test(p))), new Set(recipe), 'scripts/test-*.sh')
  // The tables of scripts/README.md and tools/README.md, against their directories.
  for (const dir of ['scripts', 'tools']) {
    const readme = `${dir}/README.md`
    const rows = lines(readme).map((l, i) => ({ m: /^\| `([^`]+)` \|/.exec(l), line: i + 1 })).filter((r) => r.m)
    compareSets('inventory', readme, rows[0]?.line ?? 1, `the table of ${readme}`,
      new Set([...childrenOf(dir)].filter((c) => c !== 'README.md')), new Set(rows.map((r) => r.m[1])), `${dir}/`)
  }
  // The docs CLAUDE.md indexes.
  compareSets('inventory', 'CLAUDE.md', lines('CLAUDE.md').findIndex((l) => l.includes('@.claude/docs/')) + 1,
    'the process documentation of CLAUDE.md', new Set(FILES.filter((p) => /^\.claude\/docs\/[^/]+\.md$/.test(p))),
    new Set((text('CLAUDE.md').match(/@\.claude\/docs\/[^\s)]+\.md/g) ?? []).map((t) => t.slice(1))), '.claude/docs/')
  // The README's tree: every directory it opens lists its tracked children, globs expanded;
  // a directory listed without children is summarised on its own line.
  for (const [dir, listed] of tree) {
    if (!listed.size) continue
    const truth = dir ? childrenOf(dir.replace(/\/$/, '')) : new Set(FILES.map((p) => (p.includes('/') ? `${p.split('/')[0]}/` : p)))
    compareSets('inventory', 'README.md', treeLine || 1, `the Structure tree under ${dir || 'the root'}`, truth, globSet(listed, truth), `the tracked ${dir || 'root'}`)
  }
  settle('inventory', `${commands.size} commands, ${targets.size} process targets, ${recipe.length} self-tests, the script and tool tables, the docs index and the README tree match the files`)
}

// --- Tags and the CHANGELOG --------------------------------------------------------------
// Every release tag has its entry and every entry its tag — but one: the release being
// prepared, whose entry is written before the merge and tagged after it. A tag created
// with its entry still unwritten (it happened once) fails on the next run.
function checkChangelog() {
  section('Tags and the CHANGELOG — every tag has its entry, every entry its tag')
  const ls = lines(CHANGELOG)
  const heads = ls.map((l, i) => ({ l, line: i + 1 })).filter((h) => /^## /.test(h.l))
  const unreleased = heads.filter((h) => h.l === '## [Unreleased]')
  if (unreleased.length !== 1 || heads[0]?.l !== '## [Unreleased]') {
    report('changelog', CHANGELOG, heads[0]?.line ?? 1, 'the first "## " heading must be the one "## [Unreleased]"')
  }
  for (const h of heads) {
    if (h.l !== '## [Unreleased]' && !ENTRY_RE.test(h.l)) report('changelog', CHANGELOG, h.line, `"${h.l}": a release heading reads "## [X.Y.Z] — YYYY-MM-DD"`)
  }
  ENTRIES.forEach((e, i) => {
    const next = ENTRIES[i + 1]
    if (next && cmpVer(e.version, next.version) <= 0) report('changelog', CHANGELOG, e.line, `${e.version} is not above ${next.version}, the entry below it: newest first, no duplicate`)
    if (next && e.date < next.date) report('changelog', CHANGELOG, e.line, `${e.version} is dated ${e.date}, before ${next.version} (${next.date})`)
  })
  if (!TAGS.length) {
    report('changelog', null, 0, 'no vX.Y.Z tag in this clone: fetch the tags (a CI checkout needs its full history)')
    settle('changelog', 'no tag to compare')
    return
  }
  for (const t of TAGS) {
    if (t.type !== 'tag') report('changelog', CHANGELOG, 1, `${t.name} is a lightweight tag: a release tag is annotated (docs/04, Versioning)`)
    const e = ENTRIES.find((x) => x.version === t.version)
    if (!e) report('changelog', CHANGELOG, 1, `${t.name} has no entry "## [${t.version}] — …"`)
    else if (t.date && e.date > t.date) report('changelog', CHANGELOG, e.line, `${t.version} is dated ${e.date}, after its tag (${t.date})`)
  }
  for (const e of ENTRIES) {
    if (TAGS.some((t) => t.version === e.version)) continue
    if (PENDING && e === PENDING && e.date <= LATEST_DATE) check(`${e.version}: the release being prepared — its entry is written, its tag comes after the merge`)
    else report('changelog', CHANGELOG, e.line, `${e.version} has no tag v${e.version}${e === ENTRIES[0] ? ` (a pending entry is one SemVer step above v${LATEST_TAG.version}, dated no later than tomorrow)` : ''}`)
  }
  // The "Upgrading from X" notes, which an upgrade collects in order, name the release just
  // below their own — or its X.Y.x line.
  ENTRIES.forEach((e, i) => {
    const below = ENTRIES[i + 1]
    if (!below) return
    for (let n = e.line; n < (below.line ?? ls.length); n++) {
      const m = /^\*\*Upgrading from (\d+\.\d+)\.(\d+|x)\b/.exec(ls[n - 1])
      if (!m) continue
      const named = `${m[1]}.${m[2]}`
      if (named !== below.version && !(m[2] === 'x' && below.version.startsWith(`${m[1]}.`))) {
        report('changelog', CHANGELOG, n, `the Upgrading note of ${e.version} starts from ${named}, but the entry below is ${below.version}`)
      }
    }
  })
  settle('changelog', `${plural(TAGS.length, 'tag')} and ${plural(ENTRIES.length, 'entry', 'entries')} match, newest first, annotated, dated no later than their tags`)
}

// --- No old version cited as the current one ---------------------------------------------
// A framework version older than the current one, next to a word that makes it current —
// or in a heading, a `version:` line, a checkout. History is exempt by nature; so are the
// self-tests, whose fixtures reuse real version names.
const TOOL_BEFORE = /(?:git|node|Node\.js|bash|npx|Claude Code|commitlint|gitleaks|Keep a Changelog|Node)\s*`?$/i
const HISTORICAL = /(?:\b(?:from|since|until|up to|before|after|in|crossed|crossing|introduced|added|moved|translated|required|measured on|of|to|by|than|at|between|and|or)|→|->|,)\s*`?v?$/i
const MARKER_BEFORE = /(?:as of|(?:is|now|currently) at|we are (?:on|at)|latest(?: release| version)?[:,]?|current(?: version| release)?(?: is)?[:,]?|supported[:,]?(?: the)?)\s*`?v?$/i
const CURRENCY = /\b(?:current|currently|latest|newest|now|today|this release|this version|at present|presently|as of|at the time of writing)\b/i
function checkCurrentVersion() {
  section('Versions — no document cites an old version as the current one')
  if (!CURRENT) { settle('current-version', 'no release yet'); return }
  const releases = new Set([...TAGS.map((t) => t.version), ...ENTRIES.map((e) => e.version)])
  let mentions = 0
  for (const p of PRESENT.filter((f) => !isSelfTest(f))) {
    for (const u of units(p, presentMask(p))) {
      const s = u.text
      const urls = [...s.matchAll(/https?:\/\/\S+/g)].map((m) => [m.index, m.index + m[0].length])
      for (const m of s.matchAll(/(?<![\w./-])v?(\d+)\.(\d+)(?:\.(\d+))?(?![\w-]|\.\d)/g)) {
        const v = m[3] === undefined ? `${m[1]}.${m[2]}` : `${m[1]}.${m[2]}.${m[3]}`
        const named = m[3] === undefined ? [...releases].some((r) => r.startsWith(`${v}.`)) : releases.has(v)
        if (!named || urls.some(([a, b]) => m.index >= a && m.index < b)) continue
        const before = s.slice(Math.max(0, m.index - 30), m.index)
        if (TOOL_BEFORE.test(before)) continue
        // 1.0.0 and 0.x, where a text speaks of the two regimes, are SemVer's milestones.
        if (/^1\.0(?:\.0)?$/.test(v) && /\b(?:pre|post)-1\.0\b|\bregime|\b0\.x\b/i.test(s)) continue
        mentions++
        const old = cmpVer(m[3] === undefined ? `${v}.999` : v, CURRENT) < 0
        if (!old) continue
        const near = s.slice(Math.max(0, m.index - 40), m.index + m[0].length + 40)
        const self = (isMd(p) && /^#{1,6}\s/.test(s)) || /\bversion\s*[:=]\s*`?v?$/.test(before)
          || /(?:--branch|checkout|switch)\s+$/.test(before)
        const claim = MARKER_BEFORE.test(before) || ((CURRENCY.test(near) || self) && !HISTORICAL.test(before))
        if (claim) report('current-version', p, u.at[m.index], `${m[0]} reads as the current version, which is ${CURRENT}`)
      }
      // A static badge states a version by itself: shields.io/badge/<label>-<version>-<colour>.
      for (const m of s.matchAll(/shields\.io\/badge\/[^)\s]*?-v?(\d+\.\d+\.\d+)-/g)) {
        if (releases.has(m[1]) && cmpVer(m[1], CURRENT) < 0) report('current-version', p, u.at[m.index], `a static badge reads ${m[1]}, the current version is ${CURRENT}`)
      }
    }
  }
  settle('current-version', `${plural(mentions, 'mention')} of a framework release outside history, none presented as current but ${CURRENT}`)
}

// --- Internal links resolve --------------------------------------------------------------
// Markdown links and their anchors, wikilinks, Claude Code's @-imports — everywhere, history
// included; the repository paths and the section titles the present documents cite.
const MD_FILES = FILES.filter(isMd)
// The vault of the wikilinks is .claude/: a link names a note by its path or its basename.
const VAULT = MD_FILES.filter((p) => p.startsWith('.claude/')).map((p) => p.slice('.claude/'.length, -3))
function resolveWikilink(target) {
  const t = target.trim().replace(/\.md$/, '')
  const hits = VAULT.filter((v) => v === t || v.endsWith(`/${t}`))
  return hits.length === 1 ? `.claude/${hits[0]}.md` : hits.length ? 'ambiguous' : null
}
// resolvePath(token, from): the tracked file or directory a cited path names, tried from
// the root, the citing file's directory, .claude/, .claude/memory/ and .claude/docs/; a
// bare file name by its unique basename; docs/NN (and docs/NN-MM, docs/NN/NN) as the
// numbered docs. Returns the paths named, or null.
function resolvePath(token, from) {
  const t = token.replace(/:\d+(?:-\d+)?$/, '').replace(/\/$/, '')
  const nums = /^(?:\.claude\/)?docs\/(\d\d)(?:-(\d\d)|((?:\/\d\d)+))?$/.exec(t)
  if (nums) {
    const wanted = nums[2] ? Array.from({ length: Number(nums[2]) - Number(nums[1]) + 1 }, (_, k) => String(Number(nums[1]) + k).padStart(2, '0'))
      : [nums[1], ...(nums[3] ?? '').split('/').filter(Boolean)]
    const docs = wanted.map((n) => FILES.find((p) => p.startsWith(`.claude/docs/${n}-`)))
    return docs.every(Boolean) ? docs : null
  }
  const dir = posix.dirname(from)
  for (const base of ['', `${dir}/`, '.claude/', '.claude/memory/', '.claude/docs/', '.claude/commands/']) {
    const c = posix.normalize(base + t)
    if (FILESET.has(c) || isDir(c)) return [c]
  }
  if (!t.includes('/')) {
    const named = FILES.filter((p) => posix.basename(p) === t)
    if (named.length) return named
  }
  return null
}
const PATHLIKE = /^[.\w@-]*(?:\/[\w.@-]*)*\/?(?::\d+(?:-\d+)?)?$/
// A cited path that is a placeholder, a git ref, a git internal, a command or a system path
// names nothing to resolve; a relative one (../) is resolved from the citing file.
const NOT_A_PATH = /[<>*…$]|YYYY|NNN|\bv[XY]\b|^(?:origin|refs|feat|fix|hotfix|chore|docs|release|worktree-agent)\/|(?:^|\/)\.git\/|^\//
function checkLinks() {
  section('Links — Markdown links, wikilinks, @-imports, cited paths and section titles resolve')
  const n = { md: 0, wiki: 0, at: 0, path: 0, title: 0 }
  for (const p of MD_FILES) {
    for (const u of units(p, allMask(p))) {
      const s = blankOut(u.text, CODE_SPAN)
      for (const m of s.matchAll(/\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g)) {
        if (/^(?:[a-z]+:|#$)/i.test(m[1])) continue
        n.md++
        const [path, anchor] = m[1].split('#')
        let decoded
        try { decoded = decodeURI(path) } catch {
          report('link', p, u.at[m.index], `[…](${m[1]}): a malformed %-escape`)
          continue
        }
        const target = path ? posix.normalize(posix.join(posix.dirname(p), decoded)) : p
        if (!FILESET.has(target) && !isDir(target)) report('link', p, u.at[m.index], `[…](${m[1]}): ${target} does not exist`)
        else if (anchor !== undefined && isMd(target) && !anchors(target).has(anchor.toLowerCase())) report('link', p, u.at[m.index], `[…](${m[1]}): no heading of ${target} has the anchor #${anchor}`)
      }
      for (const m of s.matchAll(/\[\[([^\]|#\n]+)(#[^\]|\n]*)?(?:\|[^\]\n]*)?\]\]/g)) {
        if (/[<>]|YYYY|\.\.\.|^:|^\s/.test(m[1])) continue
        n.wiki++
        const r = resolveWikilink(m[1])
        if (!r) report('link', p, u.at[m.index], `[[${m[1]}]] names no note of the vault (.claude/)`)
        else if (r === 'ambiguous') report('link', p, u.at[m.index], `[[${m[1]}]] names more than one note`)
        else if (m[2] && !headings(r).some((h) => h.title === m[2].slice(1).trim())) report('link', p, u.at[m.index], `[[${m[1]}${m[2]}]]: no such heading in ${r}`)
      }
    }
  }
  for (const p of FILES.filter((f) => f === 'CLAUDE.md' || /^\.claude\/commands\/.+\.md$/.test(f))) {
    lines(p).forEach((l, i) => {
      for (const m of l.matchAll(/(?:^|\s)@(\.claude\/[\w./-]+\.md)/g)) {
        n.at++
        if (!FILESET.has(m[1])) report('link', p, i + 1, `@${m[1]}: the import names no file`)
      }
    })
  }
  // In the present documents: the repository paths they cite between backticks, and the
  // section titles they cite with their file.
  for (const p of PRESENT.filter(isMd)) {
    for (const u of units(p, presentMask(p))) {
      for (const m of u.text.matchAll(/`([^`\n]+)`/g)) {
        const t = m[1]
        if (!PATHLIKE.test(t) || NOT_A_PATH.test(t) || !(/\//.test(t) || /\.(?:md|sh|mjs|cjs|json)$/.test(t))) continue
        // A path an example introduces names nothing: "e.g." (or "for example", "such as")
        // before it, in the same sentence.
        const [a] = sentenceAround(u.text, m.index)
        if (/\be\.g\.|\bfor example\b|\bsuch as\b/i.test(u.text.slice(a, m.index))) continue
        n.path++
        if (!resolvePath(t, p)) report('link', p, u.at[m.index], `\`${t}\` names no file or directory of the repository`)
      }
      n.title += checkTitles(p, u)
    }
  }
  for (const p of PRESENT.filter((f) => !isMd(f) && !OWN.includes(f))) for (const u of codeUnits(p)) n.title += checkTitles(p, u)
  settle('link', `${n.md} Markdown links, ${n.wiki} wikilinks, ${n.at} @-imports, ${n.path} cited paths and ${n.title} section titles resolve`)
}
// checkTitles(p, u): the section titles a unit cites with their file, each looked up in
// that file; returns how many it checked.
function checkTitles(p, u) {
  let n = 0
  for (const r of sectionRefs(u.text)) {
    const files = resolvePath(r.file, p)
    if (!files || files.length !== 1 || !isMd(files[0])) continue
    n++
    if (!titleIn(files[0], r)) report('link', p, u.at[r.index], `${r.file} has no section ${r.kind === 'number' ? `§${r.title}` : `"${r.title}"`}`)
  }
  return n
}
// codeUnits(p): the text of a code file as units — each run of comment lines joined (a
// title cited in a comment may wrap), each other line on its own (a message string).
function codeUnits(p) {
  const out = []
  let cur = null
  lines(p).forEach((l, i) => {
    const c = /^\s*(?:#|\/\/)\s?(.*)$/.exec(l)
    if (c && !/^#!/.test(l)) {
      if (!cur) { cur = { text: '', at: [] }; out.push(cur) }
      const piece = (cur.text ? ' ' : '') + c[1].trim()
      for (let k = 0; k < piece.length; k++) cur.at.push(i + 1)
      cur.text += piece
      return
    }
    cur = null
    out.push({ text: l, at: Array.from({ length: l.length + 1 }, () => i + 1) })
  })
  for (const u of out) u.at.push(u.at[u.at.length - 1] ?? 1)
  return out
}
// sectionRefs(s): the sections a unit cites WITH their file — `file`, *Title*; `file`
// (*Title*); `file`, "Title"; `file` ("Title"); `file` §N — the file backticked or bare
// (a .md path, or docs/NN), the quotes straight or curly. A phrase in quotes right after a
// file name is read as a section title, never as a quotation: quote a sentence elsewhere.
function sectionRefs(s) {
  const out = []
  const file = String.raw`(?:\`([^\`\n]+\.md|docs\/\d\d)\`|(?<![\w./-])((?:[\w.-]+\/)*[\w.-]+\.md|docs\/\d\d)\b)(?:'s)?`
  const title = String.raw`(?:\*"?([^*"\n]+?)"?\*|["“]([^"”\n]+)["”])`
  for (const m of s.matchAll(new RegExp(`${file}\\s*(?:,\\s*|\\(\\s*)${title}`, 'g'))) out.push({ file: m[1] ?? m[2], title: m[3] ?? m[4], kind: m[4] ? 'quote' : 'title', index: m.index })
  for (const m of s.matchAll(new RegExp(`${file},?\\s*§\\s*(\\d+)`, 'g'))) out.push({ file: m[1] ?? m[2], title: m[3], kind: 'number', index: m.index })
  return out
}
const normTitle = (t) => t.replace(/[`*"“”]/g, '').replace(/\s+/g, ' ').trim().toLowerCase()
  .replace(/^(?:\d+\.|step \d+ —)\s*/, '').replace(/[.:;,]+$/, '')
// titleIn(p, ref): whether a cited title is a heading or a bold lead-in of p — exactly, cut
// at its first " — ", ":" or " (", or as a whole-word prefix; a §N, a "## N." heading. A
// title in quotes is held to the same: a phrase the file merely contains would survive the
// rename of the heading it cites.
function titleIn(p, ref) {
  if (ref.kind === 'number') return headings(p).some((h) => new RegExp(`^${ref.title}\\.\\s`).test(h.title))
  const want = normTitle(ref.title)
  const leads = lines(p).flatMap((l) => [...l.matchAll(/^\s*(?:>\s*)*(?:[-*+]\s+|\d+\.\s+)?\*\*([^*]+?)\*\*/g)].map((m) => m[1]))
  return [...headings(p).map((h) => h.title), ...leads].some((h) => {
    const t = normTitle(h)
    const cut = t.split(/ — |:| \(/)[0].trim()
    return t === want || cut === want || t.startsWith(`${want} `) || t.startsWith(`${want}:`) || cut.startsWith(`${want} `)
  })
}

// --- Lists that declare themselves complete ----------------------------------------------
// A list that claims completeness is believed, so its gap is silent: each one is compared,
// both ways, with the set it enumerates. A list with no structure a program can extract
// stops claiming completeness instead.
const SLOT_RE = /TO BE DEFINED AT SETUP|DA DEFINIRE AL SETUP/g
const slotCount = (s) => (s.match(SLOT_RE) ?? []).length
// The header region of a LEARNINGS.md text: where its slots live (as in upgrade-check.sh).
const headerOf = (s) => s.split('\n').slice(0, Math.max(0, s.split('\n').findIndex((l) => /^## /.test(l)))).join('\n')
const slotsOf = (p, s = text(p)) => slotCount(p === LEARNINGS ? headerOf(s) : s)
// shortNames(p): the names a document gives a payload file — its path, then without the
// .claude/, docs/, commands/ and memory/ prefixes (a bare README.md is no name).
function shortNames(p) {
  const out = [p]
  let q = p
  for (const pre of ['.claude/', 'docs/', 'commands/', 'memory/']) if (q.startsWith(pre)) { q = q.slice(pre.length); out.push(q) }
  return out.filter((n) => n !== 'README.md')
}
// The §2 checklist items of a SETUP.md text: each "- [ ]" line with its continuation lines.
function checklistItems(s) {
  const ls = s.split('\n')
  const from = ls.findIndex((l) => /^## 2\./.test(l))
  const out = []
  for (let i = from + 1; from >= 0 && i < ls.length && !/^## 3\./.test(ls[i]); i++) {
    if (/^- \[ \]/.test(ls[i])) out.push({ text: ls[i], line: i + 1 })
    else if (/^\s+\S/.test(ls[i]) && out.length && !/^#/.test(ls[i])) out[out.length - 1].text += ` ${ls[i].trim()}`
  }
  return out
}
// The class table of tools/upgrade-check.sh, read as text — never run: each arm of the
// case statement in classify(), its patterns and its class.
function classArms() {
  const body = /^classify\(\) \{\n([\s\S]*?)\n\}/m.exec(text(UPGRADE_CHECK))?.[1] ?? ''
  const cases = /case "\$1" in\n([\s\S]*?)\n\s*esac/.exec(body)?.[1] ?? ''
  return cases.replace(/\\\n/g, ' ').split(';;').map((a) => a.replace(/\s+/g, ' ').trim()).filter(Boolean)
    .map((a) => /^(.*?)\)\s*echo ([A-Z-]+)$/.exec(a)).filter(Boolean)
    .map((m) => ({ patterns: m[1].split('|').map((s) => s.trim()), cls: m[2] }))
}
const globRe = (g) => new RegExp(`^${g.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*')}$`)
function checkLists() {
  section('Lists — what the documents enumerate against what exists')
  // §2 of SETUP.md, "the complete list" of the slots, against the payload's markers: every
  // file with a slot is named, every payload file named has a slot.
  const items = checklistItems(text(SETUP))
  if (items.length < 15) report('list', SETUP, 1, `only ${items.length} items found in §2: the extraction is wrong`)
  const s2 = items.map((i) => i.text).join('\n')
  const slotted = PAYLOAD.filter((p) => slotsOf(p) > 0)
  for (const p of slotted) {
    if (!shortNames(p).some((n) => s2.includes(n))) {
      report('list', p, lines(p).findIndex((l) => /TO BE DEFINED AT SETUP|DA DEFINIRE AL SETUP/.test(l)) + 1 || 1, `a slot SETUP.md §2 never names: add its item (the "complete list" of the slots)`)
    }
  }
  for (const it of items) {
    for (const t of backticked(it.text)) {
      const named = PAYLOAD.filter((p) => shortNames(p).includes(t))
      for (const p of named) if (!slotsOf(p)) report('list', SETUP, it.line, `§2 names ${p}, which carries no [TO BE DEFINED AT SETUP] marker: mark the slot, or the greps never find it`)
    }
  }
  // The tripwire: a file that gained a slot since the latest release needs a changed §2 item.
  // A file renamed since then is counted against its old path, so a move gains nothing: the
  // rename is read between the tag and the index — staged, as `git mv` leaves it —, which
  // writes nothing, where a diff against the working tree would refresh the index.
  const prevSetup = LATEST_TAG ? blob(LATEST_TAG.name, SETUP) : null
  if (prevSetup) {
    const prevItems = checklistItems(prevSetup)
    const renamedFrom = new Map((gitOr(['--no-optional-locks', 'diff', '--cached', '-M', '--name-status', LATEST_TAG.name, '--', ...PAYLOAD_PATHS]) ?? '')
      .split('\n').map((l) => l.split('\t')).filter((f) => /^R/.test(f[0]) && f[2]).map((f) => [f[2], f[1]]))
    for (const p of slotted) {
      const before = blob(LATEST_TAG.name, renamedFrom.get(p) ?? p) ?? ''
      if (slotsOf(p) <= slotsOf(p, before)) continue
      const names = shortNames(p)
      const pick = (list) => list.filter((i) => names.some((n) => i.text.includes(n))).map((i) => i.text).join('\n')
      if (pick(items) === pick(prevItems)) report('list', p, 1, `${slotsOf(p, before)} → ${slotsOf(p)} slot markers since ${LATEST_TAG.name}, but its §2 item is unchanged: name the new slot there`)
    }
  }
  // The class table against the payload of the working tree and of every release tag, both
  // ways; then the classes of SETUP.md, *The mental model*, against it.
  const arms = classArms()
  const classOf = (p) => arms.find((a) => a.patterns.some((g) => globRe(g).test(p)))?.cls ?? 'NONE'
  if (arms.length < 6) report('list', UPGRADE_CHECK, 1, `only ${arms.length} arms read from classify(): the extraction is wrong`)
  const seen = new Set(FILES.filter(underPayload))
  for (const p of seen) if (classOf(p) === 'NONE') report('list', UPGRADE_CHECK, 1, `${p} has no class in classify()`)
  for (const t of TAGS) {
    for (const p of (gitOr(['ls-tree', '-r', '--name-only', t.name, '--', ...PAYLOAD_PATHS]) ?? '').split('\n').filter(Boolean)) {
      seen.add(p)
      if (classOf(p) === 'NONE') report('list', UPGRADE_CHECK, 1, `${p} (at ${t.name}) has no class in classify()`)
    }
  }
  for (const a of arms) for (const g of a.patterns) {
    if (!g.includes('*') && !seen.has(g)) report('list', UPGRADE_CHECK, 1, `classify() names ${g}, a file no release and no working tree holds`)
  }
  // No slot in a METHOD file: an upgrade overwrites such a file with vY's text, and post sees
  // no answer it would re-open there. A slot belongs to a HYBRID, merged three ways.
  for (const p of PAYLOAD.filter((f) => classOf(f) === 'METHOD' && slotsOf(f) > 0)) {
    report('list', p, lines(p).findIndex((l) => /TO BE DEFINED AT SETUP|DA DEFINIRE AL SETUP/.test(l)) + 1 || 1, 'a marker in a METHOD file: an upgrade overwrites it, so a slot goes in a HYBRID file and prose names the setup marker')
  }
  const BULLETS = { METHOD: ['METHOD'], HYBRID: ['HYBRID'], 'MEMORY TEMPLATES': ['TEMPLATE', 'LEARNINGS'], 'PROJECT-MEMORY': ['PROJECT-MEMORY', 'LEARNINGS'] }
  const model = region(SETUP, /^### The mental model/, /^> \*\*Why hybrids/)
  const current = FILES.filter(underPayload)
  for (const [name, classes] of Object.entries(BULLETS)) {
    const b = item(SETUP, new RegExp(`^- \\*\\*${name}\\*\\*`))
    if (!b || !model.some((l) => l.line === b.line)) { report('list', SETUP, model[0]?.line ?? 1, `no "- **${name}**" bullet in The mental model`); continue }
    const named = new Set()
    for (const t of backticked(b.text)) {
      if (t.endsWith('/')) continue
      const range = /^(.*\/)(\d\d)-(\d\d)$/.exec(t)
      const files = range ? current.filter((p) => p.startsWith(range[1]) && posix.basename(p).slice(0, 2) >= range[2] && posix.basename(p).slice(0, 2) <= range[3])
        : t.includes('*') ? current.filter((p) => globRe(t).test(p))
          : current.filter((p) => p === t || shortNames(p).includes(t) || p.endsWith(`/${t}`))
      if (files.length !== 1 && !range && !t.includes('*')) continue
      for (const p of files) {
        named.add(p)
        if (!classes.includes(classOf(p))) report('list', SETUP, b.line, `the ${name} bullet names ${p}, which classify() puts in ${classOf(p)}`)
      }
    }
    if (name === 'HYBRID') for (const p of current) if (classOf(p) === 'HYBRID' && !named.has(p)) report('list', SETUP, b.line, `the HYBRID bullet lacks ${p}, a HYBRID of classify()`)
  }
  // The copy lists of the payload, against PAYLOAD_PATHS.
  const paths = new Set(PAYLOAD_PATHS)
  const copies = [[SETUP, /^Copy into the root of the new repo/], ['README.md', /^1\. \*\*Copy\*\*/], ['CONTRIBUTING.md', /^- the PAYLOAD that setup copies/]]
  for (const [p, re] of copies) {
    const it = item(p, re)
    if (!it) { report('list', p, 1, 'the copy list of the payload is gone (its first words changed?)'); continue }
    compareSets('list', p, it.line, 'the copy list', paths, new Set(backticked(it.text).map((t) => t.replace(/\/$/, ''))), 'PAYLOAD_PATHS of tools/upgrade-check.sh')
  }
  // Step 1's copy by tag names the payload's paths in its git archive line: the same set.
  const archiveAt = lines(SETUP).findIndex((l) => /git -C "\$\{FW:\?\}" archive vX\.Y\.Z -- /.test(l))
  if (archiveAt < 0) report('list', SETUP, 1, 'step 1\'s copy by tag (its git archive line) is gone')
  else {
    const spec = lines(SETUP)[archiveAt].split(' -- ')[1].split(/\s+\|/)[0]
    compareSets('list', SETUP, archiveAt + 1, 'the archive\'s path list', paths,
      new Set(spec.trim().split(/\s+/).filter((t) => !t.startsWith("'") && t !== '\\')), 'PAYLOAD_PATHS of tools/upgrade-check.sh')
  }
  // Step 2's diff pathspec covers exactly the files reconciled from the framework's diff.
  const at = lines(SETUP).findIndex((l) => /diff vX vY -- \.claude\/docs/.test(l))
  if (at < 0) report('list', SETUP, 1, 'Step 2\'s diff pathspec is gone')
  else {
    let spec = ''
    for (let i = at; i < lines(SETUP).length; i++) { spec += ` ${lines(SETUP)[i].replace(/\\$/, '')}`; if (!/\\$/.test(lines(SETUP)[i])) break }
    const tokens = spec.split(' -- ')[1].trim().split(/\s+/)
    const covered = new Set(current.filter((p) => tokens.some((t) => p === t || p.startsWith(`${t}/`))))
    const wanted = new Set(current.filter((p) => ['METHOD', 'HYBRID', 'TEMPLATE'].includes(classOf(p))))
    compareSets('list', SETUP, at + 1, 'Step 2\'s diff pathspec', wanted, covered, 'the METHOD, HYBRID and TEMPLATE files')
  }
  // What setup does NOT copy is said where the payload is defined.
  const outside = new Set(FILES.map((p) => p.split('/')[0]).filter((t) => !paths.has(t)))
  const step1 = region(SETUP, /^## 1\./, /^## 2\./).map((l) => l.text).join('\n')
  const box = item(SETUP, /^> \*\*Outside the upgrade payload/)
  for (const t of outside) {
    const name = FILESET.has(t) ? t : `${t}/`
    if (!step1.includes(name)) report('list', SETUP, lines(SETUP).findIndex((l) => /^## 1\./.test(l)) + 1, `step 1 never says ${name} stays out of the copy`)
    if (box && !box.text.includes(name)) report('list', SETUP, box.line, `the "Outside the upgrade payload" box lacks ${name}`)
  }
  // Counts written in prose, against what they count.
  const hooks = (/^for hook in (.*); do$/m.exec(text('scripts/hooks-install.sh'))?.[1] ?? '').split(/\s+/).filter(Boolean)
  const counted = (p, re, n, what) => {
    lines(p).forEach((l, i) => {
      for (const m of l.matchAll(re)) {
        const w = m[1].toLowerCase()
        const k = /^\d+$/.test(w) ? Number(w) : NUMBER_WORDS.indexOf(w)
        if (k >= 0 && k !== n) report('list', p, i + 1, `"${m[0]}", but ${what} ${n}`)
      }
    })
  }
  counted(SETUP, /It installs (\w+) hooks/g, hooks.length, 'the hook loop of scripts/hooks-install.sh has')
  const cases = region(SETUP, /^### Edge cases/, /^> \*\*Outside the upgrade payload/).filter((l) => /^\d+\. \*\*/.test(l.text))
  cases.forEach((c, i) => { if (!c.text.startsWith(`${i + 1}. `)) report('list', SETUP, c.line, `edge case ${i + 1} is numbered "${c.text.split(' ')[0]}"`) })
  counted(SETUP, /These (\w+) cases/g, cases.length, 'the numbered edge cases are')
  const guides = FILES.filter((p) => /^\.claude\/memory\/[^/]+\/README\.md$/.test(p)).length
  for (const p of PRESENT.filter(isMd)) counted(p, /\bthe (\w+) guide READMEs\b/g, guides, 'the guide READMEs under .claude/memory/ are')
  counted('README.md', /\+ (\d+) subfolders/g, [...childrenOf('.claude/memory')].filter((c) => c.endsWith('/')).length, 'the subfolders of .claude/memory/ are')
  for (const p of FILES.filter(isSelfTest)) {
    const head = lines(p).slice(0, lines(p).findIndex((l) => !/^#/.test(l)))
    const listed = head.filter((l) => /^#\s+\d+\.\s/.test(l)).length
    const word = /\b(\w+) cases:/i.exec(head.join('\n'))?.[1]?.toLowerCase()
    const markers = lines(p).filter((l) => /^# --- Case \d+/.test(l)).length
    if (!listed && !word) continue
    if (listed && listed !== markers) report('list', p, 1, `the header lists ${listed} cases, the file marks ${markers} ("# --- Case N")`)
    if (word && NUMBER_WORDS.indexOf(word) !== markers) report('list', p, 1, `the header says "${word} cases", the file marks ${markers}`)
  }
  // The upgrade check's subcommands, wherever they are listed.
  const main = /^main\(\) \{\n([\s\S]*?)\n\}/m.exec(text(UPGRADE_CHECK))?.[1] ?? ''
  const subs = new Set([...main.matchAll(/^\s+([a-z]+)\) cmd_/gm)].map((m) => m[1]))
  const header = region(UPGRADE_CHECK, /^# Subcommands:/, /^#\s*$|^[^#]/).map((l) => /^#\s{3}([a-z]+)\s/.exec(l.text)?.[1]).filter(Boolean)
  compareSets('list', UPGRADE_CHECK, 1, 'the header\'s Subcommands', subs, new Set(header), 'the dispatcher of main()')
  compareSets('list', UPGRADE_CHECK, 1, 'the usage line', subs, new Set((/usage: upgrade-check\.sh ([a-z|]+)/.exec(main)?.[1] ?? '').split('|')), 'the dispatcher of main()')
  const toolRow = lines('tools/README.md').findIndex((l) => /^\| `upgrade-check\.sh` \|/.test(l))
  compareSets('list', 'tools/README.md', toolRow + 1, 'its row', subs, new Set(backticked(lines('tools/README.md')[toolRow] ?? '').filter((t) => subs.has(t) || /^[a-z]+$/.test(t))), 'the dispatcher of tools/upgrade-check.sh')
  const its = item(SETUP, /Its subcommands:/)
  if (its) compareSets('list', SETUP, its.line, '"Its subcommands:"', subs, new Set(backticked(its.text.slice(its.text.indexOf('Its subcommands:'))).filter((t) => /^[a-z]+$/.test(t))), 'the dispatcher of tools/upgrade-check.sh')
  // The sections of the backlog, wherever they are enumerated.
  const sectionsOf = headings(LEARNINGS).filter((h) => h.level === 2).map((h) => h.title.split(' ')[0].toLowerCase())
  for (const p of PAYLOAD.filter(isMd)) {
    for (const u of units(p, payloadMask(p))) {
      const m = /\bopen\s*\/\s*applied\b/i.exec(u.text)
      if (!m) continue
      const missing = sectionsOf.filter((s) => !new RegExp(`\\b${s}\\b`, 'i').test(u.text))
      if (missing.length) report('list', p, u.at[m.index], `enumerates the backlog's sections without ${missing.join(', ')}`)
    }
  }
  // The commit types: commitlint's, docs/04's, its bump table's, /fw:integrate's.
  const types = new Set((/"type-enum":\s*\[\s*\d+,\s*"always",\s*\[([^\]]*)\]/.exec(text('commitlint.config.cjs'))?.[1] ?? '').match(/[a-z]+/g))
  const docs04 = '.claude/docs/04-git-workflow.md'
  const typesLine = lines(docs04).findIndex((l) => /^Types: /.test(l))
  compareSets('list', docs04, typesLine + 1, 'the Types line', types, new Set(backticked(lines(docs04)[typesLine] ?? '')), 'commitlint.config.cjs')
  const bump = lines(docs04).filter((l) => /^\| `/.test(l)).flatMap((l) => backticked(l.split('|')[1]).flatMap((t) => t.split('/'))).filter((t) => /^[a-z]+$/.test(t))
  compareSets('list', docs04, lines(docs04).findIndex((l) => /^\| Commit /.test(l)) + 1, 'the bump table', types, new Set(bump), 'commitlint.config.cjs')
  const integrate = '.claude/commands/fw/integrate.md'
  const step2 = region(integrate, /^## 2\./, /^## 3\./).flatMap((l) => backticked(l.text)).flatMap((t) => t.split('/')).filter((t) => /^[a-z]+$/.test(t))
  compareSets('list', integrate, lines(integrate).findIndex((l) => /^## 2\./.test(l)) + 1, 'the bump rules', types, new Set(step2), 'commitlint.config.cjs')
  // The memory's titles and field labels: the tables of SETUP.md and upgrade-check.sh, the
  // templates' own headings and format comment.
  const titles = new Set([...headings('.claude/memory/STATE.md'), ...headings(LEARNINGS)].filter((h) => h.level === 2).map((h) => `## ${h.title}`))
  const setupTitles = lines(SETUP).filter((l) => /^\s*\| `(STATE|LEARNINGS)\.md` \|/.test(l)).map((l) => backticked(l.split('|')[3] ?? '')[0])
  compareSets('list', SETUP, lines(SETUP).findIndex((l) => /\| Title since 1\.1\.0 \|/.test(l)) + 1, 'the title table', titles, new Set(setupTitles), 'the "## " titles of STATE.md and LEARNINGS.md')
  const table = (name) => (new RegExp(`^${name}='([\\s\\S]*?)'$`, 'm').exec(text(UPGRADE_CHECK).replace(/'"'"'/g, "'"))?.[1] ?? '').split('\n').map((r) => r.split('\t')[1]).filter(Boolean)
  compareSets('list', UPGRADE_CHECK, 1, 'TITLE_TABLE', titles, new Set(table('TITLE_TABLE')), 'the "## " titles of STATE.md and LEARNINGS.md')
  const labelsIn = (s) => new Set([...s.matchAll(/(?:^|\s)[-|] ([A-Z][a-z]+(?: [a-z]+)*(?: \/ [a-z]+)?):/g)].map((m) => m[1]))
  const format = lines(LEARNINGS).filter((_, i) => learningsTemplate()[i] && i > lines(LEARNINGS).findIndex((l) => /^## /.test(l))).join('\n')
  const labels = labelsIn(format)
  const labelRows = lines(SETUP).slice(lines(SETUP).findIndex((l) => /\| Field label until 1\.0\.0 \|/.test(l))).filter((l) => /^\s*\| `- /.test(l))
  compareSets('list', SETUP, lines(SETUP).findIndex((l) => /\| Field label until 1\.0\.0 \|/.test(l)) + 1, 'the label table', labels, labelsIn(labelRows.map((l) => l.replace(/\\\|/g, '\u0000').split('|')[2].replace(/\u0000/g, '|').replace(/`/g, '')).join('\n')), 'the labels of LEARNINGS.md\'s format comment')
  compareSets('list', UPGRADE_CHECK, 1, 'LABEL_TABLE', labels, labelsIn(table('LABEL_TABLE').join('\n')), 'the labels of LEARNINGS.md\'s format comment')
  // The minimums the documents write — "<tool> <version> or later" — and commitlint's pin,
  // against the one place that defines them. A minimum written by hand fell behind once
  // (v1.3.3: Node.js 14.13 named for commitlint, whose line needed 22.12). This check's
  // self-test is skipped: its planted defects are data.
  const PREREQ = 'scripts/check-prerequisites.sh'
  const prereqs = new Map((/^PREREQUISITES='([\s\S]*?)'$/m.exec(text(PREREQ))?.[1] ?? '')
    .split('\n').map((l) => l.split('|')).filter((f) => f.length === 4).map(([tool, min]) => [tool, min]))
  const pinned = /^COMMITLINT=(\d+\.\d+\.\d+)$/m.exec(text(PREREQ))?.[1]
  if (prereqs.size < 5 || !pinned) report('list', PREREQ, 1, `${plural(prereqs.size, 'tool')} and ${pinned ? 'a' : 'no'} commitlint pin read from PREREQUISITES and COMMITLINT: the extraction is wrong`)
  const TOOL_OF = { git: 'git', bash: 'bash', 'node.js': 'node', gitleaks: 'gitleaks' }
  const sameVersion = (a, b) => {
    const x = a.split('.'), y = b.split('.')
    return Array.from({ length: Math.max(x.length, y.length) }, (_, i) => (+x[i] || 0) === (+y[i] || 0)).every(Boolean)
  }
  let written = 0
  for (const p of PRESENT.filter((f) => f !== 'tools/test-docs-check.sh')) {
    const mask = presentMask(p)
    lines(p).forEach((l, i) => {
      if (!mask[i]) return
      for (const m of l.matchAll(/\b(git|bash|Node\.js|gitleaks) v?(\d+(?:\.\d+)*) or later\b/gi)) {
        written++
        const min = prereqs.get(TOOL_OF[m[1].toLowerCase()])
        const defined = min && min !== '-' ? min : null
        if (!defined || !sameVersion(m[2], defined)) report('list', p, i + 1, `"${m[0]}", but the minimum ${PREREQ} defines is ${defined ?? 'none'}`)
      }
      for (const m of l.matchAll(/\bcommitlint v?(\d+\.\d+\.\d+)\b/gi)) {
        written++
        if (m[1] !== pinned) report('list', p, i + 1, `"${m[0]}", but ${PREREQ} pins ${pinned}`)
      }
    })
  }
  if (written < 5) report('list', PREREQ, 1, `only ${plural(written, 'written minimum')} found in the documents: the extraction is wrong`)
  // The images the CI runs, against the copy the prerequisite check carries as CI_IMAGES: setup
  // ships the check without the workflow, and the check names a machine verified by its copy.
  const WORKFLOW = '.github/workflows/test.yml'
  const matrix = new Set((/^\s+os: \[([^\]\n]*)\]\s*$/m.exec(text(WORKFLOW))?.[1] ?? '').split(',').map((s) => s.trim()).filter(Boolean))
  const imagesAt = lines(PREREQ).findIndex((l) => /^CI_IMAGES=/.test(l)) + 1 || 1
  const images = new Set((/^CI_IMAGES='([^'\n]*)'$/m.exec(text(PREREQ))?.[1] ?? '').split(/\s+/).filter(Boolean))
  if (!matrix.size) report('list', WORKFLOW, 1, 'no images read from the matrix\'s os: line: the extraction is wrong')
  if (!images.size) report('list', PREREQ, imagesAt, 'no images read from CI_IMAGES: the extraction is wrong')
  compareSets('list', PREREQ, imagesAt, 'CI_IMAGES', matrix, images, `the matrix of ${WORKFLOW}`)
  settle('list', `§2 and the slots, the class table at ${plural(TAGS.length, 'tag')}, the copy lists, the counts, the subcommands, the sections, the commit types, the memory's titles and labels, ${plural(images.size, 'CI image')} against the workflow's matrix, and ${plural(written, 'written minimum')} against ${PREREQ}`)
}

// --- No Italian residue in the artifacts -------------------------------------------------
// Rule 9 of CLAUDE.md: what lands in the repository is English, from the release that
// brought the rule on. What a program or a procedure reads on purpose in its legacy Italian
// form stays (LEGACY); the memory written before the rule is not rewritten — what this
// check sees there is declared in ALLOW, never translated. A word list cannot see a calque.
const IT_WORDS = new Set(`definire origine innesto innestare rimandate rifiutate applicate proposta proposte destinazione stato
  problema problemi osservato allineamento ripresa riprendi riprendono avanzamento pubblica integrazione
  attivi aperte aperti progetto consolidamento debito documentazione esiste beneficio atteso attesa rischio
  decisione decisioni utente motivo riproporle registrazione mirata ponte promozione cosa adesso prese
  attenzione raccolta respinte giusto ibrido sessione ovvie codice blocco blocchi nota metodo procedura
  periodica inventari igiene formato titolo questo questa quello sono bloccati sempre lavoro mergiato
  eliminato italiano dichiarato umano umana ciclo oneroso atomico resiliente cruscotto diario storia condivisa
  esecuzione marcatore curatela ereditata filtro attrito correzione fattuale livello componenti sensibili
  classi miglioramento senza aggiornata finito comandi rapidi risposta altrimenti firma valida iniziale
  pagamenti generato percorso della delle degli dello nella nelle alla alle anche quando ogni essere deve
  viene tutto dopo ancora perche gli una uno dalla sul sulla nel il che del dei lingua memoria regola regole
  stabile`.split(/\s+/).filter(Boolean))
// Italian accents fall on a word's last letter (è, già, più, perché); a French or Spanish
// name or word (José, café, résumé) is not Italian.
const ACCENTED = /(?:[àèìòù]|ché)$/i
// The legacy forms a program or a procedure reads on purpose: the old marker and hook
// marker, the old titles, labels and block delimiters. Each must still occur where it is
// declared, or it fails as stale.
const LEGACY = [
  { text: 'DA DEFINIRE AL SETUP', where: /./ },
  { text: 'DA DEFINIRE AL', where: /./ },
  { text: 'DA DEFINIRE', where: /./ },
  { text: 'DEFINIRE⏎AL', where: /^\.claude\/memory\/(LEARNINGS\.md|sessions\/)/ },
  { text: 'DA⏎DEFINIRE', where: /^\.claude\/memory\/(LEARNINGS\.md|sessions\/)/ },
  { text: 'Hook generato da scripts/hooks-install.sh', where: /^scripts\/hooks-install\.sh$|^CHANGELOG\.md$|^\.claude\/memory\/(LEARNINGS\.md|sessions\/)/ },
  { text: 'Destinazione: framework', where: /./ },
  { text: 'Destinazione', where: /^(SETUP\.md|CHANGELOG\.md|tools\/|\.claude\/memory\/(LEARNINGS\.md|sessions\/))/ },
  ...['Stato avanzamento', 'Cosa esiste adesso', 'Decisioni prese (non ovvie dal codice)', 'Debito documentazione',
    'Attenzione / problemi aperti', 'Branch attivi', 'Proposte APERTE (in attesa di decisione utente)', 'Proposte APERTE',
    'Rimandate (non respinte — si riprendono al momento giusto)', 'Rifiutate (con motivo — per non riproporle)',
    'Applicate', 'Rimandate', 'Rifiutate', 'Problema osservato', 'Beneficio atteso \\/ rischio', 'Beneficio atteso / rischio',
    'Trigger di ripresa', 'Origine', 'Proposta', 'Formato di una proposta', '<titolo>', '<sessione>', 'Lingua/e del progetto',
    'PRONTO PER INTEGRAZIONE', 'RACCOLTA PER IL FRAMEWORK', 'FINE REPORT', 'FINE RESPONSE', 'FINE RISPOSTA', 'FINE RACCOLTA',
    '<branch-integrazione>']
    .map((t) => ({ text: t, where: /^(SETUP\.md|CHANGELOG\.md|tools\/|\.claude\/memory\/(LEARNINGS\.md|sessions\/))/ })),
  // The STATE.md of a project not yet brought to the method's titles, as the hook reads it.
  ...['Attenzione / problemi aperti', 'Branch attivi'].map((t) => ({ text: t, where: /^scripts\/test-state-inject\.sh$/ })),
]
// The identifiers of history inside code spans — a branch, a commit subject — are names,
// not prose; so are the frontmatter's branch: and tags: values.
const HISTORY_ID = /`(?:feat|fix|docs|chore|refactor|perf|test|build|ci|hotfix|release)(?:\/[\w.+-]+|\([^)`]*\)!?: [^`]*)`/g
// italianIn(s): the Italian words of a text.
const italianIn = (s) => [...s.matchAll(/\p{L}+/gu)].map((m) => m[0]).filter((w) => IT_WORDS.has(w.toLowerCase()) || ACCENTED.test(w))
function checkItalian() {
  section('Language — no Italian residue in the artifacts (rule 9)')
  const legacyUsed = new Set()
  let scanned = 0
  const lineUnit = (l, i) => ({ text: l, at: Array.from({ length: l.length + 1 }, () => i + 1) })
  for (const p of FILES.filter((f) => f !== 'LICENSE' && !OWN.includes(f))) {
    const strict = payloadMask(p)
    const legacy = LEGACY.filter((l) => l.where.test(p))
    const ls = lines(p)
    let blocks = ls.map(lineUnit)
    if (isMd(p)) {
      // The frontmatter line by line, the prose by paragraph (a quote can wrap), the fenced
      // code line by line.
      const fm = ls[0] === '---' ? ls.indexOf('---', 1) : -1
      const fenced = fencedMask(ls)
      blocks = [...ls.slice(0, fm + 1).map(lineUnit), ...units(p, ls.map((_, i) => i > fm)),
        ...ls.map(lineUnit).filter((_, i) => i > fm && fenced[i])]
    }
    for (const u of blocks) {
      let s = u.text
      for (const l of legacy) if (s.includes(l.text)) { legacyUsed.add(l); s = s.split(l.text).join(' '.repeat(l.text.length)) }
      if (isMd(p)) {
        s = s.replace(/\[\[[^\]\n]*\]\]/g, (m) => ' '.repeat(m.length)).replace(HISTORY_ID, (m) => ' '.repeat(m.length))
        // The frontmatter's branch: and tags: hold names (branches, tags), not prose.
        s = s.replace(/^(?:branch|tags):(.*)$/, (m, v) => m.replace(v, v.replace(/[\w./+-]*\/[\w./+-]*|\[[^\]]*\]|^\s*[\w./+-]+/g, (x) => ' '.repeat(x.length))))
        // Outside the payload, verbatim quotes are the speaker's words; in history, a code
        // span quotes literal text too.
        if (!strict[u.at[0] - 1]) {
          if (isHistory(p) || p === LEARNINGS) s = blankOut(s, CODE_SPAN)
          s = blankOut(s.replace(CODE_SPAN, (m) => m.replace(/["“”«»]/g, ' ')), /"[^"]*"|“[^”]*”/g)
        }
      }
      scanned++
      const found = italianIn(s)
      if (found.length) report('italian', p, u.at[s.search(new RegExp(`(?<!\\p{L})${found[0]}(?!\\p{L})`, 'u'))] ?? u.at[0], `Italian in an artifact: ${[...new Set(found)].slice(0, 5).join(', ')}`)
    }
    if (!isHistory(p) && !(p === LEARNINGS)) ls.forEach((l, i) => { if (/[«»]/.test(l)) report('italian', p, i + 1, 'guillemets « » as quotation marks: English uses " "') })
    const named = [...new Set(italianIn(p.replace(/\.[a-z]+$/, '').replace(/[-_/.]/g, ' ')))]
    if (named.length) report('italian', p, 0, `an Italian file name (${named.join(', ')})`, p)
  }
  for (const l of LEGACY) if (!legacyUsed.has(l)) report('italian', null, 0, `the legacy string "${l.text}" occurs nowhere it is declared: remove it from LEGACY`)
  // The commit messages since the release that brought the rule: history, where a quote
  // and a code span cite literal text.
  const log = gitOr(['log', '--format=%h%x1f%B%x1e', 'v1.1.0..HEAD'])
  if (log === null) check('no tag v1.1.0 in this clone: the commit messages are not checked')
  else {
    for (const c of log.split('\x1e').map((x) => x.trim()).filter(Boolean)) {
      const [sha, body] = c.split('\x1f')
      // A trailer names a person, it is not prose.
      const prose = body.replace(/^(?:Co-authored-by|Signed-off-by|Reviewed-by|Acked-by|Reported-by|Refs?):.*$/gim, '')
      const found = italianIn(blankOut(blankOut(prose, CODE_SPAN), /"[^"]*"|“[^”]*”/g))
      if (found.length) report('italian', null, 0, `commit ${sha}: Italian in its message (${[...new Set(found)].slice(0, 5).join(', ')})`, sha)
    }
  }
  settle('italian', `${scanned} text units, the file names and the commits since v1.1.0 are English but for the declared legacy forms`)
}

// --- The declared exceptions -------------------------------------------------------------
// What the rules above cannot tell apart, each with its reason. Bidirectional: an entry that
// covers nothing fails below, so it is removed with its cause.
const NOTES = '.claude/memory/sessions/'
const ALLOW = [
  // The payload.
  { check: 'imp-number', file: LEARNINGS, line: '### IMP-001 — <short title>', reason: 'the format example of the template: a project numbers its own IMPs from 001' },
  // Inventories.
  { check: 'inventory', file: '*', text: '/clear: no such command', reason: 'a command of Claude Code itself, not one of the method' },
  { check: 'inventory', file: '*', text: '/cd: no such command', reason: 'a command of Claude Code itself, not one of the method' },
  { check: 'inventory', file: SETUP, text: '/tmp: no such command', reason: 'a directory, not a command' },
  // Links: names that are not meant to exist in this repository.
  { check: 'link', file: '*', text: '`.claude/framework-version`', reason: 'the provenance pin: created in a project at its graft, never here' },
  { check: 'link', file: '*', text: '`settings.local.json`', reason: 'personal permissions: local and unversioned by design (.gitignore)' },
  { check: 'link', file: '.claude/docs/04-git-workflow.md', text: '`.claude/worktrees/`', reason: 'where Claude Code puts an isolated agent\'s worktree, ignored by .gitignore' },
  { check: 'link', file: '.claude/docs/04-git-workflow.md', text: '`secrets/`', reason: 'a generic example of where secrets live' },
  { check: 'link', file: SETUP, text: '`adr/`', reason: 'an example of where a project keeps its ADRs' },
  // Lists.
  { check: 'list', file: SETUP, text: '§2 names .claude/memory/LEARNINGS.md', reason: 'a check at setup (the memory arrived empty), not a slot' },
  { check: 'list', file: SETUP, text: '§2 names .claude/memory/STATE.md', reason: 'a template the first command populates, not a slot' },
  { check: 'list', file: SETUP, text: '§2 names .claude/memory/INDEX.md', reason: 'a template the first command populates, not a slot' },
  { check: 'list', file: SETUP, text: '§2 names scripts/agent-git-guard.mjs', reason: 'named as boundary wiring to leave in place, not a slot' },
  { check: 'list', file: SETUP, text: '§2 names scripts/state-inject.sh', reason: 'named as the memory\'s wiring to leave in place, not a slot' },
  { check: 'list', file: UPGRADE_CHECK, text: 'classify() names .claude/framework-version', reason: 'GRAFT-STATE: the pin exists only in a project' },
  { check: 'list', file: UPGRADE_CHECK, text: 'classify() names .claude/settings.local.json', reason: 'LOCAL: never versioned' },
  { check: 'list', file: 'README.md', text: 'the copy list names .claude/framework-version', reason: 'the pin step 1 creates, not a copied path' },
  { check: 'list', file: 'README.md', text: 'the copy list names SETUP.md', reason: 'a pointer to the full guide, not a copied path' },
  { check: 'list', file: 'CONTRIBUTING.md', text: 'the copy list names SETUP.md', reason: 'a pointer to step 1, not a copied path' },
  { check: 'list', file: 'CONTRIBUTING.md', text: 'the copy list names SECURITY.md', reason: 'the scaffold setup offers next to the payload' },
  // The memory written before the language rule, or before this check: never rewritten.
  ...['2026-07-11-consolidamento-assessment', '2026-07-14-registrazione-imp-innesto-brownfield', '2026-07-17-harvest-framework-ponte',
    '2026-07-17-retro-periodica-backlog-lint', '2026-07-17-upgrade-in-place-procedura', '2026-07-18-allineamento-doc-pubblica',
    '2026-07-18-retro-mirata-imp-036-037', '2026-07-19-promozione-v1.0.0', '2026-07-19-retro-mirata-imp-038']
    .map((n) => ({ check: 'italian', file: `${NOTES}${n}.md`, text: 'an Italian file name', reason: 'a note named before the language rule: notes are never renamed' })),
  { check: 'italian', file: `${NOTES}2026-07-21-retro-mirata-imp-043.md`, text: 'an Italian file name', reason: 'named after the rule, before this check: notes are never renamed' },
  { check: 'italian', file: `${NOTES}2026-07-20-language-rule-phase1.md`, section: 'Glossary (APPROVED', reason: 'the approved glossary of the translation: its Italian column is the point' },
  { check: 'italian', file: `${NOTES}2026-07-20-language-rule-phase1.md`, line: 'Confirmed key terms: innesto', reason: 'the glossary\'s key terms, quoted' },
  { check: 'italian', file: `${NOTES}2026-07-17-audit-preintegrate-closeout-v0.3.0.md`, line: '(nota); lavoro su', reason: 'a frontmatter value the translation of the memory missed; the memory is not rewritten' },
]

// --- The method's rules ------------------------------------------------------------------
// A rule of the method (.claude/rules/fw-*.md) imports nothing: an @-import inside a rule with
// `paths` was measured loading its file at every launch, before the rule itself (the v4.0.0
// session note, task 2) — the cost the rules exist to avoid; the rule tells Claude to Read
// the file instead. Claude Code imports `@path` outside code spans and fenced code. And each
// concrete glob of a rule's `paths` matches a tracked file: one that matches nothing is a rule
// that never loads. A slot's marker is no glob: setup answers it.
const METHOD_RULE = /^\.claude\/rules\/fw-[^/]+\.md$/
// ruleGlobs(p): the `paths` of a rule's frontmatter, each with its line — a YAML list, or the
// comma-separated string Claude Code also accepts.
function ruleGlobs(p) {
  const ls = lines(p)
  if (ls[0] !== '---') return []
  const end = ls.indexOf('---', 1)
  const out = []
  const unquote = (s) => s.trim().replace(/^(["'])(.*)\1$/, '$2')
  let inList = false
  for (let i = 1; i < end; i++) {
    const l = ls[i]
    const key = /^paths:\s*(.*)$/.exec(l)
    if (key) {
      inList = !key[1].trim()
      if (!inList) for (const g of key[1].split(',')) out.push({ glob: unquote(g), line: i + 1 })
      continue
    }
    if (!inList || /^\s*(#.*)?$/.test(l)) continue
    const item = /^\s+-\s+(.*)$/.exec(l)
    if (item) out.push({ glob: unquote(item[1]), line: i + 1 })
    else inList = false
  }
  return out
}
// globToRe(g): a rule's glob as a regular expression over the repository's paths — `**/` any
// depth or none, `*` and `?` within a segment, `{a,b}` either.
const globToRe = (g) => new RegExp(`^${g.replace(/[.+^$()|\\]/g, '\\$&')
  .replace(/\{([^}]*)\}/g, (m, a) => `(?:${a.split(',').join('|')})`)
  .replace(/\*\*\//g, '\u0000').replace(/\*\*/g, '.*').replace(/\*/g, '[^/]*').replace(/\?/g, '[^/]')
  .replace(/\u0000/g, '(?:.*/)?')}$`)
function checkRules() {
  section('Rules — the method\'s rules import nothing, and each of their globs matches a file')
  const rules = FILES.filter((f) => METHOD_RULE.test(f))
  if (!rules.length) report('rule', null, 0, 'no method rule under .claude/rules/: the extraction is wrong')
  let globs = 0
  for (const p of rules) {
    for (const u of units(p, allMask(p))) {
      for (const m of blankOut(u.text, CODE_SPAN).matchAll(/(?:^|\s)@([\w.~/-]+)/g)) {
        report('rule', p, u.at[m.index], `@${m[1]}: an import in a method rule loads its file at every launch, before the rule — have Claude Read it instead`)
      }
    }
    for (const g of ruleGlobs(p)) {
      if (MARKER_RE.test(g.glob)) continue
      globs++
      const re = globToRe(g.glob)
      if (!FILES.some((f) => re.test(f))) report('rule', p, g.line, `the glob "${g.glob}" matches no tracked file: the rule would never load`)
    }
  }
  settle('rule', `${plural(rules.length, 'method rule')}, no @-import, ${plural(globs, 'glob')} each matching a tracked file`)
}

// --- The allow-list itself ---------------------------------------------------------------
function checkAllowList() {
  section('The allow-list — every declared exception still matches something')
  for (const a of ALLOW) {
    const what = a.text ?? a.line ?? a.section
    if (!a.reason) fail(`ALLOW ${a.check} ${a.file} "${what}": an exception without its reason`)
    if (!a.used) fail(`ALLOW ${a.check} ${a.file} "${what}" matches nothing: its cause is gone, remove it`)
  }
  if (ALLOW.every((a) => a.used && a.reason)) ok(`${plural(ALLOW.length, 'declared exception')}, each with its reason, each still needed`)
}

checkImpNumbers()
checkPointers()
checkShortSlots()
checkInventories()
checkRules()
checkChangelog()
checkCurrentVersion()
checkLinks()
checkLists()
checkItalian()
checkAllowList()
console.log(`\ndocs-check: ${nFail} FAIL, ${nCheck} CHECK`)
process.exit(nFail ? 1 : 0)
