---
description: Execute all sprints in project with parallel orchestration
argument-hint: none
allowed-tools: Task, Read, Write, TodoWrite, Bash
---

# Execute All Sprints

You are executing the `/execute-all` command to run all sprints defined in the project.

## Purpose

Execute all sprints in the project with intelligent parallel orchestration, respecting system resources (max_parallel_tasks configuration), followed by cross-sprint comparative analysis.

## Steps to Execute

### Step 1: Load Configuration

Read config/project-config.yml for:
- max_parallel_tasks (default: 8)
- git_enabled setting
- quality standards

Read config/sprint-config.yml to:
- Count total sprints
- Extract sprint definitions
- Verify all sprint directories exist

### Step 2: Validate Setup

Check:
- All sprint directories exist (sprints/XX-*/)
- Context files populated (client-info.md, company-profile.md)
- temp/ and reports/ directories ready

If validation fails, guide user to complete setup.

### Step 3: Create Comprehensive Progress Tracking

Calculate total tasks: N sprints × 6 tasks per sprint

Example for 10 sprints:
- Sprint 01: 6 tasks (pending)
- Sprint 02: 6 tasks (pending)
- ...
- Sprint 10: 6 tasks (pending)
- Total: 60 tasks

Initialize all as pending status.

### Step 4: Invoke Sprint Executor for Each Sprint

Use Task tool to invoke sprint-executor skill with context:
"Execute all sprints defined in config/sprint-config.yml with max parallelism"

Sprint executor manages:
- Parallel sprint launching (up to max_parallel_tasks sprints)
- Wave-based execution (start new sprints as others complete)
- Progress tracking and status updates
- Error handling and recovery

Example execution flow for 10 sprints, max_parallel=8:
```
Wave 1: Launch sprints 01-08 simultaneously
Wait for any to complete...
Sprint 03 completes → Launch sprint 09
Sprint 01 completes → Launch sprint 10
Continue until all complete
```

### Step 5: Monitor Overall Progress

Track completion across all sprints
Update progress tracking as tasks and sprints complete
Display periodic progress updates (every 30 seconds)

Example progress output:
```
[12:05:30] Overall Progress: 28% (17/60 tasks complete)
           Sprint 01: 71% complete
           Sprint 02: 57% complete
           Sprint 03: 14% complete
```

### Step 6: Cross-Sprint Comparative Analysis

After all sprints complete, invoke comparative-analyzer skill:
- Read all sprint reports from reports/
- Extract scores and key metrics
- Rank opportunities by composite score
- Identify strategic patterns and synergies
- Generate prioritization matrix

### Step 7: Generate Project Summary

Create comprehensive summary with:
- Total sprints executed
- Total files created
- Total research output (word count)
- Top 3 recommended opportunities
- Aggregate metrics (total TAM, average scores)
- Strategic roadmap (Phase 1, 2, 3 priorities)

### Step 8: Git Release

If git_enabled in config:
```bash
git flow release start v1.0-complete
git add temp/ reports/ config/
git commit -m "Complete: All sprint executions and comparative analysis

Sprints Executed: N
Total Research Files: [count]
Total Reports: N
Top Opportunity: [Sprint XX] - Score: YY/100"
git flow release finish -m "Strategic Research Complete - v1.0" v1.0-complete
git push origin master --tags
git push origin develop
```

### Step 9: Output Completion Report

Display final summary:
```
✅ ALL SPRINTS EXECUTED SUCCESSFULLY

📊 Project Statistics:
   Sprints: N completed
   Research Files: [count] total
   Total Words: YYY,YYY
   Execution Time: HH:MM

🎯 Top 3 Opportunities (by score):
   1. Sprint XX: [Name] - Score: YY/100 (STRONG GO)
   2. Sprint YY: [Name] - Score: ZZ/100 (GO)
   3. Sprint ZZ: [Name] - Score: AA/100 (GO)

📈 Aggregate Market Opportunity:
   Total TAM: $XXB across all opportunities
   Total SAM: $YYB
   Strategic Focus: [Key themes]

🚀 Recommended Execution Phasing:
   Phase 1 (0-6 months): Sprints XX, YY
   Phase 2 (6-12 months): Sprints ZZ, AA
   Phase 3 (12-24 months): Remaining sprints

📄 Deliverables Created:
   ✓ reports/00-cross-sprint-analysis.md
   ✓ N sprint reports in reports/
   ✓ Git release: v1.0-complete

🎉 Strategic research project complete!

Next Steps:
1. Review cross-sprint analysis: reports/00-cross-sprint-analysis.md
2. Review top opportunity reports
3. Export key findings: /export-findings [sprint-num] pdf
4. Present to stakeholders
```

## Success Criteria

- All N sprints executed successfully
- Each sprint has 25+ research files
- Each sprint has final report (5,000-7,500 words)
- Cross-sprint analysis created
- Git release created (if enabled)
- All quality standards met

## Error Handling

If no sprints defined:
```
ERROR: No sprints defined in config/sprint-config.yml

Create sprints first:
- Option 1: /discover-opportunities (auto-generate)
- Option 2: /create-sprint 01 "Name" "Description" (manual)
```

If sprint execution fails:
```
ERROR: Sprint [XX] execution failed

Details: [Error message]

Options:
1. Review and fix sprint [XX] definition
2. Re-execute failed sprint: /execute-sprint [XX]
3. Continue with remaining sprints (skip failed)

Partial results saved. Review temp/[XX]-*/ for diagnostics.
```

## Expected Output

User receives comprehensive project completion summary with statistics, top opportunities, strategic roadmap, and deliverables confirmation.

Execution time: 2-4 hours for 10 sprints (with 8-core parallelism).
