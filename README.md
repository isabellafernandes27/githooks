# sample-project-githooks
As per Epic [DDDS-11](https://dat.jeppesen.com/jira/browse/DDDS-11), this aims to set up some githooks to help dev workflow.

Sample Java project with sample Terraform files were built just to mimic initial work. 

Hooks are available under scripts/hooks. They need to be shared for each teammember to put inside their personal .git/hooks directory. It is possible to enforce their usage through Gradle installation (TBD). A testing suite has been provided for the hooks under scripts/tests.

Skip hooks by using either `-n` or `--no-verify`.

## TODOs

- [X] Get `test-pre-push-tf`s to pass (need to change logic on `pre-push-tf`). Consider testing them in the same suite.
- [ ] Put all `pre-push` scripts together and test if functionality still intact. Original unit tests should still work. 
- [ ] Create new unit tests for the full `pre-push` script to test integrated functionality.

## Pre-push Hook

This hook attempts to address the following needs:

- ensure `terraform fmt` can be run without errors if files inside /terraform/ were modified [(DDDS-18)](https://dat.jeppesen.com/jira/browse/DDDS-18)
- ensure `terraform validate` can be run without errors if files inside /terraform/ were modified [(DDDS-19)](https://dat.jeppesen.com/jira/browse/DDDS-19)
- ensure push is denied if message if branch name does not meet validation criteria [(DDDS-20)](https://dat.jeppesen.com/jira/browse/DDDS-20)

Specific validation criteria can be found in the links above. Preliminarily built separatedly (with `pre-push-tf` and `pre-push-naming`).

## Pre-commit-message Hook

This hook attempts to address the following need:
- Pre-pen ticket number/branch name into message [(DDDS-17)](https://dat.jeppesen.com/jira/browse/DDDS-17)

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


## Testing Suite

Assumes your pre-push hook is located at `scripts/hooks/pre-push`, AND you have terraform installed and available in your `PATH`, AND the test script is run on macOS or Linux with `bash/sh`.

Testing suite was made with the detailed given-when-then validation criteria from each ticket mentioned above.

Before running these make sure the scripts are executable by running the below commands:

```bash
chmod +x scripts/hooks/pre-push-naming
chmod +x scripts/hooks/pre-push-tf
chmod +x scripts/hooks/prepare-commit-msg
```

### test-pre-push-tf-fmt

- Creates a temporary Git repo.
- Copies the pre-push-tf hook into `.git/hooks/.`
- Creates and commits files under `/terraform/` and outside `/terraform/.`
- Modifies files to simulate the three scenarios:
    1. Modified `/terraform/` files with formatting issues that terraform fmt can fix automatically.
    2. Modified files outside `/terraform/.`
    3. Modified `/terraform/` files with formatting issues that terraform fmt cannot fix automatically (simulated by making a file that terraform fmt won't fix). 
- Attempts to push (simulates by invoking the hook directly).
- Checks the hook behavior matches the validation criteria.

#### Running it:
Make sure you run these in the root dir:
1. Run `chmod +x scripts/hooks/tests/test-pre-push-tf-fmt` to make file executable
2. Run `./scripts/hooks/tests/test-pre-push-tf-fmt` to run tests
3. Test conclusions should display in terminal

### test-pre-push-tf-validate

- Creates a temporary Git repo.
- Copies the pre-push-tf hook into `.git/hooks/.`
- Creates and commits files under `/terraform/` and outside `/terraform/.`
- Modifies files to simulate the two scenarios:
    1. Valid.tf file
    2. Invalid .tf file 
- Attempts to push (simulates by invoking the hook directly).
- Checks the hook behavior matches the validation criteria.

#### Running it:
Make sure you run these in the root dir:
1. Run `chmod +x scripts/hooks/tests/test-pre-push-tf-validate` to make file executable
2. Run `./scripts/hooks/tests/test-pre-push-tf-validate` to run tests
3. Test conclusions should display in terminal

### test-pre-push-naming

- Creates a temporary Git repo.
- Copies the pre-push-naming hook into `.git/hooks/.`
- Defines protected branches (`master`, `production`, and `staging`)
- Defines and checks out different branches to see if `push` will be allowed:
    1. Pushing from a protected branch like `main`, `master`, `production`.
    2. Valid branch examples:
        - `feature/IDDS-1234`
        - `hotfix/IDDS-4567-suffix`
        - `IDDS-7890`
    3. Invalid branch examples:
        - `dev/idds-0001` (lowercase prefix)
        - `feature/IDDS-abc` (non-numeric)
        - `idds-5678` (lowercase Jira ID)

#### Running it:
Make sure you run these in the root dir:
1. Run `chmod +x scripts/hooks/tests/test-pre-push-naming` to make file executable
2. Run `./scripts/hooks/tests/test-pre-push-naming` to run tests
3. Test conclusions should display in terminal

### test-prepare-commit-msg

- Creates a temporary Git repo.
- Copies the prepare-commit-msg hook into `.git/hooks/.`
- Runs multiple tests by creating branches with and without Jira ticket IDs and making commits:
    1. Message without ticket number 
        - branch: "DDDS-123-add-login", initial message: "Implement login handler", final message: "DDDS-123: Implement login handler"
    2. Message with ticket number
        - branch: "DDDS-321-existing", initial message: "DDDS-321: Fix bug", final message: "DDDS-321: Fix bug"
    2. Message and branch with no ticket pattern (leaves it unchanged).
- Checks whether the commit message is automatically updated to start with `<TICKET-ID>: <message>`

#### Running it:
Make sure you run these in the root dir:
1. Run `chmod +x scripts/hooks/tests/test-prepare-commit-msg` to make file executable
2. Run `.scripts/hooks/tests/test-prepare-commit-msg` to run tests
3. Test conclusions should display in terminal