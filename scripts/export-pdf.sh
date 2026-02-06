#!/bin/bash
# Export markdown reports to high-quality PDF
# Handles: Mermaid diagrams (rendered as images), professional tables, Korean fonts
# Usage: ./scripts/export-pdf.sh [report.md|all]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORTS_DIR="$PROJECT_DIR/reports"
TEMP_DIR="$PROJECT_DIR/.export-temp"

# Puppeteer config for mermaid (no-sandbox for Linux)
mkdir -p "$TEMP_DIR"
cat > "$TEMP_DIR/puppeteer-config.json" << 'EOF'
{
  "args": ["--no-sandbox", "--disable-setuid-sandbox"]
}
EOF
export MERMAID_FILTER_PUPPETEER_CONFIG="$TEMP_DIR/puppeteer-config.json"

# LaTeX header for professional formatting
cat > "$TEMP_DIR/header.tex" << 'HEADER'
\usepackage{booktabs}
\usepackage{longtable}
\usepackage{array}
\usepackage{multirow}
\usepackage{colortbl}
\usepackage{float}
\usepackage{caption}
\usepackage{xcolor}
\usepackage{graphicx}

% Better table defaults
\renewcommand{\arraystretch}{1.4}
\setlength{\tabcolsep}{8pt}

% Caption styling
\captionsetup[table]{skip=8pt, font=small}
\captionsetup[figure]{skip=8pt, font=small}
HEADER

# Check dependencies
check_deps() {
  local missing=0
  for cmd in pandoc xelatex mermaid-filter; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "✗ Missing: $cmd"
      missing=1
    fi
  done
  if [ "$missing" -eq 1 ]; then
    echo ""
    echo "Install missing dependencies:"
    echo "  sudo apt install pandoc texlive-xetex texlive-fonts-recommended texlive-fonts-extra"
    echo "  npm install -g @mermaid-js/mermaid-cli mermaid-filter"
    exit 1
  fi
}

# Convert a single markdown file to PDF
convert_to_pdf() {
  local input="$1"
  local output="${input%.md}.pdf"
  local basename
  basename=$(basename "$input" .md)

  echo "→ Converting: $basename"

  pandoc "$input" -o "$output" \
    --pdf-engine=xelatex \
    --filter mermaid-filter \
    --variable mainfont="Noto Sans CJK KR" \
    --variable monofont="Noto Sans Mono CJK KR" \
    --variable geometry:margin=1in \
    --variable fontsize=11pt \
    --toc \
    --number-sections \
    -V colorlinks=true \
    -V linkcolor=NavyBlue \
    -H "$TEMP_DIR/header.tex" \
    --metadata date="$(date +%Y-%m-%d)" \
    2>"$TEMP_DIR/$basename.log"

  if [ -f "$output" ] && [ -s "$output" ]; then
    local size
    size=$(du -h "$output" | cut -f1)
    echo "  ✓ $output ($size)"
  else
    echo "  ✗ Failed - see $TEMP_DIR/$basename.log"
    cat "$TEMP_DIR/$basename.log" | tail -5
    return 1
  fi
}

# Main
check_deps

TARGET="${1:-all}"

if [ "$TARGET" = "all" ]; then
  echo "╔═══════════════════════════════════════════════════════════════╗"
  echo "║  High-Quality PDF Export                                      ║"
  echo "╚═══════════════════════════════════════════════════════════════╝"
  echo ""

  REPORTS=()
  while IFS= read -r line; do
    REPORTS+=("$line")
  done < <(find "$REPORTS_DIR" -name "*-report.md" 2>/dev/null | sort)

  if [ ${#REPORTS[@]} -eq 0 ]; then
    echo "✗ No reports found in $REPORTS_DIR"
    exit 1
  fi

  echo "Found ${#REPORTS[@]} reports"
  echo ""

  SUCCESS=0
  FAILED=0
  for report in "${REPORTS[@]}"; do
    if convert_to_pdf "$report"; then
      SUCCESS=$((SUCCESS + 1))
    else
      FAILED=$((FAILED + 1))
    fi
  done

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✓ Complete: $SUCCESS success, $FAILED failed"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  # Single file
  if [ -f "$TARGET" ]; then
    convert_to_pdf "$TARGET"
  elif [ -f "$REPORTS_DIR/$TARGET" ]; then
    convert_to_pdf "$REPORTS_DIR/$TARGET"
  else
    echo "✗ File not found: $TARGET"
    echo "Usage: $0 [report.md|all]"
    exit 1
  fi
fi

# Cleanup
rm -rf "$TEMP_DIR"
