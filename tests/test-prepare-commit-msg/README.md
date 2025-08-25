# Prepare-commit-msg Hook Tests

This suite tests the **prepare-commit-msg hook** to ensure it behaves correctly in different scenarios.  
It is part of the Digital Data Delivery team's efforts to automate developer workflow.  
Validation criteria defined in [DDDS-17](https://dat.jeppesen.com/jira/browse/DDDS-17).

Each test spins up a temporary Git repository, installs the hook, and simulates a commit with messages specified in `test-data/test-commit-messages.txt`.

## Directory Structure
```
tests/test-prepare-commit-msg/
├── test-message            # Main test runner
├── test-data/
│   └── test-commit-messages.txt
└── README.md               # This file
```

## Tests

**Commit message validation** is driven by branch names containing Jira-style tickets (e.g., `DDDS-123-add-login`).  

### Validation Criteria

1. **Branch contains Jira ticket ID → prepend ticket ID to commit message**  
   - Branch: `DDDS-123-add-login`  
   - Commit message: `Implement login handler`  
   - Result: `DDDS-123: Implement login handler`

2. **Commit message already prefixed → leave unchanged**  
   - Branch: `DDDS-321-existing`  
   - Commit message: `DDDS-321: Fix bug`  
   - Result: `DDDS-321: Fix bug`

3. **Branch has Jira ticket with suffix**  
   - Branch: `feature/DDDS-789-new-ui`  
   - Commit message: `Add new UI module`  
   - Result: `DDDS-789: Add new UI module`

4. **Branch has no Jira ticket → leave commit unchanged**  
   - Branch: `some-random-branch`  
   - Commit message: `No ticket here`  
   - Result: `No ticket here`

5. **Squashes are ignored**  
   - Hook exits without modifying the commit message.

6. **Merges are not ignored**
    -Branch: `DDDS-555-new-feature`
    -Commit message: `Merge branch 'DDDS-555-new-feature' into main`
    -Result: `DDDS-555: Merge branch 'DDDS-555-new-feature' into main`


## Test Data File

`test-commit-messages.txt` defines test cases as:  
```
branch-name|commit-message|expected-message
```

- Blank lines and comments (`#`) are ignored.  
- Expected message is compared against actual commit message to determine **PASS** / **FAIL**.


## Running the Tests

```bash
chmod +x hooks/prepare-commit-msg
chmod +x tests/test-prepare-commit-msg/test-message
./tests/test-prepare-commit-msg/test-message
```
All tests should pass if hook running correctly.

## Notes

- Each test runs in a fresh temporary repository, ensuring no cross-contamination.
- Validation is based on comparing the final commit message with the expected one.
- To add new scenarios, edit test-data/test-commit-messages.txt.

For issues or enhancements, reach out to Isabella Fernandes <isa.fernandes2003@gmail.com>.    