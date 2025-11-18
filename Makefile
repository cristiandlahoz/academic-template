# =============================================================================
# MAKEFILE PROFESIONAL PARA TEMPLATE ACADÉMICO
# =============================================================================
# Este Makefile automatiza la compilación del documento LaTeX con bibliografía
# y proporciona comandos útiles para el desarrollo y mantenimiento.

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

# =============================================================================
# COMANDOS PRINCIPALES
# =============================================================================

# Comando por defecto: compilación completa
.PHONY: all
all: build

# Compilación completa con bibliografía
.PHONY: build
build: setup
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

# Compilación rápida (sin bibliografía)
.PHONY: quick
quick: setup
	@echo "=== Compilación rápida (sin bibliografía) ==="
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) $(MAIN_TEX)
	@mkdir -p $(OUTPUT_DIR)
	@cp $(BUILD_DIR)/$(basename $(MAIN_TEX)).pdf $(PDF_OUTPUT)
	@echo "=== Compilación rápida completada ==="

# Visualizar el documento
.PHONY: view
view: $(PDF_OUTPUT)
	@echo "Abriendo documento..."
	$(VIEWER) $(PDF_OUTPUT)

# Compilar y visualizar
.PHONY: show
show: build view

# =============================================================================
# COMANDOS DE MANTENIMIENTO
# =============================================================================

# Configuración inicial
.PHONY: setup
setup:
	@echo "Creando directorios necesarios..."
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OUTPUT_DIR)

# Limpiar archivos temporales
.PHONY: clean
clean:
	@echo "Limpiando archivos temporales..."
	@rm -f $(TEMP_FILES)
	@rm -rf $(BUILD_DIR)/*
	@echo "Archivos temporales eliminados."

# Limpiar todo (incluyendo PDF de salida)
.PHONY: clean-all
clean-all: clean
	@echo "Eliminando archivos de salida..."
	@rm -rf $(OUTPUT_DIR)
	@echo "Limpieza completa realizada."

# =============================================================================
# COMANDOS DE DESARROLLO
# =============================================================================

# Compilación continua (requiere latexmk)
.PHONY: watch
watch:
	@echo "=== Modo de compilación continua ==="
	@echo "El documento se recompilará automáticamente al detectar cambios."
	@echo "Presiona Ctrl+C para detener."
	latexmk -pdf -pvc -output-directory=$(BUILD_DIR) $(MAIN_TEX)

# Verificar dependencias
.PHONY: check-deps
check-deps:
	@echo "=== Verificando dependencias ==="
	@command -v $(LATEX_ENGINE) >/dev/null 2>&1 || { echo "Error: $(LATEX_ENGINE) no está instalado."; exit 1; }
	@command -v $(BIBER_ENGINE) >/dev/null 2>&1 || { echo "Error: $(BIBER_ENGINE) no está instalado."; exit 1; }
	@echo "Todas las dependencias están disponibles."

# Información del proyecto
.PHONY: info
info:
	@echo "=== Información del Template Académico ==="
	@echo "Archivo principal: $(MAIN_TEX)"
	@echo "Motor LaTeX: $(LATEX_ENGINE)"
	@echo "Motor bibliografía: $(BIBER_ENGINE)"
	@echo "Directorio de construcción: $(BUILD_DIR)"
	@echo "Directorio de salida: $(OUTPUT_DIR)"
	@echo "PDF final: $(PDF_OUTPUT)"
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  make build      - Compilación completa"
	@echo "  make quick      - Compilación rápida"
	@echo "  make view       - Ver documento"
	@echo "  make show       - Compilar y ver"
	@echo "  make clean      - Limpiar temporales"
	@echo "  make clean-all  - Limpiar todo"
	@echo "  make watch      - Compilación continua"
	@echo "  make check-deps - Verificar dependencias"

# Ayuda
.PHONY: help
help: info

# =============================================================================
# REGLAS ESPECIALES
# =============================================================================

# Prevenir eliminación de archivos intermedios
.PRECIOUS: $(BUILD_DIR)/%.aux $(BUILD_DIR)/%.bbl

# Indicar que estos targets no corresponden a archivos
.PHONY: all build quick view show setup clean clean-all watch check-deps info help
