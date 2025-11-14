---
description: Execute all tasks for a sprint with parallel execution and synthesis
argument-hint: [sprint-number]
allowed-tools: Task, Read, Write, TodoWrite, Bash
---

# Execute Complete Sprint

You are executing the `/execute-sprint` command to run all 6 tasks for a sprint.

## Purpose

Execute all 6 tasks for a sprint with parallel execution of Tasks 01-05, followed by sequential execution of Task 06 (synthesis), ensuring efficient research completion while maintaining quality.

## Steps to Execute

### Step 1: Validate Sprint

Check $1 is valid sprint number 01-99
Verify sprint directory exists: sprints/$1-*/
Verify all 6 task files present
Confirm temp directory ready: temp/$1-*/
Validate context files populated

### Step 2: Load Configuration

Read config/project-config.yml for max_parallel_tasks, git_enabled settings
Read config/sprint-config.yml for sprint metadata
Read all context files for skill agents

### Step 3: Initialize Progress Tracking

Create progress tracking list with 6 tasks:
- Task 01: Technical Requirements Research
- Task 02: Market & Competitive Analysis
- Task 03: Solution Architecture Design
- Task 04: Certification Pathway Analysis
- Task 05: Implementation Roadmap
- Task 06: Final Report Synthesis
Mark all as pending initially

### Step 4: Execute Tasks 01-05 in Parallel

Launch 5 skill agents concurrently using Task tool:
- Task tool → technical-researcher (Task 01)
- Task tool → market-analyst (Task 02)
- Task tool → solution-architect (Task 03)
- Task tool → compliance-analyst (Task 04)
- Task tool → roadmap-planner (Task 05)

Each agent operates independently, creating research files in temp/$1-*/

### Step 5: Monitor Parallel Execution

Track completion of each skill agent
Update progress tracking as each task completes
Collect file counts and word counts
Handle any errors gracefully

### Step 6: Execute Task 06 (Synthesis)

Wait for all Tasks 01-05 to complete
Mark Task 06 as in_progress
Launch Task tool → report-synthesizer
Report synthesizer reads all temp/$1-*/ files
Applies scoring rubric from config/scoring-rubric.yml
Generates comprehensive strategic report (5,000-7,500 words)
Writes to reports/$1-*-report.md

### Step 7: Validate Sprint Completion

Check all 6 tasks completed successfully
Verify research file count meets minimum (25+ files typical)
Ensure final report exists and meets length requirement
Confirm report includes go/no-go recommendation
Validate scoring completed

### Step 8: Git Workflow

If git_enabled in config:
- Create feature branch: git flow feature start sprint-$1-execution
- Stage all generated files: git add temp/$1-*/ reports/$1-*.md
- Commit with descriptive message
- Finish feature: git flow feature finish sprint-$1-execution
- Push to remote: git push origin develop

### Step 9: Generate Sprint Summary

List all files created with statistics
Provide key findings from report
Show opportunity score and recommendation
Display execution metrics (time, file count, word count)

### Step 10: Update Configuration

Update sprint status in config/sprint-config.yml to "completed"

## Success Criteria

- All 6 tasks completed successfully
- Minimum 25 research files created
- Final report exists (5,000-7,500 words)
- Opportunity score calculated (0-100)
- Go/no-go recommendation provided
- Git commits created (if enabled)

## Error Handling

If sprint not found, guide user to run /create-sprint
If prerequisites missing, specify what's needed
If task execution fails, provide diagnostic info and recovery options

## Expected Output

User receives comprehensive sprint summary with file statistics, opportunity score, recommendation, and next steps.
