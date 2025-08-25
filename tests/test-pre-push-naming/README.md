# Pre-push-naming Hook Tests

This suite tests the **pre-push-naming hook** to ensure it behaves correctly in different scenarios.  
This is a part of the Digital Data Delivery's team efforts to automate developer workflow. Specific validation criteria found in [DPDS-20](https://dat.jeppesen.com/jira/browse/DPDS-20).  
Each test spins up a temporary Git repository, installs the hook, and simulates a push to a remote branch with names specified in `test-data/test-branch-names.txt`.
---

## Directory Structure
```
tests/test-pre-push-naming/
├── test-naming              # Main test runner script
├── test-data/
│   └── test-branch-names.txt   # Branch name scenarios + expected outcomes    
└── README.md             # This documentation
```

## Tests

**Branch validation** follows this regex: "(^(feature|hotfix|bugfix|library|prerelease|release|dev|improvement)\/[A-Z]+\-[0-9]+(-.*)?$)|^([A-Z]+\-[0-9]+(-.*)?$)|^(main)$"

### Validation Criteria

1. **Prefix + ticket number**  
   - Example: `feature/DPDS-1234-login-handler`  
   - Allowed  

2. **Ticket number with suffix**  
   - Example: `DPDS-1234-login-handler`  
   - Allowed  

3. **Ticket number only**  
   - Example: `DPDS-1234`  
   - Allowed  

4. **Lowercase prefixes**  
   - Examples: `dpds-1234`, `dev/dpds-1234`  
   - Rejected with clear message and valid example  

5. **Non-numeric ticket numbers**  
   - Examples: `DPDS-abcd`, `hotfix/DPDS-ab3c`  
   - Rejected with clear message and valid example  

6. **Protected branches**  
   - Examples: `production`, `master`, `staging`  
   - Rejected with clear message explaining they cannot be pushed  

---

## Test Data File

`test-branch-names.txt` defines test cases as:  
```
<branch-name> <expected-exit-code> 
```

such as:
   - feature/DPDS-1234-login-handler 0
   - production 1

exit codes follow the convention below:
- `0` → hook should allow push  
- `1` → hook should reject push  

Blank lines and comments (`#`) are ignored.

## Running the Tests

```bash
chmod +x hooks/pre-push-naming
chmod +x tests/test-pre-push-naming/test-naming
./tests/test-pre-push-naming/test-naming
```

All tests should pass if hook running correctly.

## Notes

- Each test spins up a fresh temporary repo + remote, ensuring no cross-contamination.
- Hook rejection is verified not just by exit code, but also by checking that a clear error message is printed.
- To add new scenarios, edit test-data/test-branch-names.txt.

For issues or enhancements, reach out to Isabella Fernandes <isa.fernandes2003@gmail.com>.    
Co-authored-by: Ben Rhine <user@users.noreply.github.com> (**TODO**: change when cloning repo into org).