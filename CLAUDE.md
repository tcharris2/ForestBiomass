# ForestBiomass — Claude Code Instructions

## Role

Operate as an R programmer developing an R package. The package should feature user-friendly functions focused on forest biomass and robust testing.

---

## Project Overview

ForestBiomass is an R package for calculating forest biomass and carbon using hierarchical allometric equations drawn from multiple scientific papers. The biomass hierarchy is:

**Forest → Trees → Components: Wood (stem), Branches, Foliage, Bark**

Primary scientific sources:
- **Ung et al., 2008** — allometric equations for BC species
- **Lambert et al., 2005** — allometric equations for Eastern Canada species
- **Harmon et al., 2011** — species-specific decay class reduction factors

Species are identified using NFI (National Forest Inventory) codes.

---

## Git Workflow

- **Default branch for all changes is `dev`** unless explicitly told otherwise.
- **Always use PowerShell** (not bash) for git commands. The project path contains spaces (`OneDrive - UBC`) which prevents bash git commands from producing output.
- Commit and push to `dev` after completing changes.
- Do not push to `main` unless explicitly instructed.

---

## R Package Conventions

- Documentation is written with **roxygen2**. After adding or modifying exported functions, remind the user to run `devtools::document()` to regenerate the NAMESPACE and `.Rd` files.
- Internal helper functions should still have roxygen2 docs but do not need `@export` unless they are already exported.
- Data objects live in `data/` with corresponding documentation scripts in `data_R/`.

---

## Code Style

- Follow the established architecture pattern:
  - User-facing `*Calc()` functions — validate inputs, print output messages, dispatch to internal calculator
  - Internal `*Calculator()` functions — iterate rows, apply modifiers, return a vector
  - Shared helpers — `betaVal()`, `carbonMod()`, `DCRF()`, `validateSpecies()`, `ungEqn()`
- New biomass components (foliage, bark) should follow this same pattern.
- Do not add comments that explain what the code does — only add comments when the *why* is non-obvious.
- Prefer direct function calls over `do.call()` unless a dynamic argument list is genuinely needed.

---

## Current Implementation Status

| Component | User function     | Status      |
|-----------|------------------|-------------|
| Wood      | `woodCalc()`     | Complete    |
| Branches  | `branchCalc()`   | Complete    |
| Foliage   | —                | Not started |
| Bark      | —                | Not started |

`branchCalc()` still uses `ungEqn1()` and `ungEqn2()`. Do not delete those files until `branchCalc` has been refactored to use the merged `ungEqn()`.
