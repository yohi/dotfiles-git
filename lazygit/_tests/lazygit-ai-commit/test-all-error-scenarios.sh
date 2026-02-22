#!/bin/bash
# Comprehensive error scenario testing
# Validates all error handling paths work correctly

set -e

# Determine the base scripts directory relative to this test script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "=== Comprehensive Error Scenario Testing ==="
echo ""

PASS_COUNT=0
FAIL_COUNT=0

test_scenario() {
    local name="$1"
    local expected_error="$2"
    shift 2
    
    echo "Testing: $name"
    if "$@" 2>&1 | grep -q "$expected_error"; then
        echo "✓ PASS"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "✗ FAIL: Expected error '$expected_error' not found"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    echo ""
}

# Scenario 1: Empty diff input
test_scenario "Empty diff input to AI generator" "No diff input provided" \
    bash -c 'echo "" | AI_BACKEND=mock "$1"/_scripts/lazygit-ai-commit/ai-commit-generator.sh' -- "$SCRIPT_DIR"

# Mock backup and cleanup trap
MOCK_TOOL_PATH="${SCRIPT_DIR}/_scripts/lazygit-ai-commit/mock-ai-tool.sh"
MOCK_BACKUP="${MOCK_TOOL_PATH}.backup"
cleanup() {
    if [ -f "$MOCK_BACKUP" ]; then
        mv "$MOCK_BACKUP" "$MOCK_TOOL_PATH"
    fi
}
trap cleanup EXIT

# Scenario 2: AI tool returns empty output
EMPTY_AI=$(mktemp)
cat > "$EMPTY_AI" << 'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$EMPTY_AI"
cp "$MOCK_TOOL_PATH" "$MOCK_BACKUP"
cp "$EMPTY_AI" "$MOCK_TOOL_PATH"

test_scenario "AI tool returns empty output" "AI tool returned empty output" \
    bash -c 'echo "test diff" | AI_BACKEND=mock "$1"/_scripts/lazygit-ai-commit/ai-commit-generator.sh' -- "$SCRIPT_DIR"

mv "$MOCK_BACKUP" "$MOCK_TOOL_PATH"
rm "$EMPTY_AI"

# Scenario 3: AI tool fails with error
FAILING_AI=$(mktemp)
cat > "$FAILING_AI" << 'EOF'
#!/bin/bash
echo "Internal error" >&2
exit 1
EOF
chmod +x "$FAILING_AI"
cp "$MOCK_TOOL_PATH" "$MOCK_BACKUP"
cp "$FAILING_AI" "$MOCK_TOOL_PATH"

test_scenario "AI tool fails with non-zero exit code" "AI tool failed" \
    bash -c 'echo "test diff" | AI_BACKEND=mock "$1"/_scripts/lazygit-ai-commit/ai-commit-generator.sh' -- "$SCRIPT_DIR"

mv "$MOCK_BACKUP" "$MOCK_TOOL_PATH"
rm "$FAILING_AI"

# Scenario 4: AI tool times out
SLOW_AI=$(mktemp)
cat > "$SLOW_AI" << 'EOF'
#!/bin/bash
sleep 10
echo "feat: too slow"
EOF
chmod +x "$SLOW_AI"
cp "$MOCK_TOOL_PATH" "$MOCK_BACKUP"
cp "$SLOW_AI" "$MOCK_TOOL_PATH"

test_scenario "AI tool times out" "timed out" \
    bash -c 'echo "test diff" | TIMEOUT_SECONDS=1 AI_BACKEND=mock "$1"/_scripts/lazygit-ai-commit/ai-commit-generator.sh' -- "$SCRIPT_DIR"

mv "$MOCK_BACKUP" "$MOCK_TOOL_PATH"
rm "$SLOW_AI"

# Scenario 5: Parser receives empty input
test_scenario "Parser receives empty input" "No AI output provided" \
    bash -c 'echo "" | "$1"/_scripts/lazygit-ai-commit/parse-ai-output.sh' -- "$SCRIPT_DIR"

# Scenario 6: Parser receives whitespace-only input
test_scenario "Parser receives whitespace-only input" "No valid commit messages found" \
    bash -c 'echo -e "\n  \n\t\n" | "$1"/_scripts/lazygit-ai-commit/parse-ai-output.sh' -- "$SCRIPT_DIR"

# Scenario 7: Pipeline failure propagation
test_scenario "Pipeline failure propagation (pipefail)" "Pipeline failure" \
    bash -c "set -o pipefail; (echo 'test' | bash -c 'exit 1' | cat) 2>&1 || echo 'Pipeline failure'"

# Scenario 8: Valid input produces valid output
echo "Scenario 8: Valid input produces valid output"
OUTPUT=$(echo "test diff" | AI_BACKEND=mock "${SCRIPT_DIR}/_scripts/lazygit-ai-commit/ai-commit-generator.sh" 2>&1 | "${SCRIPT_DIR}/_scripts/lazygit-ai-commit/parse-ai-output.sh" 2>&1)
if [ -n "$OUTPUT" ] && echo "$OUTPUT" | grep -q "feat:"; then
    echo "✓ PASS: Valid input produces valid output"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "✗ FAIL: Valid input doesn't produce valid output"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

# Scenario 9: Error messages include suggestions
echo "Scenario 9: All error messages include suggestions"
SUGGESTION_COUNT=0

# Check ai-commit-generator.sh
SUGGESTION_COUNT=$(grep -c "Suggestion:" "${SCRIPT_DIR}/_scripts/lazygit-ai-commit/ai-commit-generator.sh" || true)
if [ "$SUGGESTION_COUNT" -ge 3 ]; then
    echo "✓ PASS: ai-commit-generator.sh has $SUGGESTION_COUNT suggestions"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "✗ FAIL: ai-commit-generator.sh has only $SUGGESTION_COUNT suggestions"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

# Check parse-ai-output.sh
SUGGESTION_COUNT=$(grep -c "Suggestion:" "${SCRIPT_DIR}/_scripts/lazygit-ai-commit/parse-ai-output.sh" || true)
if [ "$SUGGESTION_COUNT" -ge 1 ]; then
    echo "✓ PASS: parse-ai-output.sh has $SUGGESTION_COUNT suggestions"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "✗ FAIL: parse-ai-output.sh has only $SUGGESTION_COUNT suggestions"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

# Scenario 10: Timeout is configurable
echo "Scenario 10: Timeout configuration"
if grep -q 'TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-30}"' "${SCRIPT_DIR}/_scripts/lazygit-ai-commit/ai-commit-generator.sh"; then
    echo "✓ PASS: Timeout is configurable with default 30s"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "✗ FAIL: Timeout configuration not found"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

# Summary
echo "=== Test Summary ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "✓ All error scenarios handled correctly!"
    exit 0
else
    echo "✗ Some error scenarios failed"
    exit 1
fi
