

import Foundation


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


public final class BankAccount {

    private var balance: Double

    private var transactionLog: [String] = []

    var accountHolder: String
    var accountNumber: String

    public var currentBalance: Double {
        return balance
    }

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


    public func deposit(_ amount: Double) throws {
        try validateAmount(amount)       // fileprivate helper
        balance += amount
        log("DEBIT ", amount)
    }

    public func withdraw(_ amount: Double) throws {
        try validateAmount(amount)       
        guard amount <= balance else {
            throw BankAccountError.insufficientFunds(requested: amount, available: balance)
        }
        balance -= amount
        log("CREDIT", amount)
    }

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


    fileprivate func validateAmount(_ amount: Double) throws {
        guard amount > 0 else {
            throw BankAccountError.negativeOrZeroAmount(amount)
        }
    }


    private func log(_ type: String, _ amount: Double) {
        let entry = "\(type) | ₹\(String(format: "%.2f", amount)) | Balance: ₹\(String(format: "%.2f", balance))"
        transactionLog.append(entry)
    }
}


fileprivate extension BankAccount {
    func canWithdraw(_ amount: Double) -> Bool {
        return (try? validateAmount(amount)) != nil && amount <= balance
    }
}
