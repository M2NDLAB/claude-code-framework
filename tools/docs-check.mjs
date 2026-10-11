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

// --- The declared exceptions -------------------------------------------------------------
// What the rules above cannot tell apart, each with its reason. Bidirectional: an entry that
// covers nothing fails below, so it is removed with its cause.
const ALLOW = [
  // The payload.
  { check: 'imp-number', file: LEARNINGS, text: '### IMP-001 — <short title>', reason: 'the format example of the template: a project numbers its own IMPs from 001' },
  // Inventories.
  { check: 'inventory', file: '*', text: '`/clear`', reason: 'a command of Claude Code itself, not one of the method' },
  { check: 'inventory', file: SETUP, text: '`/tmp`', reason: 'a directory, not a command' },
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
checkInventories()
checkAllowList()
console.log(`\ndocs-check: ${nFail} FAIL, ${nCheck} CHECK`)
process.exit(nFail ? 1 : 0)
