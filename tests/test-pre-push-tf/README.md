# Pre-push-tf Hook Tests


This suite tests the **Terraform validation pre-push hook** to ensure it behaves correctly in different scenarios.  This is modular testing for the final pre-push hook.
This is part of the Digital Data Delivery team's efforts to automate developer workflow. Specific validation criteria found in [DPDS-19](https://dat.jeppesen.com/jira/browse/DPDS-19).  
Each test spins up a temporary Git repository, installs the hook, and simulates a `git push`.

---

## Directory Structure

```
tests/test-pre-push-tf/
├── test-validate             # Main test runner script
├── test-data/
│   ├── valid/                # Valid Terraform configuration
│   │   ├── main.tf           # Root Terraform file
│   │   └── modules/
│   │       ├── provider/
│   │       └── vpc/        
│   ├── invalid-validate/     # Invalid Terraform config (fails validation)
│   ├── deleted/              # Deleted Terraform files
│   └── non-tf/               # Non-Terraform files
└── README.md                 # This documentation

```

## Tests

1. **Valid Terraform config**  
   - Adds well-formed `.tf` files.  
   - Hook runs `terraform init -backend=false` and `terraform validate`.  
   - Validation passes → push succeeds.  

2. **Invalid Terraform config**  
   - Adds `.tf` files with validation errors.  
   - `terraform validate` fails → push is blocked.  

3. **Deleted Terraform files**  
   - Adds `.tf` files and commits. Deletes them and commits again.  
   - Hook skips deleted `.tf` → push succeeds.  

4. **Non-Terraform files**  
   - Adds non-Terraform files.  
   - Hook detects no `.tf` files changed → push succeeds.  

5. **Bash < 4.0**  
   - Simulates running the hook with an old Bash version.  
   - Hook prints a warning and skips validation → push succeeds.  

---

## Running the Tests

```bash
chmod +x hooks/pre-push
chmod +x tests/test-pre-push-tf/test-validate
./tests/test-pre-push-tf/test-validate
```

All tests should pass if hook running correctly. 

## Notes

- Each test is isolated: the temp repo is reset between tests to avoid cross-contamination.
- If you add new test scenarios, place their input under `test-data/<scenario-name>/`.

For issues or enhancements, reach out to Isabella Fernandes <isa.fernandes2003@gmail.com>.  