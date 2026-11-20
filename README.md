# Wipro LAB-1B — Access Control and Encapsulation

## Objective
Choose suitable access levels and prevent invalid changes to model data.

---

## Project Structure

```
Wipro-LAB-1B/
├── main.swift             ← Entry point; runs all 5 sections
├── BankAccount.swift      ← Task 1,2,4 — BankAccount with private balance
├── AccessLevelsDemo.swift ← Task 3 — demonstrates all 4 access levels
└── README.md              ← This file
```

---

## How to Run

**Option A — Swift CLI (macOS/Linux)**
```bash
swift main.swift BankAccount.swift AccessLevelsDemo.swift
```

**Option B — Xcode**
1. File → New → Project → Command Line Tool (Swift)
2. Replace the generated files with the three `.swift` files above.
3. Run (⌘R).

**Option C — Online**  
Paste each file's content into [https://swiftfiddle.com](https://swiftfiddle.com) *(single-file mode: combine in order: BankAccount.swift, AccessLevelsDemo.swift, main.swift)*.

---

## Access Modifier Explanation

| Modifier | Scope | Used In This Project |
|----------|-------|----------------------|
| `private` | Only the **enclosing declaration** (and same-file extensions) | `balance`, `transactionLog`, `log()` in `BankAccount` — completely hidden; no caller can read or write balance directly |
| `fileprivate` | Anywhere in the **same `.swift` file** | `validateAmount(_:)` in `BankAccount.swift` — shared between the class and its same-file extension but invisible to `main.swift` or `AccessLevelsDemo.swift` |
| `internal` *(default)* | Anywhere in the **same module** (all files in the same build target) | `accountHolder`, `accountNumber` in `BankAccount` — readable from `main.swift` within the project, but would be hidden from an external framework consumer |
| `public` | **Any module** that imports this one | `BankAccount` class, `deposit()`, `withdraw()`, `currentBalance`, `printStatement()`, `BankAccountError` — the full public API |

> **Key design principle:** `balance` is `private` with a `public` *read-only* computed property `currentBalance`. Callers can observe the balance but can never assign to it — all mutations go through `deposit` and `withdraw`, which validate every input.

---

## Task Checklist

| # | Task | File |
|---|------|------|
| 1 | `BankAccount` with `private balance`, `public deposit/withdraw` | `BankAccount.swift` |
| 2 | Rejects zero/negative deposits, over-balance withdrawals, invalid setup | `BankAccount.swift` + validated in `main.swift` Section 3 |
| 3 | `private`, `fileprivate`, `internal`, `public` with explanation | `AccessLevelsDemo.swift` + `main.swift` Section 4 |
| 4 | `currentBalance` read-only; balance not freely writable | `BankAccount.swift` (private storage + public getter) |

---

## Test / Validation Table (10 Cases)

| # | Operation | Input | Expected Outcome | Boundary |
|---|-----------|-------|-----------------|----------|
| 1 | Create account | holder="Shyam", deposit=₹5000 | ✅ Account created | Normal |
| 2 | Deposit | ₹2000 | ✅ Balance = ₹6500 | Normal |
| 3 | Withdraw | ₹1500 | ✅ Balance = ₹5000 | Normal |
| 4 | Create with empty name | holder="" | ❌ `invalidAccountHolder` | Boundary |
| 5 | Create with zero deposit | deposit=₹0 | ❌ `invalidInitialDeposit` | Lower boundary |
| 6 | Create with negative deposit | deposit=-₹500 | ❌ `invalidInitialDeposit` | Invalid |
| 7 | Deposit zero | ₹0 | ❌ `negativeOrZeroAmount` | Lower boundary |
| 8 | Deposit negative | -₹200 | ❌ `negativeOrZeroAmount` | Invalid |
| 9 | Withdraw more than balance | ₹2000 from ₹1000 | ❌ `insufficientFunds` | Over-limit |
| 10 | Withdraw exactly balance | ₹1000 from ₹1000 | ✅ Balance = ₹0 | Upper boundary |

---

## Access Level Visibility Quick Reference

```
File: BankAccount.swift
┌──────────────────────────────────────────────────────────┐
│ private    balance, transactionLog, log()                │
│            ↳ only BankAccount body + same-file extensions│
│                                                          │
│ fileprivate validateAmount(_:), canWithdraw(:)           │
│            ↳ BankAccount.swift top-to-bottom only        │
│                                                          │
│ internal   accountHolder, accountNumber                  │
│            ↳ main.swift, AccessLevelsDemo.swift, etc.   │
│                                                          │
│ public     BankAccount, currentBalance, deposit,         │
│            withdraw, printStatement, BankAccountError    │
│            ↳ any importing module                        │
└──────────────────────────────────────────────────────────┘
```

---

*Submitted by: Shyam Dixit | Wipro LAB-1B*
