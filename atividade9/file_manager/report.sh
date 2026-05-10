#!/bin/bash

source utils.sh
source logger.sh

generate_report() {
    local format="${1:-txt}"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local report_file="$REPORT_DIR/report_${timestamp}.${format}"
    
    case "$format" in
        txt) generate_txt_report "$report_file" ;;
        csv) generate_csv_report "$report_file" ;;
        *) show_error "Formato inválido"; return 1 ;;
    esac
    
    show_success "Relatório gerado: $report_file"
    log_info "Relatório gerado: $format"
}

generate_txt_report() {
    local output="$1"
    
    {
        echo "========================================="
        echo "RELATÓRIO DO SISTEMA"
        echo "========================================="
        echo "Data: $(get_timestamp)"
        echo "Usuário: $(whoami)"
        echo ""
        echo "ESTATÍSTICAS:"
        echo "-----------------------------------------"
        
        local total=0 total_size=0
        for file in "$BASE_DIR"/*; do
            if [[ -f "$file" ]]; then
                ((total++))
                total_size=$((total_size + $(stat -c%s "$file" 2>/dev/null || echo 0)))
            fi
        done
        
        echo "Total de arquivos: $total"
        echo "Tamanho total: $total_size bytes"
        echo "Espaço disponível: $(df -h . | awk 'NR==2 {print $4}')"
        echo ""
        echo "ARQUIVOS:"
        echo "-----------------------------------------"
        
        for file in "$BASE_DIR"/*; do
            if [[ -f "$file" ]]; then
                local name=$(basename "$file")
                local size=$(stat -c%s "$file" 2>/dev/null)
                local perms=$(stat -c%a "$file" 2>/dev/null)
                echo "$name | $size bytes | $perms"
            fi
        done
        
        echo ""
        echo "ÚLTIMAS OPERAÇÕES:"
        echo "-----------------------------------------"
        tail -20 "$LOG_FILE" 2>/dev/null
    } > "$output"
}

generate_csv_report() {
    local output="$1"
    echo "Arquivo,Tamanho,Permissões,Última_Modificação" > "$output"
    
    for file in "$BASE_DIR"/*; do
        if [[ -f "$file" ]]; then
            local name=$(basename "$file")
            local size=$(stat -c%s "$file" 2>/dev/null)
            local perms=$(stat -c%a "$file" 2>/dev/null)
            local modified=$(stat -c%y "$file" 2>/dev/null | cut -d' ' -f1)
            echo "$name,$size,$perms,$modified" >> "$output"
        fi
    done
}

list_reports() {
    echo "Relatórios disponíveis:"
    ls -lh "$REPORT_DIR"/report_* 2>/dev/null || echo "Nenhum relatório encontrado"
}
