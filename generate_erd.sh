#!/bin/bash

# Script para generar diagramas ER en múltiples formatos
# Uso: ./generate_erd.sh

echo "🔄 Generando diagramas Entity-Relationship (ER)..."
echo ""

# PDF Vertical (para impresión)
echo "📄 Generando PDF vertical (para impresión multi-página)..."
bundle exec erd --filetype=pdf --orientation=vertical --filename=erd_print

# SVG (escalable, para web)
echo "🌐 Generando SVG (escalable)..."
bundle exec erd --filetype=svg --filename=erd_print

# PNG (alta resolución, 4375x2361px)
echo "🖼️  Generando PNG de alta resolución..."
bundle exec erd --filetype=png --filename=erd_print

echo ""
echo "✅ Diagramas generados exitosamente:"
echo "   📊 erd_print.pdf  - Optimizado para impresión (vertical)"
echo "   📊 erd_print.svg  - Escalable vectorial"
echo "   📊 erd_print.png  - Alta resolución (4375x2361px)"
echo ""
echo "💡 Para impresión: usa erd_print.pdf"
echo "💡 Para web/docs: usa erd_print.svg"
echo "💡 Para visualización: usa erd_print.png"
