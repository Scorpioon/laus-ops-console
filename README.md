
[LAUS_OPS_MASTER_README.md](https://github.com/user-attachments/files/26106146/LAUS_OPS_MASTER_README.md)
# LAUS OPS CONSOLE

**Internal operational console for LAUS submissions management**  
**Status:** Active development  
**Current milestone:** `v0.4.4a` compiles  
**Primary module:** `Submissions`  

---

## Overview

LAUS OPS CONSOLE is being developed as a **workstation-style internal tool** for managing award submissions.

The product direction is very specific:

- the **main table** is the operational spreadsheet
- the **Ficha de proyecto** is the controlled operational view of one spreadsheet row
- both are intended to become **1:1 representations of the same record**
- UI and behavior are designed first
- logic, persistence, and CSV integration are attached afterwards

The current codebase already has a solid shell and a strong visual direction. The core work now is to finish spreadsheet behavior, close the 1:1 mapping between table and ficha, and build a safe bridge between the current UI row model and the future real CSV flow.

---

## Product Principles

### 1. Wireframes are source of truth
If the wireframe shows:

- 3 columns + 2 rows

then the product should implement:

- exactly 3 columns + 2 rows

No loose reinterpretation.

### 2. Spreadsheet + ficha are a single system
The table is not a generic list and the ficha is not a generic side card.

They are:

- **table** = operational spreadsheet
- **ficha** = control view of a selected row

### 3. UI first, logic later
Visible product behavior comes first.

That does **not** mean fake UI forever. It means:

- design the right structures first
- keep everything modular
- make sure every visible concept can later receive logic cleanly

### 4. Avoid dead ends
If something exists in UI, it should later be able to map to:

- a stable data field
- a row id
- a persistence path
- a real interaction

---

## Current Technical Stack

- **Vite**
- **React 18**
- **TypeScript**
- **Zustand**
- **Dexie / IndexedDB scaffolding**
- **PapaParse CSV scaffolding**
- **CSS Modules**
- **PowerShell patch workflow**
- **Local DEVKIT environment**

---

## Current State Summary

### What is working well

- project shell is stable enough to iterate quickly
- `Submissions` is the real working module
- the **Ficha de proyecto** structure is finally strong
- pastel ADG-inspired color system is in a good direction
- spreadsheet behavior has advanced significantly
- horizontal spreadsheet thinking is now part of the UI direction
- checkpoints / patch workflow are established

### What is still fragile

- real CSV flow is **not connected** to the current UI row model
- many toolbar and field-level actions are still decorative or stubbed
- hidden modules are mostly placeholders
- spreadsheet semantics are not fully closed yet
- some encoding / mojibake issues have appeared across iterations
- the latest spreadsheet-behavior pass needs continuous verification after fixes

---

## Module Tree

| Module | Status | Notes |
|---|---:|---|
| `Submissions` | Active | Core workstation, main product focus |
| `Jury` | Placeholder | Safe shell only |
| `Templates` | Placeholder | Safe shell only |
| `Insights` | Placeholder | Safe shell only |
| `Help` | Placeholder | Safe shell only |
| `Awarded / Laurel` | Placeholder | Safe shell only |
| `Config` | Partial | Existing panel, some string cleanup needed over time |

### Assessment

- all modules are registered and switch correctly
- only `Submissions` currently has meaningful product depth
- hidden modules are structurally isolated enough to expand later
- no major reason to touch hidden modules before core submissions behavior is finished

---

## Core Functional Direction

### The table
The table is becoming:

- an operational spreadsheet
- horizontally scrollable
- sortable
- sticky in key columns
- semantically richer than a plain admin list

### The ficha de proyecto
The ficha is intended to become:

- the 1:1 record control view
- clearly sectioned
- operational, not decorative
- consistent in field affordances
- ready to receive edit/save logic later

### The first CSV import / export behavior
This is a major product rule:

- input CSV may be **legacy / incomplete**
- first exported CSV should already contain the **new columns introduced by the tool**
- this allows the client to enrich their dataset in a single pass

That means the current UI and data model decisions must remain compatible with a future **legacy CSV -> enriched CSV** bridge.

---

## Canonical Field Direction

The project is moving toward a canonical spreadsheet structure including:

- Ordre inscripció
- Inscripción
- Título
- Categoría
- Subcategoría
- Material físico recibido
- Descripció material fisic
- Material digital recibido
- Descripció material digital
- Plataforma / future-compatible workflow equivalent
- URL proyecto
- Link Dropbox
- Retorn de material
- Proyecto seleccionado
- Premio
- Nombre
- Apellidos
- Email
- Teléfono
- ADG-FAD
- OTRAS ASOCIACIONES
- Precio inscripción
- Pago confirmado
- Año

### Specific semantic decisions already made

- add **Subcategoría**
- rename **FAD** -> **ADG-FAD**
- add **OTRAS ASOCIACIONES**
  - default `NO`
  - acronym if applicable
- award should live in **Status**, not General Info
- awarded display should support patterns like:
  - `YES | BRONCE`
  - `YES | PLATA`
- `Plataforma` may need a careful transition if it is replaced by a more accurate workflow field
- table and ficha should converge into a strict 1:1 contract

---

## Category and Mock Data Grounding

The project stopped treating categories as arbitrary mock content and moved toward official structure.

### Professionals

Used grouping direction:

- `01–11` -> Editorial y dirección de arte
- `12–15` -> Tipografía
- `16–22` -> Packaging
- `23–36` -> Branding y gráfica del entorno
- `37–45` -> Comunicación gráfica publicitaria
- `46–53` -> Diseño digital
- `54–61` -> Comunicación audiovisual
- `00` -> Aporta

### Students

Used grouping direction:

- `A1–A4` -> Trabajo libre
- `B1–B4` -> Proyecto final de estudios
- `C1–C4` -> Másters y posgrados
- `D1–D3` -> Aporta Estudiantes

Discipline families:

- `1` -> Diseño gráfico
- `2` -> Digital
- `3` -> Publicidad
- `4` -> Audiovisual

### Awards logic

- professionals can use **Grand Laus**
- students use **Young Talent**

### OTRAS ASOCIACIONES examples

Typical mock acronyms considered valid:

- ADCV
- DAG
- CdeC
- APIC
- EIDE
- DiMad

---

## Design System Direction

The app now follows a more refined ADG-inspired logic.

### Visual language

- compact workstation feel
- spreadsheet + control sheet
- brutalist-adjacent clarity
- pastel semantic system instead of neon-dark badges

### Semantic color rule

For chips / badges / filters / many action treatments:

- **text** = accent color
- **border** = accent + `33` alpha
- **background** = paired pastel fill

### System actions

Intended resting-state semantics:

- Upload CSV = green
- Refresh / Update = blue
- Close session = orange
- Delete = red

Other actions may stay neutral by default and only accent on hover.

---

## Workflow Contract

### Roles

#### User
The user is:

- product owner
- frontend / UX / UI designer
- source of truth for layout, behavior, hierarchy, and visual intent

#### Assistant
The assistant acts as:

- technical work partner
- translator of intent into precise LLM/programmer instructions
- patch auditor
- continuity / modularity guard

#### Programmer LLM
The programmer LLM is expected to:

- implement, not redesign
- follow wireframes strictly
- return bounded patches
- avoid autonomous product decisions

### Patch workflow

1. user defines UI / behavior
2. assistant converts it into strict implementation instructions
3. programmer LLM returns:
   - exact file list
   - one single PowerShell patch
   - short explanation
4. assistant audits the patch
5. only then is the patch applied

### Preferred patch shape

Avoid giant mixed patches.

Prefer separate passes such as:

- visual pass
- spreadsheet behavior pass
- semantic/data-model pass
- CSV readiness pass
- cleanup pass

---

## DEVKIT / Local Working Environment

Assume a local Windows development workflow with:

- `K:\DEVKIT\...`
- local repo checkout
- PowerShell scripts (`.ps1`)
- Node / npm
- git branches and checkpoints
- local build and dev server

### Operational preference

When a fix is small and repeatable:

- prefer a direct script
- or a tight code block
- or a downloadable micro-fix file

---

## Full Global Changelog (Reconstructed)

## Early scaffold phase

- repo shell established
- Vite + React + TS structure created
- shared UI primitives added
- initial stores / types / services added
- initial mockdata introduced
- tabs and module shells created
- local patch workflow with PowerShell introduced

## Recovery / repair phase

- several early generated patches broke files badly
- repo had to be restored from a clean GitHub zip at least once
- local workflow hardened around:
  - patch script
  - build
  - dev
  - git checkpoint
- DEVKIT node/git environment stabilized

## `v0.4.0` workstation direction

- `Submissions` became the main product focus
- table + detail panel started behaving like software, not a demo
- top bar, toolbar, KPI strip, and internal navigation gained shape

## `v0.4.1` UI and workbench refinement

- stronger shell / workstation refinement
- top structure, tabs, statuses, layout improved
- multiple build fixes applied
- app started to feel like an actual internal console

## Phase 3 / Phase 4 lineage

- workstation got denser and more credible
- detail panel became more serious
- table + panel coexistence improved
- toolbar and selection workflow were strengthened

## `v0.4.2` audit and fidelity planning

- deep audit identified:
  - encoding issues
  - weak detail panel fidelity
  - bad selection styling
  - tags/badges not matching intended visual system
  - lost features and drift
- project moved into smaller-pass thinking:
  - visual pass
  - architecture pass
  - CSV pass

## `v0.4.3a`

- workstation visual pass
- inspector improved
- top structure clearer
- early breathing improvements
- still had serious layout drift and spacing problems

## `v0.4.3b`

- polish / fidelity pass
- encoding issues in mock data and other labels became a major topic
- status badge styling kept evolving
- table and ficha became easier to read

## `v0.4.3c`

- spreadsheet fidelity pass
- more columns visible
- inspector moved closer to the wireframes
- row/column structure improved
- still no convincing real lateral spreadsheet behavior yet

## `v0.4.3d`

- panel title changed to **Ficha de proyecto**
- links became more compact
- lower row improved
- table became more spreadsheet-like
- large structural whitespace still remained in ficha

## `v0.4.3e`

- **pastel ADG color system pass**
- strong visual improvement
- badges / chips / award / yes-no / toolbar logic softened and aligned better
- accepted as a major visual win

## `v0.4.3f`

- **technical corrections pass**
- major ficha whitespace problem diagnosed correctly as structural
- `upperGrid` growth fixed
- obsolete `ModuleTabs` removed
- Settings text cleanup improved
- ficha finally felt structurally right in terms of item distribution

## `v0.4.4a`

- **spreadsheet behavior pass**
- intended focus:
  - sticky first columns
  - remove `#`
  - real horizontal scroll
  - custom scrollbar
  - sort arrows restored
  - visible columns sortable
  - KPI flow cleanup
- this pass initially introduced TypeScript errors in `Table/index.tsx`
- micro-fix work was generated for the drag-scroll `useEffect`
- latest known state from user: **`v0.4.4a` now compiles**

### Important note about `v0.4.4a`
Compilation success was restored, but spreadsheet behavior still requires UX validation:

- horizontal scroll quality
- sticky columns quality
- bulk selector alignment
- sort affordance consistency

---

## Lost / Blurred Features Audit

These features were once discussed strongly but later became blurred, deferred, or partially lost.

### 1. Laurel / fake Laus AI
- once more present conceptually
- currently only a shell / placeholder module
- implementation direction is largely lost for now

### 2. Fake login / active operator
- originally important for:
  - session identity
  - operator attribution
  - work context
- currently highly blurred / mostly absent

### 3. Strong Close Session panel
Originally envisioned with:

- active operator
- last save
- last export
- change summary
- segmented export options

Current state:
- not anchored as a real feature anymore

### 4. Workflow strip / persistent operational pedagogy
Originally the app also aimed to teach the workflow clearly:

- upload CSV
- review
- save session
- export
- see system status clearly

Current state:
- toolbar and KPI exist
- persistent workflow pedagogy is much weaker than initially imagined

### 5. Rich Help Desk
Originally discussed with:

- per-module help
- explained buttons
- hotkeys
- FAQ
- recovery guidance
- good practices

Current state:
- shell exists
- rich content is not anchored yet

### 6. Granular export
Once discussed explicitly:

- export all
- export professionals
- export students
- export jury

Current state:
- export exists only as direction / placeholder
- segmentation is blurred

### 7. Real logic behind visible actions
Still largely pending:

- pencils
- dropdown affordances
- save / duplicate actions
- toolbar actions
- persistence behind ficha interactions

Not lost, but definitely still unfinished.

---

## Master Feature Inventory

## Core shell
- top bar
- tabs / navigation
- footer
- theme handling
- modular folder structure
- PowerShell patch workflow
- DEVKIT local workflow

## Submissions workstation
- spreadsheet table
- row selection
- bulk checkbox
- ficha opening from selected row
- KPI strip
- toolbar
- horizontal spreadsheet direction
- sticky column direction
- sortable column direction
- custom scrollbar direction

## Ficha de proyecto
- title = Ficha de proyecto
- upper row with 3 columns
- lower row with wide block + action rail
- general info
- contact
- status
- links
- notes
- save / discard / contact / duplicate / delete
- compact lower row direction
- fixed panel direction

## Semantic data / UI direction
- payment
- physical material
- digital material
- return material
- project selected
- awarded
- award level
- ADG-FAD
- otras asociaciones
- subcategoría
- 1:1 table/ficha contract
- enriched first export behavior

## Spreadsheet semantics
- first code digits tied to category/subcategory logic
- professional taxonomy
- student taxonomy
- awards taxonomy by mode
- association acronyms
- sticky checkbox + code columns
- all visible columns sortable
- smart column widths
- centered cell content where appropriate

## System / workflow layer
- upload CSV
- refresh
- close session
- delete
- export / filters / columns
- professional/student mode switch
- active operator direction
- session / save / export layer
- workflow pedagogy direction
- enriched CSV strategy

## Future modules
- Jury
- Templates
- Insights
- Help
- Awarded / Laurel
- Config

---

## Roadmap From Here

## `v0.4.4b` — spreadsheet semantics pass
Focus:

- validate and polish `v0.4.4a`
- fully stabilize sticky + scroll + bulk/header behavior
- ensure sort affordances are present everywhere intended
- implement true student/professional toggle with thumb (not fake segmented control)
- keep top KPI row visually coherent

## `v0.4.5` — strict 1:1 table / ficha pass
Focus:

- audit fields row-by-row
- anything in ficha must exist in table
- anything in table must exist in ficha
- remove remaining divergence

## `v0.4.6` — semantic fields pass
Focus:

- introduce real `Subcategoría`
- rename `FAD` -> `ADG-FAD`
- add `OTRAS ASOCIACIONES`
- keep award only in Status
- support `YES | BRONCE` style display
- transition platform / markState safely without breaking legacy compatibility

## `v0.4.7` — grounded mockdata pass
Focus:

- repopulate mockdata with official category logic
- professionals and students
- awards aligned with mode
- associations aligned with real acronyms

## `v0.4.8` — CSV bridge pass
Focus:

- `RawSubmission` / `DerivedSubmission` <-> UI row model bridge
- file input entry point
- header mapping / normalization
- enriched first export behavior

## `v0.4.9` — persistence / dirty state pass
Focus:

- real `updateSubmission`
- field edits persist
- save / discard become real
- visible dirty state

## `v0.5.0` — workflow layer
Focus:

- active operator
- close session panel
- segmented export
- persistent workflow / session state
- richer helpdesk

## `v0.6.x+`
Focus:

- Jury real module
- Templates real module
- Insights real module
- Awarded / Laurel real module
- Config consolidation
- product hardening

---

## Recommended Working Method Going Forward

### Keep using small bounded passes
Do **not** mix in one patch:

- spreadsheet scroll behavior
- semantic field changes
- CSV legacy compatibility
- mockdata taxonomy
- toolbar redesign
- hidden module work

### Preferred sequence

1. behavior
2. 1:1 mapping
3. semantic fields
4. mockdata grounding
5. CSV bridge
6. persistence / workflow layer

This avoids false progress and keeps the repo auditable.

---

## Current Executive Conclusion

The project is no longer in “rescue mode”.  
It already has:

- clear product direction
- a recognizable workstation identity
- a credible ficha de proyecto
- a viable submissions core

The biggest remaining challenge is no longer raw layout.

It is now:

- spreadsheet semantics
- 1:1 table/ficha integrity
- safe future CSV compatibility
- disciplined expansion without drift

---

## Maintainer Note

This file is a reconstructed master roadmap and changelog from the development conversation history.
It is intended as an **operational source of truth**, not as a strict historical archive.

When in doubt:

- trust the latest accepted UI state
- trust the wireframes
- prefer bounded patches
- audit before applying
