# Variables de configuración
MAIN_TEX = templates/academic-template.tex
OUTPUT_NAME = document
LATEX_ENGINE = pdflatex
BIBER_ENGINE = biber
VIEWER = open  # En macOS. Cambiar por 'evince' en Linux o 'start' en Windows

# Directorios
BUILD_DIR = build
OUTPUT_DIR = output

# Archivos de salida y temporales
PDF_OUTPUT = $(OUTPUT_DIR)/$(OUTPUT_NAME).pdf
TEMP_FILES = *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.out *.run.xml *.synctex.gz *.toc *.lof *.lot

##@ General

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: all
all: build ## Default target: complete build

##@ Build

.PHONY: build
build: setup ## Complete compilation with bibliography
	@echo "=== Iniciando compilación completa ==="
	@echo "Primera pasada de LaTeX..."
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) $(MAIN_TEX)
	@echo "Procesando bibliografía..."
	cd $(BUILD_DIR) && $(BIBER_ENGINE) $(basename $(MAIN_TEX))
	@echo "Segunda pasada de LaTeX..."
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) $(MAIN_TEX)
	@echo "Tercera pasada de LaTeX (referencias cruzadas)..."
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) $(MAIN_TEX)
	@echo "Copiando archivo final..."
	@mkdir -p $(OUTPUT_DIR)
	@cp $(BUILD_DIR)/$(basename $(MAIN_TEX)).pdf $(PDF_OUTPUT)
	@echo "=== Compilación completada exitosamente ==="
	@echo "Archivo generado: $(PDF_OUTPUT)"

.PHONY: quick
quick: setup ## Quick compilation without bibliography
	@echo "=== Compilación rápida (sin bibliografía) ==="
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) $(MAIN_TEX)
	@mkdir -p $(OUTPUT_DIR)
	@cp $(BUILD_DIR)/$(basename $(MAIN_TEX)).pdf $(PDF_OUTPUT)
	@echo "=== Compilación rápida completada ==="

.PHONY: view
view: $(PDF_OUTPUT) ## Open the generated PDF
	@echo "Abriendo documento..."
	$(VIEWER) $(PDF_OUTPUT)

.PHONY: show
show: build view ## Build and view the document

##@ Maintenance

.PHONY: setup
setup: ## Create necessary directories
	@echo "Creando directorios necesarios..."
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OUTPUT_DIR)

.PHONY: init
init: check-deps setup ## Initialize the Academic Template project
	@echo "=== Inicializando Academic Template ==="
	@echo "Verificando estructura..."
	@test -d config || { echo "Error: directorio config/ no encontrado"; exit 1; }
	@test -d components || { echo "Error: directorio components/ no encontrado"; exit 1; }
	@test -d templates || { echo "Error: directorio templates/ no encontrado"; exit 1; }
	@echo "Estructura verificada correctamente."
	@echo ""
	@echo "Para comenzar:"
	@echo "  1. Edita config/institution.tex con tu institución"
	@echo "  2. Coloca tu logo en assets/"
	@echo "  3. Ejecuta 'make build'"
	@echo ""
	@echo "=== Template listo para usar ==="

.PHONY: clean
clean: ## Remove temporary files
	@echo "Limpiando archivos temporales..."
	@rm -f $(TEMP_FILES)
	@rm -rf $(BUILD_DIR)/*
	@echo "Archivos temporales eliminados."

.PHONY: clean-all
clean-all: clean ## Remove all generated files including output
	@echo "Eliminando archivos de salida..."
	@rm -rf $(OUTPUT_DIR)
	@echo "Limpieza completa realizada."

##@ Development

.PHONY: watch
watch: ## Continuous compilation mode (requires latexmk)
	@echo "=== Modo de compilación continua ==="
	@echo "El documento se recompilará automáticamente al detectar cambios."
	@echo "Presiona Ctrl+C para detener."
	latexmk -pdf -pvc -output-directory=$(BUILD_DIR) $(MAIN_TEX)

.PHONY: check-deps
check-deps: ## Verify required dependencies
	@echo "=== Verificando dependencias ==="
	@command -v $(LATEX_ENGINE) >/dev/null 2>&1 || { echo "Error: $(LATEX_ENGINE) no está instalado."; exit 1; }
	@command -v $(BIBER_ENGINE) >/dev/null 2>&1 || { echo "Error: $(BIBER_ENGINE) no está instalado."; exit 1; }
	@echo "Todas las dependencias están disponibles."

.PHONY: info
info: ## Display project information
	@echo "=== Información del Template Académico ==="
	@echo "Archivo principal: $(MAIN_TEX)"
	@echo "Motor LaTeX: $(LATEX_ENGINE)"
	@echo "Motor bibliografía: $(BIBER_ENGINE)"
	@echo "Directorio de construcción: $(BUILD_DIR)"
	@echo "Directorio de salida: $(OUTPUT_DIR)"
	@echo "PDF final: $(PDF_OUTPUT)"

.PRECIOUS: $(BUILD_DIR)/%.aux $(BUILD_DIR)/%.bbl
