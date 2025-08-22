# Pre-commit Hook Tests

This suite tests the **Terraform formatting pre-commit hook** to ensure it behaves correctly in different scenarios.  
This is a part of the Digital Data Delivery's team efforts to automate developer workflow. Specific validation criteria found in [DPDS-18](https://dat.jeppesen.com/jira/browse/DPDS-18).  
Each test spins up a temporary Git repository, installs the hook, and commits test data.

---

## Directory Structure
```
tests/test-pre-commit/
├── test-fmt              # Main test runner script
├── test-data/s
│   ├── valid/            # Valid Terraform files
│   ├── invalid-format/   # Files with bad formatting
│   ├── invalid-unfixable/ # Unfixable Terraform files
│   └── non-tf/           # Non-Terraform files
└── README.md             # This documentation
```

## Tests

1. **Valid Terraform files**  
   - Adds well-formatted `.tf` files.  
   - Hook runs `terraform fmt` and passes.  

2. **Invalid Terraform formatting**  
   - Adds `.tf` files with incorrect formatting.  
   - Hook auto-runs `terraform fmt`, re-stages changes, and commit succeeds.  

3. **Unfixable invalid Terraform config**  
   - Adds `.tf` files with syntax errors.  
   - `terraform fmt` fails → commit is blocked.  

4. **Non-Terraform files**  
   - Adds documentation files.  
   - Hook detects no `.tf` staged and skips formatting.  


## Running the Tests

```bash
chmod +x hooks/pre-commit
chmod +x tests/test-pre-commit/test-fmt
./tests/test-pre-commit/test-fmt
```

All tests should pass if hook running correctly. If you encounter any issues, reach out to Isabella Fernandes <isa.fernandes2003@gmail.com>. (**TODO**: change when cloning repo).

## Notes

- Each test is isolated: the temp repo is reset between tests to avoid cross-contamination.
- If you add new test scenarios, place their input under `test-data/<scenario-name>/`.