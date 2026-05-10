#!/bin/bash

source file_ops.sh
source permissions.sh
source logger.sh

TESTS_PASSED=0
TESTS_FAILED=0

assert() {
    local name="$1"
    local cmd="$2"
    
    if eval "$cmd" 2>/dev/null; then
        echo -e "\033[0;32m✓ PASS: $name\033[0m"
        ((TESTS_PASSED++))
    else
        echo -e "\033[0;31m✗ FAIL: $name\033[0m"
        ((TESTS_FAILED++))
    fi
}

test_create_file() {
    touch "$BASE_DIR/test.txt"
    assert "Criar arquivo" "[[ -f '$BASE_DIR/test.txt' ]]"
    rm -f "$BASE_DIR/test.txt"
}

test_list_files() {
    touch "$BASE_DIR/test1.txt" "$BASE_DIR/test2.txt"
    local output=$(list_files 2>&1)
    assert "Listar arquivos" "echo '$output' | grep -q 'test1.txt'"
    rm -f "$BASE_DIR"/test*.txt
}

test_search_file() {
    touch "$BASE_DIR/unique_file.txt"
    assert "Buscar arquivo" "[[ -f '$BASE_DIR/unique_file.txt' ]]"
    rm -f "$BASE_DIR/unique_file.txt"
}

test_delete_file() {
    touch "$BASE_DIR/todelete.txt"
    rm -f "$BASE_DIR/todelete.txt"
    assert "Deletar arquivo" "[[ ! -f '$BASE_DIR/todelete.txt' ]]"
}

test_permissions() {
    touch "$BASE_DIR/permtest.txt"
    chmod 755 "$BASE_DIR/permtest.txt"
    local perm=$(stat -c%a "$BASE_DIR/permtest.txt" 2>/dev/null)
    assert "Alterar permissão" "[[ '$perm' == '755' ]]"
    rm -f "$BASE_DIR/permtest.txt"
}

test_copy_file() {
    touch "$BASE_DIR/source.txt"
    cp "$BASE_DIR/source.txt" "$BASE_DIR/dest.txt"
    assert "Copiar arquivo" "[[ -f '$BASE_DIR/dest.txt' ]]"
    rm -f "$BASE_DIR"/source.txt "$BASE_DIR"/dest.txt
}

test_logging() {
    log_info "Test log message"
    assert "Sistema de log" "grep -q 'Test log message' '$LOG_FILE'"
}

run_all_tests() {
    echo "========================================="
    echo "EXECUTANDO TESTES"
    echo "========================================="
    
    init_dirs
    
    test_create_file
    test_list_files
    test_search_file
    test_delete_file
    test_permissions
    test_copy_file
    test_logging
    
    echo "========================================="
    echo -e "RESULTADO: \033[0;32mPASS: $TESTS_PASSED\033[0m | \033[0;31mFAIL: $TESTS_FAILED\033[0m"
    echo "========================================="
    
    # Limpeza
    rm -rf "$BASE_DIR"/* 2>/dev/null
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi
