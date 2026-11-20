

import Foundation

func banner(_ title: String) {
    let line = String(repeating: "─", count: 55)
    print("\n\(line)")
    print("  \(title)")
    print(line)
}

func attempt(_ description: String, _ block: () throws -> Void) {
    do {
        try block()
        print("  ✅ \(description)")
    } catch {
        print("  ❌ \(description) → \(error)")
    }
}


banner("1. Normal BankAccount Operations")

var account: BankAccount!
attempt("Create account with ₹5000 initial deposit") {
    account = try BankAccount(holder: "Shyam Dixit", number: "SB-001-2024", initialDeposit: 5000)
}

attempt("Deposit ₹2000") {
    try account.deposit(2000)
}

attempt("Withdraw ₹1500") {
    try account.withdraw(1500)
}

account.printStatement()


banner("2. Encapsulation — Balance is Read-Only")

print("  currentBalance (via public getter): ₹\(account.currentBalance)")
print("  Direct write to balance is BLOCKED at compile time (private)")
print("  accountHolder (internal): \(account.accountHolder) — readable within module")


banner("3. Boundary & Error Validation")

attempt("Create account with EMPTY holder name") {
    _ = try BankAccount(holder: "", number: "SB-002", initialDeposit: 1000)
}

attempt("Create account with ZERO initial deposit") {
    _ = try BankAccount(holder: "Test User", number: "SB-003", initialDeposit: 0)
}

attempt("Create account with NEGATIVE initial deposit (-500)") {
    _ = try BankAccount(holder: "Test User", number: "SB-004", initialDeposit: -500)
}

var testAccount: BankAccount!
attempt("Create test account with ₹1000") {
    testAccount = try BankAccount(holder: "Raj Kumar", number: "SB-010", initialDeposit: 1000)
}

attempt("Deposit ZERO (₹0)") {
    try testAccount.deposit(0)
}

attempt("Deposit NEGATIVE amount (-₹200)") {
    try testAccount.deposit(-200)
}

attempt("Withdraw MORE than balance (₹2000 from ₹1000)") {
    try testAccount.withdraw(2000)
}

attempt("Withdraw ZERO (₹0)") {
    try testAccount.withdraw(0)
}

attempt("Withdraw NEGATIVE amount (-₹50)") {
    try testAccount.withdraw(-50)
}

attempt("Withdraw EXACTLY the balance (₹1000)") {
    try testAccount.withdraw(1000)
}

attempt("Withdraw after account emptied (₹1)") {
    try testAccount.withdraw(1)
}

testAccount.printStatement()


banner("4. Access Level Demonstration")

printAccessLevelExplanation()

var demo = AccessLevelsDemo()
print("\n  Calling public showAll() method:")
demo.showAll()

print("\n  Calling same-file extension:")
demo.sameFileExtensionDemo()


print("\n  demo.fileprivateInfo → NOT accessible from main.swift (fileprivate)")
print("  demo.privateInfo     → NOT accessible from main.swift (private)")
print("  demo.internalInfo    → Accessible: '\(demo.internalInfo)' (internal = same module)")
print("  demo.publicInfo      → Accessible: '\(demo.publicInfo)' (public)")

banner("5. Multi-Account Demo")

let accounts: [(String, String, Double)] = [
    ("Priya Sharma",  "SB-101", 10_000),
    ("Amit Verma",    "SB-102", 25_000),
    ("Neha Gupta",    "SB-103",  5_000),
]

var createdAccounts: [BankAccount] = []
for (name, num, deposit) in accounts {
    if let acc = try? BankAccount(holder: name, number: num, initialDeposit: deposit) {
        createdAccounts.append(acc)
    }
}

try? createdAccounts[0].deposit(3000)
try? createdAccounts[0].withdraw(1500)
try? createdAccounts[1].withdraw(5000)
try? createdAccounts[2].deposit(500)

print("\n  {'Account' | 'Balance'}")
for acc in createdAccounts {
    print(String(format: "  %-15s | ₹%8.2f", acc.accountHolder, acc.currentBalance))
}

print("\n✅ LAB-1B Complete — Access Control and Encapsulation\n")
