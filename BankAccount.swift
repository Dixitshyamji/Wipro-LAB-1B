// ============================================================
// BankAccount.swift
// Wipro LAB-1B — Access Control and Encapsulation
//
// ACCESS LEVELS USED IN THIS FILE:
//   private      → balance, transactionLog (hidden even from extensions in other files)
//   fileprivate  → validateAmount(_:) helper (accessible within this file only)
//   internal     → accountHolder, accountNumber (default; visible inside the module)
//   public       → BankAccount class, deposit, withdraw, printStatement (callable by any module)
// ============================================================

import Foundation

// MARK: - Custom Error Types (public — callers need to handle them)

/// Errors that BankAccount operations can throw.
public enum BankAccountError: Error, CustomStringConvertible {
    case invalidInitialDeposit(Double)
    case invalidAccountHolder
    case negativeOrZeroAmount(Double)
    case insufficientFunds(requested: Double, available: Double)

    public var description: String {
        switch self {
        case .invalidInitialDeposit(let amt):
            return "Initial deposit \(amt) is invalid. Must be > 0."
        case .invalidAccountHolder:
            return "Account holder name cannot be empty."
        case .negativeOrZeroAmount(let amt):
            return "Amount \(amt) is invalid. Must be greater than zero."
        case .insufficientFunds(let req, let avail):
            return "Insufficient funds: requested ₹\(req), available ₹\(avail)."
        }
    }
}

// MARK: - BankAccount (public class)

/// A bank account that encapsulates balance behind private storage.
/// Callers can only read the balance; they cannot write to it directly.
public final class BankAccount {

    // ── PRIVATE: balance is completely hidden; no external code can read or write it ──
    private var balance: Double

    // ── PRIVATE: transaction history is an internal concern only ──
    private var transactionLog: [String] = []

    // ── INTERNAL (default): visible inside this module/project ──
    var accountHolder: String
    var accountNumber: String

    // ── PUBLIC computed property: callers can READ balance but NOT set it ──
    public var currentBalance: Double {
        return balance
    }

    // ── PUBLIC init: validates all inputs before creating the account ──
    public init(holder: String, number: String, initialDeposit: Double) throws {
        guard !holder.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw BankAccountError.invalidAccountHolder
        }
        guard initialDeposit > 0 else {
            throw BankAccountError.invalidInitialDeposit(initialDeposit)
        }
        self.accountHolder = holder
        self.accountNumber  = number
        self.balance        = initialDeposit
        transactionLog.append("OPEN  | ₹\(initialDeposit) | Balance: ₹\(initialDeposit)")
    }

    // MARK: - Public Operations

    /// Deposits `amount` into the account. Rejects zero or negative values.
    public func deposit(_ amount: Double) throws {
        try validateAmount(amount)       // fileprivate helper
        balance += amount
        log("DEBIT ", amount)
    }

    /// Withdraws `amount` from the account. Rejects zero/negative and over-balance.
    public func withdraw(_ amount: Double) throws {
        try validateAmount(amount)       // fileprivate helper
        guard amount <= balance else {
            throw BankAccountError.insufficientFunds(requested: amount, available: balance)
        }
        balance -= amount
        log("CREDIT", amount)
    }

    /// Prints a formatted mini-statement.
    public func printStatement() {
        print("\n┌──────────────────────────────────────────────┐")
        print("│           BANK STATEMENT                     │")
        print("├──────────────────────────────────────────────┤")
        print(String(format: "│  Holder : %-34s│", accountHolder))
        print(String(format: "│  Account: %-34s│", accountNumber))
        print("├──────────────────────────────────────────────┤")
        for entry in transactionLog {
            print("│  \(entry.padding(toLength: 44, withPad: " ", startingAt: 0))│")
        }
        print("├──────────────────────────────────────────────┤")
        print(String(format: "│  BALANCE: ₹%-33.2f│", balance))
        print("└──────────────────────────────────────────────┘")
    }

    // MARK: - fileprivate Helper (visible only within BankAccount.swift)

    /// Shared validation for deposit and withdraw amounts.
    fileprivate func validateAmount(_ amount: Double) throws {
        guard amount > 0 else {
            throw BankAccountError.negativeOrZeroAmount(amount)
        }
    }

    // MARK: - Private Helpers (completely hidden)

    private func log(_ type: String, _ amount: Double) {
        let entry = "\(type) | ₹\(String(format: "%.2f", amount)) | Balance: ₹\(String(format: "%.2f", balance))"
        transactionLog.append(entry)
    }
}

// MARK: - fileprivate Extension (same file, demonstrates fileprivate scope)

/// This extension lives in the same file so it can access fileprivate members.
/// An extension in a *different* file could NOT call validateAmount(_:).
fileprivate extension BankAccount {
    /// A same-file utility that reuses the fileprivate validator.
    func canWithdraw(_ amount: Double) -> Bool {
        return (try? validateAmount(amount)) != nil && amount <= balance
    }
}
