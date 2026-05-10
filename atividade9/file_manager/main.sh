#!/bin/bash

source config.sh
source utils.sh
source logger.sh
source file_ops.sh
source permissions.sh
source report.sh
source tests.sh

show_menu() {
    clear
    echo "========================================="
    echo "       FILE MANAGER SYSTEM v1.0"
    echo "========================================="
    echo "  1 - Criar arquivo"
    echo "  2 - Listar arquivos"
    echo "  3 - Buscar arquivo"
    echo "  4 - Ler arquivo"
    echo "  5 - Editar arquivo"
    echo "  6 - Deletar arquivo"
    echo "  7 - Copiar arquivo"
    echo "  8 - Mover arquivo"
    echo "  9 - Informações do arquivo"
    echo " 10 - Alterar permissão"
    echo " 11 - Alterar proprietário"
    echo " 12 - Ver permissões"
    echo " 13 - Backup/restore permissões"
    echo " 14 - Gerar relatório"
    echo " 15 - Ver logs"
    echo " 16 - Executar testes"
    echo " 17 - Limpar logs"
    echo "  0 - Sair"
    echo "========================================="
}

handle_option() {
    case $1 in
        1) create_file ;;
        2) list_files ;;
        3) search_file ;;
        4) read_file ;;
        5) edit_file ;;
        6) delete_file ;;
        7) copy_file ;;
        8) move_file ;;
        9) file_info ;;
        10) change_permission ;;
        11) change_owner ;;
        12) show_permissions ;;
        13) 
            echo "1 - Backup | 2 - Restore"
            read -p "Escolha: " br
            [[ $br -eq 1 ]] && backup_permissions || restore_permissions
            ;;
        14)
            read -p "Formato (txt/csv): " fmt
            generate_report "${fmt:-txt}"
            ;;
        15) view_logs ;;
        16) run_all_tests ;;
        17) clear_logs ;;
        0) 
            log_info "Sistema finalizado"
            echo -e "\033[0;32mSaindo...\033[0m"
            exit 0
            ;;
        *) show_error "Opção inválida" ;;
    esac
}

main() {
    init_dirs
    log_info "Sistema iniciado"
    
    while true; do
        show_menu
        read -p "Escolha uma opção: " option
        handle_option "$option"
        echo ""
        read -p "Pressione ENTER para continuar"
    done
}

main
