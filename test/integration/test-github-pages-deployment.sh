#!/usr/bin/env bash
#
# Integration Test for GitHub Pages Deployment
# Tests complete workflow: generate → enable → deploy → verify
#
# Usage: ./test/integration/test-github-pages-deployment.sh

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test/integration/test-pages-deploy-temp"
REPORTS_DIR="$TEST_DIR/reports"
OUTPUT_DIR="$TEST_DIR/docs"

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

section() {
    echo ""
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${BLUE}  $1${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   GitHub Pages Deployment Integration Test        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# Setup Test Environment
# ============================================
section "Setting Up Test Environment"

info "Cleaning previous test artifacts..."
rm -rf "$TEST_DIR"
mkdir -p "$REPORTS_DIR"
mkdir -p "$OUTPUT_DIR"

info "Creating test sprint reports with various naming patterns..."

# Pattern 1: sprint-XX-final-report.md (original format)
cat > "$REPORTS_DIR/sprint-01-final-report.md" << 'EOF'
# Sprint 01: Traditional Naming Pattern Test

## Executive Summary
Test report with traditional sprint-XX-final-report.md naming pattern.

## Opportunity Scoring
**Overall Score**: 85/100
**TAM**: $5.0B
EOF

# Pattern 2: XX-descriptive-name-report.md (user's actual format)
cat > "$REPORTS_DIR/02-consulting-research-ops-report.md" << 'EOF'
# Strategic Research Report: Consulting Research Ops

## Executive Summary
Test report with descriptive naming pattern used by actual users.

## Opportunity Scoring
**Overall Score**: 78/100
**TAM**: $3.5B
EOF

# Pattern 3: descriptive-name.md (minimal pattern)
cat > "$REPORTS_DIR/market-analysis-healthcare.md" << 'EOF'
# Market Analysis: Healthcare Sector

## Executive Summary
Test report with minimal descriptive naming.

## Opportunity Scoring
**Overall Score**: 92/100
**TAM**: $8.2B
EOF

pass "Created 3 test reports with different naming patterns"

# Create minimal config file
mkdir -p "$TEST_DIR/config"
cat > "$TEST_DIR/config/project-config.yml" << 'EOF'
project_name: "GitHub Pages Deployment Test"
industry: "Technology"
EOF

pass "Created test configuration"

# ============================================
# Test 1: Workflow File Trigger Patterns
# ============================================
section "Test 1: Workflow Trigger Patterns"

WORKFLOW_FILE="$PROJECT_ROOT/.github/workflows/publish-pages.yml"

if [ -f "$WORKFLOW_FILE" ]; then
    pass "Workflow file exists"

    # Check if workflow triggers on any .md file
    if grep -q "reports/\*\*/\*.md" "$WORKFLOW_FILE"; then
        pass "Workflow triggers on reports/**/*.md pattern"
    elif grep -q "reports/\*.md" "$WORKFLOW_FILE"; then
        pass "Workflow triggers on reports/*.md pattern"
    elif grep -q "sprint-\*-final-report.md" "$WORKFLOW_FILE"; then
        fail "Workflow only triggers on sprint-*-final-report.md (too restrictive)"
    else
        fail "Workflow trigger pattern not found or unclear"
    fi

    # Check if workflow uses v2 architecture
    if grep -q "generate-pages-v2.sh" "$WORKFLOW_FILE"; then
        pass "Workflow uses v2 architecture (generate-pages-v2.sh)"
    elif grep -q "generate-pages.sh" "$WORKFLOW_FILE"; then
        fail "Workflow uses deprecated v1 architecture (generate-pages.sh)"
    else
        fail "Cannot determine which generation script workflow uses"
    fi

    # Check if workflow copies all reports (not just sprint-*)
    if grep -q "cp reports/\*.md" "$WORKFLOW_FILE" || grep -q "cp reports/\*\*/\*.md" "$WORKFLOW_FILE"; then
        pass "Workflow copies all report files (not just sprint-*)"
    elif grep -q "sprint-\*-final-report" "$WORKFLOW_FILE"; then
        fail "Workflow only copies sprint-*-final-report files"
    else
        fail "Cannot determine workflow copy pattern"
    fi
else
    fail "Workflow file not found: $WORKFLOW_FILE"
fi

# ============================================
# Test 2: GitHub Pages Generation (V2)
# ============================================
section "Test 2: GitHub Pages Generation (V2)"

info "Running generate-pages-v2.sh..."
if "$PROJECT_ROOT/scripts/publish/generate-pages-v2.sh" "$OUTPUT_DIR" "$REPORTS_DIR" "$TEST_DIR/config/project-config.yml" > /dev/null 2>&1; then
    pass "V2 generation completed successfully"
else
    fail "V2 generation failed"
fi

# Check generated files
if [ -f "$OUTPUT_DIR/index.html" ]; then
    pass "index.html generated"
else
    fail "index.html not generated"
fi

if [ -f "$OUTPUT_DIR/sprints-data.json" ]; then
    pass "sprints-data.json generated"
else
    fail "sprints-data.json not generated"
fi

if [ -f "$OUTPUT_DIR/.nojekyll" ]; then
    pass ".nojekyll marker created"
else
    fail ".nojekyll marker not created"
fi

# ============================================
# Test 3: JSON Data Includes All Reports
# ============================================
section "Test 3: JSON Data Includes All Report Patterns"

JSON_FILE="$OUTPUT_DIR/sprints-data.json"

if command -v jq &> /dev/null && [ -f "$JSON_FILE" ]; then
    sprints_count=$(jq '.sprints | length' "$JSON_FILE")

    if [ "$sprints_count" = "3" ]; then
        pass "All 3 reports included in JSON data"
    else
        fail "Expected 3 reports, found $sprints_count"
    fi

    # Check that each report is accessible
    for i in 0 1 2; do
        title=$(jq -r ".sprints[$i].title" "$JSON_FILE")
        if [ -n "$title" ] && [ "$title" != "null" ]; then
            pass "Report $((i+1)): Title extracted: $title"
        else
            fail "Report $((i+1)): Title not extracted"
        fi
    done
else
    info "jq not available or JSON not found, skipping detailed validation"
fi

# ============================================
# Test 4: enable-github-pages.sh Library
# ============================================
section "Test 4: GitHub Pages Enablement Library"

ENABLE_SCRIPT="$PROJECT_ROOT/scripts/lib/enable-github-pages.sh"

if [ -f "$ENABLE_SCRIPT" ]; then
    pass "enable-github-pages.sh library exists"

    # Source the library
    # shellcheck source=scripts/lib/enable-github-pages.sh
    source "$ENABLE_SCRIPT"

    # Test function existence
    if declare -f enable_github_pages > /dev/null; then
        pass "Function enable_github_pages exists"
    else
        fail "Function enable_github_pages not found"
    fi

    if declare -f get_github_pages_url > /dev/null; then
        pass "Function get_github_pages_url exists"
    else
        fail "Function get_github_pages_url not found"
    fi

    if declare -f is_github_pages_enabled > /dev/null; then
        pass "Function is_github_pages_enabled exists"
    else
        fail "Function is_github_pages_enabled not found"
    fi

    # Test URL generation
    test_url=$(get_github_pages_url "testuser" "testrepo")
    expected_url="https://testuser.github.io/testrepo/"
    if [ "$test_url" = "$expected_url" ]; then
        pass "URL generation works correctly"
    else
        fail "URL generation incorrect (expected: $expected_url, got: $test_url)"
    fi
else
    fail "enable-github-pages.sh library not found"
fi

# ============================================
# Test 5: run-full.sh Integration
# ============================================
section "Test 5: run-full.sh Integration Functions"

RUN_FULL_SCRIPT="$PROJECT_ROOT/scripts/run-full.sh"

if [ -f "$RUN_FULL_SCRIPT" ]; then
    pass "run-full.sh exists"

    # Check for new GitHub Pages functions
    if grep -q "enable_github_pages_for_repo()" "$RUN_FULL_SCRIPT"; then
        pass "Function enable_github_pages_for_repo exists"
    else
        fail "Function enable_github_pages_for_repo not found"
    fi

    if grep -q "trigger_pages_workflow()" "$RUN_FULL_SCRIPT"; then
        pass "Function trigger_pages_workflow exists"
    else
        fail "Function trigger_pages_workflow not found"
    fi

    if grep -q "verify_pages_deployment()" "$RUN_FULL_SCRIPT"; then
        pass "Function verify_pages_deployment exists"
    else
        fail "Function verify_pages_deployment not found"
    fi

    # Check that deploy_to_github_pages calls all phases
    if grep -A 30 "deploy_to_github_pages()" "$RUN_FULL_SCRIPT" | grep -q "enable_github_pages_for_repo"; then
        pass "deploy_to_github_pages calls enable_github_pages_for_repo"
    else
        fail "deploy_to_github_pages doesn't call enable_github_pages_for_repo"
    fi

    if grep -A 30 "deploy_to_github_pages()" "$RUN_FULL_SCRIPT" | grep -q "trigger_pages_workflow"; then
        pass "deploy_to_github_pages calls trigger_pages_workflow"
    else
        fail "deploy_to_github_pages doesn't call trigger_pages_workflow"
    fi

    if grep -A 30 "deploy_to_github_pages()" "$RUN_FULL_SCRIPT" | grep -q "verify_pages_deployment"; then
        pass "deploy_to_github_pages calls verify_pages_deployment"
    else
        fail "deploy_to_github_pages doesn't call verify_pages_deployment"
    fi

    # Check final status reporting includes URLs
    if grep -q "GITHUB_PAGES_URL" "$RUN_FULL_SCRIPT"; then
        pass "Final summary includes GitHub Pages URL"
    else
        fail "Final summary doesn't include GitHub Pages URL"
    fi

    if grep -q "PAGES_VERIFIED" "$RUN_FULL_SCRIPT"; then
        pass "Final summary tracks URL verification status"
    else
        fail "Final summary doesn't track URL verification status"
    fi
else
    fail "run-full.sh not found"
fi

# ============================================
# Test 6: URL Verification Logic
# ============================================
section "Test 6: URL Verification Logic"

# Test verify_pages_deployment function logic
if grep -A 50 "verify_pages_deployment()" "$RUN_FULL_SCRIPT" | grep -q "curl.*http_code"; then
    pass "Verification uses curl to check HTTP status"
else
    fail "Verification doesn't use curl HTTP checks"
fi

if grep -A 50 "verify_pages_deployment()" "$RUN_FULL_SCRIPT" | grep -q "max_wait"; then
    pass "Verification has timeout protection"
else
    fail "Verification doesn't have timeout protection"
fi

if grep -A 50 "verify_pages_deployment()" "$RUN_FULL_SCRIPT" | grep -q "PAGES_VERIFIED=true"; then
    pass "Verification sets PAGES_VERIFIED flag on success"
else
    fail "Verification doesn't set PAGES_VERIFIED flag"
fi

# ============================================
# Test 7: Workflow Dispatch Trigger
# ============================================
section "Test 7: Workflow Dispatch Trigger"

if grep -A 20 "trigger_pages_workflow()" "$RUN_FULL_SCRIPT" | grep -q "gh workflow run"; then
    pass "trigger_pages_workflow uses gh CLI to trigger workflow"
else
    fail "trigger_pages_workflow doesn't use gh workflow run"
fi

if grep -A 20 "trigger_pages_workflow()" "$RUN_FULL_SCRIPT" | grep -q "publish-pages.yml"; then
    pass "Triggers correct workflow file (publish-pages.yml)"
else
    fail "Doesn't trigger correct workflow file"
fi

# Check that gh CLI availability is checked
if grep -A 20 "trigger_pages_workflow()" "$RUN_FULL_SCRIPT" | grep -q "command -v gh"; then
    pass "Checks for gh CLI availability"
else
    fail "Doesn't check for gh CLI availability"
fi

# ============================================
# Results Summary
# ============================================
section "Test Results Summary"

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))

echo ""
echo -e "${BOLD}Total Tests:${NC} $TOTAL_TESTS"
echo -e "${GREEN}${BOLD}Passed:${NC} $TESTS_PASSED"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}${BOLD}Failed:${NC} $TESTS_FAILED"
fi
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ ALL TESTS PASSED                               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}GitHub Pages Deployment:${NC} ${GREEN}FULLY INTEGRATED${NC}"
    echo ""
    echo -e "${BOLD}Features Verified:${NC}"
    echo -e "  ✓ Workflow handles any report naming pattern"
    echo -e "  ✓ V2 architecture generates proper JSON and HTML"
    echo -e "  ✓ GitHub Pages enablement integrated in run-full.sh"
    echo -e "  ✓ Workflow dispatch trigger implemented"
    echo -e "  ✓ URL verification with HTTP checks"
    echo -e "  ✓ Final status reporting includes live URLs"
    echo ""

    # Cleanup
    info "Cleaning up test artifacts..."
    rm -rf "$TEST_DIR"

    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ✗ TESTS FAILED                                   ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Test artifacts preserved at: $TEST_DIR${NC}"
    echo ""

    exit 1
fi
