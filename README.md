# Githooks
As per Epic [DPDS-11](https://dat.jeppesen.com/jira/browse/DPDS-11), this aims to set up some githooks to help dev workflow.

Sample Java project with sample Terraform files were built just to mimic initial work. 

Hooks are available under scripts/hooks. They need to be shared for each teammember to put inside their personal .git/hooks directory. It is possible to enforce their usage through Gradle installation (TBD). A testing suite has been provided for the hooks under scripts/tests.

Skip hooks by using either `-n` or `--no-verify` when running `git`.

These scripts were made to run on Bash >=4.0. Installation instructions are available here: [**Installation**](#installation).

## Table Of Contents
 - [Todos](#todos)
 - [Requirements](#requirements)
 - [Installation](#installation)
 - [Quick Setup](#quick-setup)
 - [Pre-push Hook](#pre-push-hook)
 - [Pre-commit-message Hook](#pre-commit-message-hook)
 - [Pre-commit Hook](#pre-commit-hook)
 - [Testing suite](#testing-suite)  

## TODOs

- [x] change pre-push tf fmt to move on if `/terraform/` dir not found
- [ ] look into git hooks repo for use with gradle build enforcement
- [X] look into stylesheet ticket
- [X] terraform will have a lot of folders/modules... adapt script to that and make testing more robust to ensure no hiccups
- [ ] more robust testing for pre-push-naming, pre-push, and prepare-commit-msg
- [ ] research how to automatically checkout hooks repo for enforcing implementation(may need to look into relative pathing)
- [X] Readme.md clean up and split, individual testing readmes
- [X] Installer with bash updates and usage
- [X] add something that stops hooks if shell under 4.0
- [ ] change emails in Readme Notes to match Jepp emails

## Requirements

To run these hooks and tests, you’ll need the following:

1. **Git**
   - Version: `git ≥ 2.20`
   - Needed for `git init`, `git checkout -b`, `git rev-parse`, etc.

2. **Bash**
   - Version: `bash ≥ 4.0`
   - The hooks use regex matching (`=~`) and `BASH_REMATCH`, which are not supported in Bash 3.x.  
   - **macOS note**: older macOS ships with Bash 3.2. Install Bash 4+ via [Homebrew](https://brew.sh/):
     ```bash
     brew install bash
     chsh -s /usr/local/bin/bash
     ```

3. **POSIX utilities**
   - Required: `mktemp`, `rm`, `cp`, `cd`, `cat`, `echo`, `sed`, `grep`  
   - These are included by default on Linux and macOS.  
   - On Windows, they come with **Git Bash**.

4. **Cross-platform support**
   - **Linux**: Works out of the box.  
   - **macOS**: Works if Bash ≥ 4.0 is installed.  
   - **Windows**: Requires **Git Bash** or **WSL**. (Native CMD/PowerShell not supported.)

5. **Optional Environment Variables**
   - `HOOK_DEBUG=1` → enables verbose debug logging during test runs.  
   - `HOOK_FORCE=1` → bypasses branch validation checks (for local testing only).

6. **Terraform**
   - Terraform CLI must be installed and available in your `PATH`.  
   - Verify with:
     ```bash
     terraform -version
     ```

## Installation

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd githooks
   ```

2. **Install dependencies**

   - **macOS**
     ```bash
     brew install bash git terraform
     ```

   - **Linux (Debian/Ubuntu)**
     ```bash
     sudo apt update
     sudo apt install git bash terraform
     ```

   - **Windows**
     - Install [Git for Windows](https://git-scm.com/download/win) (includes Git Bash).
     - Install [Terraform](https://developer.hashicorp.com/terraform/downloads).
     - Ensure both `git` and `terraform` are available in your `PATH`.

4. **Verify installation**
   ```bash
   git --version
   bash --version
   terraform -version
   ```
   You should see versions listed without errors.

## Quick Setup

Clone repo and run:

```bash
# Make hooks + test runners executable
chmod +x hooks/prepare-commit-msg
chmod +x hooks/pre-push-naming
chmod +x hooks/pre-push-tf
chmod +x hooks/pre-commit
chmod +x hooks/pre-push

chmod +x tests/test-prepare-commit-msg/test-message
chmod +x tests/test-pre-push-naming/test-naming
chmod +x tests/test-pre-push-tf/test-validate
chmod +x tests/test-pre-commit/test-fmt
chmod +x tests/test-pre-push/test-validate-naming
```

## Pre-push Hook

This hook attempts to address the following needs:

- ensure `terraform validate` can be run without errors if files inside /terraform/ were modified [(DPDS-19)](https://dat.jeppesen.com/jira/browse/DPDS-19)
- ensure push is denied if message if branch name does not meet validation criteria [(DPDS-20)](https://dat.jeppesen.com/jira/browse/DPDS-20)

Specific validation criteria can be found in the links above. Preliminarily built separatedly (with `pre-push-tf` and `pre-push-naming`). Naming checks done before Terraform checks.

## Pre-commit-message Hook

This hook attempts to address the following need:
- Pre-pen ticket number/branch name into message [(DPDS-17)](https://dat.jeppesen.com/jira/browse/DPDS-17)

Specific validation criteria can be found in the link above.

The git message should be built as follows:

>    Title: Summary, imperative, start upper case, don't end with a period 
>    No more than 50 chars. #### 50 chars is here:  
>    Remember blank line between title and body.  
>    Body: Explain *what* and *why* (not *how*). Include task ID (Jira issue).  
>    Wrap at 72 chars. ################################## which is here:  #  
>    Special instructions, testing steps, rake, etc. 
>    At the end: Include Co-authored-by for all contributors.  
>    Include at least one empty line before it. Format:  
>    Co-authored-by: name <user@users.noreply.github.com>  

## Pre-commit Hook

This hook attempts to address the following needs:

- ensure `terraform fmt` can be run without errors if files inside /terraform/ were modified [(DPDS-18)](https://dat.jeppesen.com/jira/browse/DPDS-18)

Specific validation criteria can be found in the link above.

## Testing Suite

This repository includes a suite of automated tests for all Git hooks.  
Each test runs in an isolated temporary Git repository to avoid cross-contamination.  

Available test suites:  

- **test-pre-commit** → validates the pre-commit terraform formatting hook  
- **test-prepare-commit-msg** → validates automatic ticket prefixing in commit messages  
- **test-pre-push** → validates pre-push behavior as a whole  
- **test-pre-push-naming** → validates branch naming conventions  
- **test-pre-push-tf** → validates Terraform-validation pre-push check  

Each test folder contains its own **README.md** with detailed setup, scenarios, and validation criteria.  

## **Author**

Maintained and created by: Isabella Fernandes <isa.fernandes2003@gmail.com>.    
Co-authored by: Ben Rhine <user@users.noreply.github.com> (TODO)