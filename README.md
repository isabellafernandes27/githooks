# sample-project-githooks
As per Epic [DDDS-11](https://dat.jeppesen.com/jira/browse/DDDS-11), this aims to set up some githooks to help dev workflow.

Sample Java project with sample Terraform files were built just to mimic initial work. 

Hooks are available under scripts/hooks. They need to be shared for each teammember to put inside their personal .git/hooks directory. It is possible to enforce their usage through Gradle installation (TBD).

Skip hooks by using either `-n` or `--no-verify`.


## Pre-push Hook

This hook attempts to address the following needs:
    - ensure `terraform fmt` can be run without errors if files inside /terraform/ were modified [DDDS-18](https://dat.jeppesen.com/jira/browse/DDDS-18)
    - ensure `terraform validate` can be run without errors if files inside /terraform/ were modified [DDDS-19](https://dat.jeppesen.com/jira/browse/DDDS-19)
    - ensure push is denied if message if branch name does not meet validation criteria [DDDS-20](https://dat.jeppesen.com/jira/browse/DDDS-20)

## Pre-commit-message Hook

This hook attempts to address the following need:
    - Pre-pen ticket number/branch name into message [DDDS-17](https://dat.jeppesen.com/jira/browse/DDDS-17)

The git message should be built as follows:
```
{
Title: Summary, imperative, start upper case, don't end with a period
No more than 50 chars. #### 50 chars is here:  #
Remember blank line between title and body.
Body: Explain *what* and *why* (not *how*). Include task ID (Jira issue).
Wrap at 72 chars. ################################## which is here:  #
Special instructions, testing steps, rake, etc
At the end: Include Co-authored-by for all contributors.
Include at least one empty line before it. Format:
Co-authored-by: name <user@users.noreply.github.com>
```
}