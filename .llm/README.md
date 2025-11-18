# LLM Interaction Guide

This folder contains structured prompts and schemas for AI assistants to interact with the academic template.

## Quick Start for LLMs

1. Read `prompts/schema.json` to understand the template structure
2. Use the appropriate prompt file for your task
3. Follow the guardrails defined in each prompt

## Prompt Files

| File | Purpose |
|------|---------|
| `schema.json` | Full template configuration schema and valid options |
| `modify-config.json` | Modify institution settings in config/institution.tex |
| `create-table.json` | Create tables using the academictable component |
| `add-content.json` | Add document content (sections, text, citations) |

## Guardrails

Each prompt defines:

- **allowed**: Actions the LLM CAN perform
- **forbidden**: Actions the LLM must NOT perform

Always check these before making changes.

## File Structure Reference

```
academic-template/
├── .llm/prompts/          # You are here
├── config/
│   ├── institution.tex    # MODIFY THIS for institution settings
│   └── presets/           # Preset configurations
├── components/
│   ├── tables.tex         # Table components
│   ├── headers.tex        # Header/footer components
│   └── boxes.tex          # Box/callout components
├── templates/
│   └── academic-template.tex  # Base template
├── assets/                # Logos and images
└── output/                # Generated PDFs
```

## Common Tasks

### Change Institution

1. Read `prompts/modify-config.json`
2. Edit `config/institution.tex`
3. Change only values, not command names

### Create a Table

1. Read `prompts/create-table.json`
2. Use `academictable` environment
3. Use `\headerCell{}` for headers
4. Choose appropriate column types (C, L, R, Y, Z)

### Add Content

1. Read `prompts/add-content.json`
2. Use proper LaTeX section commands
3. Reference components for tables/boxes
4. Use `\cite{}` for citations

## Validation

After any modification:

1. Ensure LaTeX compiles without errors
2. Verify no structural changes to command names
3. Check that colors reference defined names, not hardcoded RGB
