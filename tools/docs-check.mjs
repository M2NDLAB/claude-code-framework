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
// Needs git and Node.js 18 or later; no dependency.

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

// The working tree as it is: tracked and new files, never ignored or deleted ones — so a
// file is checked before its first commit.
const FILES = [...new Set(git(['ls-files', '-z', '--cached', '--others', '--exclude-standard']).split('\0'))]
  .filter((p) => p && existsSync(join(ROOT, p)) && statSync(join(ROOT, p)).isFile())
  .sort()
const FILESET = new Set(FILES)
const isDir = (d) => FILES.some((p) => p.startsWith(`${d.replace(/\/$/, '')}/`))
const cache = new Map()
// text(p): a file's text; '' for a binary one.
function text(p) {
  if (!cache.has(p)) {
    const buf = readFileSync(join(ROOT, p))
    cache.set(p, buf.includes(0) ? '' : buf.toString('utf8'))
  }
  return cache.get(p)
}
const lines = (p) => text(p).split('\n')
const isMd = (p) => p.endsWith('.md')
const isSelfTest = (p) => /^(scripts|tools)\/test-[^/]+\.sh$/.test(p)

// --- The payload -------------------------------------------------------------------------
// What setup copies into a project. Its paths are read from tools/upgrade-check.sh, where a
// program already reads them; SECURITY.md is the scaffold setup offers next to them. Of the
// framework's own memory, setup keeps the templates only: it deletes the session notes, and
// of LEARNINGS.md only the header and the format comment remain.
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
const TODAY = (() => {
  const d = new Date()
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
// whose line or message holds its `text` — or, with `section`, every finding under the
// heading that holds it. Each entry carries its reason, and must cover at least one finding.
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
  && (a.section ? Boolean(f.file && f.line) && headingOver(f.file, f.line).includes(a.section) : f.text.includes(a.text) || f.message.includes(a.text))
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
// the project keeps one") is harmless.
const OUTSIDE = [
  { re: /(?<![\w./-])SETUP\.md\b|(?<![\w./-])SETUP\s*§|(?<![\w./-])§\s?\d/g, what: 'SETUP.md' },
  { re: /\b[Ss]tep \d+ of the upgrade\b|\bupgrade(?:'s)? [Ss]tep \d+\b|\bsetup step \d+\b|\*Hardening\*/g, what: 'a section of SETUP.md' },
  { re: /(?<![\w./-])CONTRIBUTING(?:\.md)?\b/g, what: 'CONTRIBUTING.md' },
  { re: /(?<![\w./-])CHANGELOG(?:\.md)?\b/g, what: 'CHANGELOG.md' },
  { re: /(?<![\w./-])LICENSE\b/g, what: 'LICENSE' },
  { re: /(?<![\w./-]|this |This |its )README(?:\.md)?\b(?! of\b)/g, what: 'the root README.md' },
  { re: /`tools\/|(?<![\w./-])tools\/[\w.-]+\.(?:sh|mjs|md)\b/g, what: 'tools/' },
  { re: /\[\[(?:sessions\/)?\d{4}-\d{2}-\d{2}-[^\]|#]+/g, what: 'a session note of the framework' },
]
const LABEL = /\bthe framework(?:'s|’s)\b|\bframework(?:'s|’s)? repo(?:sitory)?\b|\bof the framework\b/gi
const CONDITION = /\b(?:where present|if present|when present|where (?:a copy|one) is kept|if (?:the|a) project keeps|if (?:a |the )?`?[\w./-]+`? exists)\b|\bif \[ -[efd] /i
function checkPointers() {
  section('Payload — no pointer to a file outside it, unless labelled or conditional')
  let pointers = 0
  for (const p of PAYLOAD) {
    for (const u of units(p, payloadMask(p))) {
      for (const { re, what } of OUTSIDE) {
        for (const m of u.text.matchAll(re)) {
          pointers++
          const [a, b] = sentenceAround(u.text, m.index)
          const sentence = u.text.slice(a, b)
          const labelled = [...u.text.slice(a, m.index + m[0].length + 40).matchAll(LABEL)]
            .some((l) => Math.abs(a + l.index - m.index) <= 80)
          if (labelled || CONDITION.test(sentence)) continue
          report('pointer', p, u.at[m.index], `"${m[0].trim()}" points at ${what}, which a project does not have: rephrase it, or say it is the framework's`)
        }
      }
    }
  }
  settle('pointer', `${plural(pointers, 'pointer')} out of the payload, each labelled as the framework's or conditional`)
}


// --- Inventories: the documents' lists against the files they enumerate ------------------
// The mechanical twin of /lint-memory's check 11, which projects run by hand.
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
  const commands = new Set(FILES.map((p) => /^\.claude\/commands\/([^/]+)\.md$/.exec(p)?.[1]).filter(Boolean).map((c) => `/${c}`))
  const slash = item('CLAUDE.md', /^- Slash commands:/)
  if (!slash) report('inventory', 'CLAUDE.md', 1, 'no "- Slash commands:" item in Quick commands')
  else compareSets('inventory', 'CLAUDE.md', slash.line, 'the Slash commands of Quick commands', commands,
    new Set(backticked(slash.text).filter((t) => t.startsWith('/'))), '.claude/commands/')
  const { tree, line: treeLine } = readmeTree()
  const cmdLine = region('README.md', /^### Structure/, /^## /).find((l) => /commands\/\s+\//.test(l.text))
  if (!cmdLine) report('inventory', 'README.md', treeLine || 1, 'no commands/ line in the Structure tree')
  else compareSets('inventory', 'README.md', cmdLine.line, 'the Structure tree\'s commands/ line', commands,
    new Set(cmdLine.text.slice(cmdLine.text.indexOf('commands/')).match(/\/[a-z][a-z0-9-]*/g)), '.claude/commands/')
  // Any command cited by name in the present documents must exist.
  for (const p of PRESENT.filter(isMd)) {
    for (const u of units(p, presentMask(p))) {
      for (const m of u.text.matchAll(/`(\/[a-z][a-z0-9-]*)`/g)) {
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
    if (PENDING && e === PENDING && e.date <= TODAY) check(`${e.version}: the release being prepared — its entry is written, its tag comes after the merge`)
    else report('changelog', CHANGELOG, e.line, `${e.version} has no tag v${e.version}${e === ENTRIES[0] ? ` (a pending entry is one SemVer step above v${LATEST_TAG.version}, dated no later than today)` : ''}`)
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
const MARKER_BEFORE = /(?:as of|(?:is|now|currently) at|we are (?:on|at)|latest(?: release)?:?|current(?: version| release)?(?: is)?:?|supported:?(?: the)?)\s*`?v?$/i
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
          || /(?:--branch|checkout|switch)\s+$/.test(before) || /shields\.io\/badge\//.test(s)
        const claim = MARKER_BEFORE.test(before) || ((CURRENCY.test(near) || self) && !HISTORICAL.test(before))
        if (claim) report('current-version', p, u.at[m.index], `${m[0]} reads as the current version, which is ${CURRENT}`)
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
// names nothing to resolve.
const NOT_A_PATH = /[<>*…$]|YYYY|NNN|\bv[XY]\b|^(?:origin|refs|feat|fix|hotfix|chore|docs|release|worktree-agent)\/|(?:^|\/)\.git\/|^\/|^\.\.?\//
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
        const target = path ? posix.normalize(posix.join(posix.dirname(p), decodeURI(path))) : p
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
  for (const p of FILES.filter((f) => f === 'CLAUDE.md' || /^\.claude\/commands\/[^/]+\.md$/.test(f))) {
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
        const [a, b] = sentenceAround(u.text, m.index)
        if (/\be\.g\.|\bfor example\b|\bsuch as\b/i.test(u.text.slice(a, b))) continue
        n.path++
        if (!resolvePath(t, p)) report('link', p, u.at[m.index], `\`${t}\` names no file or directory of the repository`)
      }
      for (const r of sectionRefs(u.text)) {
        const files = resolvePath(r.file, p)
        if (!files || files.length !== 1 || !isMd(files[0])) continue
        n.title++
        if (!titleIn(files[0], r)) report('link', p, u.at[r.index], `${r.file} has no section ${r.kind === 'number' ? `§${r.title}` : `"${r.title}"`}`)
      }
    }
  }
  settle('link', `${n.md} Markdown links, ${n.wiki} wikilinks, ${n.at} @-imports, ${n.path} cited paths and ${n.title} section titles resolve`)
}
// sectionRefs(s): the sections a unit cites WITH their file — `file`, *Title*;
// `file` (*Title*); `file` ("Title"); `file` §N — and docs/NN, *Title* without backticks.
function sectionRefs(s) {
  const out = []
  const file = String.raw`(?:\`([^\`\n]+\.md|docs\/\d\d)\`|\b(docs\/\d\d)\b)(?:'s)?`
  for (const m of s.matchAll(new RegExp(`${file}\\s*(?:,\\s*|\\(\\s*)\\*"?([^*"\\n]+?)"?\\*`, 'g'))) out.push({ file: m[1] ?? m[2], title: m[3], kind: 'title', index: m.index })
  for (const m of s.matchAll(new RegExp(`${file}\\s*,?\\s*\\(\\s*"([^"\\n]+)"\\s*\\)`, 'g'))) out.push({ file: m[1] ?? m[2], title: m[3], kind: 'title', index: m.index })
  for (const m of s.matchAll(new RegExp(`${file},?\\s*§\\s*(\\d+)`, 'g'))) out.push({ file: m[1] ?? m[2], title: m[3], kind: 'number', index: m.index })
  return out
}
const normTitle = (t) => t.replace(/[`*"“”]/g, '').replace(/\s+/g, ' ').trim().toLowerCase()
  .replace(/^(?:\d+\.|step \d+ —)\s*/, '')
// titleIn(p, ref): whether a cited title is a heading or a bold lead-in of p — exactly, cut
// at its first " — ", ":" or " (", or as a whole-word prefix; a §N, a "## N." heading.
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

// --- The declared exceptions -------------------------------------------------------------
// What the rules above cannot tell apart, each with its reason. Bidirectional: an entry that
// covers nothing fails below, so it is removed with its cause.
const ALLOW = [
  // The payload.
  { check: 'imp-number', file: LEARNINGS, text: '### IMP-001 — <short title>', reason: 'the format example of the template: a project numbers its own IMPs from 001' },
  // Inventories.
  { check: 'inventory', file: '*', text: '`/clear`', reason: 'a command of Claude Code itself, not one of the method' },
  { check: 'inventory', file: SETUP, text: '`/tmp`', reason: 'a directory, not a command' },
  // Links: names that are not meant to exist in this repository.
  { check: 'link', file: '*', text: '`.claude/framework-version`', reason: 'the provenance pin: created in a project at its graft, never here' },
  { check: 'link', file: '*', text: '`settings.local.json`', reason: 'personal permissions: local and unversioned by design (.gitignore)' },
  { check: 'link', file: '.claude/docs/04-git-workflow.md', text: '`.claude/worktrees/`', reason: 'where Claude Code puts an isolated agent\'s worktree, ignored by .gitignore' },
  { check: 'link', file: '.claude/docs/04-git-workflow.md', text: '`secrets/`', reason: 'a generic example of where secrets live' },
  { check: 'link', file: SETUP, text: '`adr/`', reason: 'an example of where a project keeps its ADRs' },
]

// --- The allow-list itself ---------------------------------------------------------------
function checkAllowList() {
  section('The allow-list — every declared exception still matches something')
  for (const a of ALLOW) {
    if (!a.reason) fail(`ALLOW ${a.check} ${a.file} "${a.text ?? a.section}": an exception without its reason`)
    if (!a.used) fail(`ALLOW ${a.check} ${a.file} "${a.text ?? a.section}" matches nothing: its cause is gone, remove it`)
  }
  if (ALLOW.every((a) => a.used && a.reason)) ok(`${plural(ALLOW.length, 'declared exception')}, each with its reason, each still needed`)
}

checkImpNumbers()
checkPointers()
checkInventories()
checkChangelog()
checkCurrentVersion()
checkLinks()
checkAllowList()
console.log(`\ndocs-check: ${nFail} FAIL, ${nCheck} CHECK`)
process.exit(nFail ? 1 : 0)
