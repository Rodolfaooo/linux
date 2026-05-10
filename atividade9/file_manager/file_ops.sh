#!/bin/bash

source utils.sh
source logger.sh

create_file() {
    read -p "Nome do arquivo: " filename
    
    validate_filename "$filename" || { show_error "Nome inválido"; return 1; }
    file_exists "$filename" && { show_error "Arquivo já existe"; return 1; }
    
    local fullpath="$BASE_DIR/$filename"
    read -p "Conteúdo (opcional): " content
    
    echo "$content" > "$fullpath"
    chmod 644 "$fullpath"
    
    show_success "Arquivo criado: $filename"
    log_info "Criado: $filename"
}

list_files() {
    echo "========================================="
    printf "%-25s %-10s %-10s\n" "NOME" "TAMANHO" "PERM"
    echo "========================================="
    
    local count=0
    for file in "$BASE_DIR"/*; do
        if [[ -f "$file" ]]; then
            local name=$(basename "$file")
            local size=$(stat -c%s "$file" 2>/dev/null)
            local perm=$(stat -c%a "$file" 2>/dev/null)
            printf "%-25s %-10s %-10s\n" "$name" "$size" "$perm"
            ((count++))
        fi
    done
    
    echo "========================================="
    show_info "Total: $count arquivo(s)"
    log_info "Listagem executada"
}

search_file() {
    read -p "Padrão de busca: " pattern
    [[ -z "$pattern" ]] && { show_error "Padrão vazio"; return 1; }
    
    echo "Resultados para: $pattern"
    echo "========================================="
    
    local found=0
    for file in "$BASE_DIR"/*; do
        if [[ -f "$file" ]]; then
            local name=$(basename "$file")
            if [[ "$name" == *"$pattern"* ]]; then
                echo "  ✓ $name"
                ((found++))
            fi
        fi
    done
    
    [[ $found -eq 0 ]] && show_warning "Nenhum arquivo encontrado"
    show_info "Encontrados: $found arquivo(s)"
    log_info "Busca: '$pattern' -> $found resultado(s)"
}

delete_file() {
    read -p "Nome do arquivo: " filename
    file_exists "$filename" || { show_error "Arquivo não existe"; return 1; }
    
    read -p "Confirmar exclusão de '$filename'? (s/N): " confirm
    [[ "$confirm" != "s" && "$confirm" != "S" ]] && { show_info "Cancelado"; return 0; }
    
    rm -f "$BASE_DIR/$filename"
    show_success "Arquivo deletado: $filename"
    log_info "Deletado: $filename"
}

read_file() {
    read -p "Nome do arquivo: " filename
    file_exists "$filename" || { show_error "Arquivo não existe"; return 1; }
    
    echo "========================================="
    echo "Conteúdo de $filename:"
    echo "========================================="
    cat "$BASE_DIR/$filename"
    echo "========================================="
    log_info "Lido: $filename"
}

edit_file() {
    read -p "Nome do arquivo: " filename
    file_exists "$filename" || { show_error "Arquivo não existe"; return 1; }
    
    read -p "Novo conteúdo: " content
    echo "$content" > "$BASE_DIR/$filename"
    show_success "Arquivo atualizado: $filename"
    log_info "Editado: $filename"
}

copy_file() {
    read -p "Arquivo origem: " src
    read -p "Arquivo destino: " dst
    
    file_exists "$src" || { show_error "Origem não existe"; return 1; }
    
    cp "$BASE_DIR/$src" "$BASE_DIR/$dst"
    show_success "Copiado: $src -> $dst"
    log_info "Copiado: $src para $dst"
}

move_file() {
    read -p "Arquivo origem: " src
    read -p "Arquivo destino: " dst
    
    file_exists "$src" || { show_error "Origem não existe"; return 1; }
    
    mv "$BASE_DIR/$src" "$BASE_DIR/$dst"
    show_success "Movido: $src -> $dst"
    log_info "Movido: $src para $dst"
}

file_info() {
    read -p "Nome do arquivo: " filename
    file_exists "$filename" || { show_error "Arquivo não existe"; return 1; }
    
    local fullpath="$BASE_DIR/$filename"
    echo "========================================="
    echo "Informações: $filename"
    echo "========================================="
    echo "Tamanho: $(stat -c%s "$fullpath") bytes"
    echo "Permissões: $(stat -c%a "$fullpath")"
    echo "Última modificação: $(stat -c%y "$fullpath")"
    echo "Proprietário: $(stat -c%U "$fullpath")"
    echo "========================================="
    log_info "Info visualizada: $filename"
}
