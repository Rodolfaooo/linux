#!/bin/bash

source utils.sh
source logger.sh
source file_ops.sh

change_permission() {
    read -p "Arquivo: " filename
    file_exists "$filename" || { show_error "Arquivo não existe"; return 1; }
    
    read -p "Permissão (ex: 755, 644): " perm
    validate_permission "$perm" || { show_error "Permissão inválida"; return 1; }
    
    chmod "$perm" "$BASE_DIR/$filename"
    show_success "Permissão alterada: $perm"
    log_info "Permissão alterada: $filename -> $perm"
}

change_owner() {
    read -p "Arquivo: " filename
    file_exists "$filename" || { show_error "Arquivo não existe"; return 1; }
    
    read -p "Novo proprietário: " owner
    id "$owner" &>/dev/null || { show_error "Usuário inválido"; return 1; }
    
    sudo chown "$owner" "$BASE_DIR/$filename" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        show_success "Proprietário alterado: $owner"
        log_info "Owner alterado: $filename -> $owner"
    else
        show_error "Falha ao alterar (use sudo?)"
    fi
}

show_permissions() {
    read -p "Arquivo: " filename
    file_exists "$filename" || { show_error "Arquivo não existe"; return 1; }
    
    ls -l "$BASE_DIR/$filename"
    log_info "Permissões visualizadas: $filename"
}

backup_permissions() {
    local backup_file="$REPORT_DIR/permissions_backup.txt"
    echo "Backup de permissões - $(get_timestamp)" > "$backup_file"
    
    for file in "$BASE_DIR"/*; do
        if [[ -f "$file" ]]; then
            local name=$(basename "$file")
            local perms=$(stat -c%a "$file" 2>/dev/null)
            echo "$name:$perms" >> "$backup_file"
        fi
    done
    
    show_success "Backup salvo: $backup_file"
    log_info "Backup de permissões criado"
}

restore_permissions() {
    local backup_file="$REPORT_DIR/permissions_backup.txt"
    [[ -f "$backup_file" ]] || { show_error "Backup não encontrado"; return 1; }
    
    while IFS=':' read -r filename perms; do
        if file_exists "$filename"; then
            chmod "$perms" "$BASE_DIR/$filename"
            echo "Restaurado: $filename -> $perms"
        fi
    done < "$backup_file"
    
    show_success "Permissões restauradas"
    log_info "Permissões restauradas do backup"
}
