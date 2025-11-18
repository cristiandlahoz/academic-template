# Academic Template

A professional, configuration-driven LaTeX template for academic documents with LLM optimization.

## Features

- **Configuration-driven**: Change institution by modifying one file
- **Reusable components**: Tables, boxes, headers as modular components
- **LLM-optimized**: Structured prompts and schemas for AI assistants
- **Professional design**: Customizable colors, headers, and typography

## Project Structure

```
academic-template/
├── .llm/
│   └── prompts/           # LLM interaction prompts
│       ├── schema.json    # Template configuration schema
│       ├── modify-config.json
│       ├── create-table.json
│       └── add-content.json
├── config/
│   ├── institution.tex    # Active configuration
│   └── presets/
│       ├── pucmm.tex      # PUCMM preset
│       └── default.tex    # Default preset
├── components/
│   └── tables.tex         # Reusable table components
├── assets/                # Logos and images
├── output/                # Generated PDFs
├── academic-template.tex  # Main template
├── title-page.tex         # Title page template
├── biblio.bib             # Bibliography
└── Makefile               # Build automation
```

## Quick Start

### 1. Configure Institution

Edit `config/institution.tex` or copy a preset:

```bash
cp config/presets/pucmm.tex config/institution.tex
```

### 2. Build Document

```bash
make build    # Full compilation with bibliography
make quick    # Fast compilation without bibliography
make show     # Compile and open PDF
```

## Configuration

### Institution Settings

Edit `config/institution.tex`:

```latex
\newcommand{\institutionName}{Your University}
\newcommand{\institutionShortName}{UNI}
\newcommand{\institutionLogo}{assets/logo.png}
```

### Brand Colors

```latex
\definecolor{primaryColor}{RGB}{124, 10, 2}
\definecolor{secondaryColor}{RGB}{240, 89, 65}
\definecolor{accentColor}{RGB}{239, 167, 0}
```

## Components

### Tables

Use the `academictable` environment with flexible column types:

```latex
\begin{academictable}{C{2cm} Y Z}
\headerCell{ID} & \headerCell{Name} & \headerCell{Status} \\
\midrule
001 & Project Alpha & Active \\
002 & Project Beta & Completed \\
\end{academictable}
```

**Column Types:**
- `C{width}` - Centered with fixed width
- `L{width}` - Left-aligned with fixed width
- `R{width}` - Right-aligned with fixed width
- `Y` - Auto-expand left-aligned
- `Z` - Auto-expand centered

## LLM Integration

This template is optimized for AI assistants. Prompts in `.llm/prompts/` define:

- **schema.json**: Valid configuration options and types
- **modify-config.json**: How to modify institution settings
- **create-table.json**: How to create tables using components
- **add-content.json**: How to add document content

### For LLMs: Quick Reference

1. Read `.llm/prompts/schema.json` to understand the template structure
2. Modify only values in `config/institution.tex`, not command names
3. Use `academictable` environment for all tables
4. Use `\headerCell{}` for table headers
5. Never hardcode colors - use defined color names

### Example Prompt

```
Modify the institution to MIT with blue primary color
```

The LLM should:
1. Read `modify-config.json` for guardrails
2. Edit `config/institution.tex`
3. Change `\institutionName` value to "Massachusetts Institute of Technology"
4. Change `primaryColor` RGB to blue values

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make build` | Full compilation with bibliography |
| `make quick` | Fast compilation |
| `make view` | Open PDF |
| `make show` | Compile and open |
| `make clean` | Remove temp files |
| `make clean-all` | Remove all generated files |
| `make watch` | Auto-recompile on changes |

## Requirements

- LaTeX distribution (TeXLive, MiKTeX, MacTeX)
- pdflatex
- biber
- make (optional)

### macOS
```bash
brew install --cask mactex
```

### Ubuntu/Debian
```bash
sudo apt-get install texlive-full biber
```

## Creating New Projects

1. Create a branch from master:
```bash
git checkout -b project/my-document
```

2. Configure institution in `config/institution.tex`

3. Edit main document or create new `.tex` file

4. Build with `make build`

## License

Free for academic and educational use.

---

**Maintained by**: Cristian de la Hoz
