// ============================================================
// AccessLevelsDemo.swift
// Wipro LAB-1B — Access Control and Encapsulation
//
// PURPOSE: Isolate a small multi-"module" demonstration of all
//          four access levels: private, fileprivate, internal, public
//
// Because a command-line Swift tool is a single module, we simulate
// the boundary with clear comments and a separate file.
// ============================================================

import Foundation

// MARK: - Demonstration Struct

/// Showcases every access level in one type.
public struct AccessLevelsDemo {

    // ── PUBLIC ────────────────────────────────────────────────
    // Visible everywhere: inside this file, this module, AND any
    // external module that imports this one.
    public var publicInfo: String = "I am visible to ALL modules"

    // ── INTERNAL (default) ───────────────────────────────────
    // Visible anywhere inside this module (all .swift files in
    // the same target). NOT visible to external modules.
    var internalInfo: String = "I am visible within this MODULE only"

    // ── FILEPRIVATE ───────────────────────────────────────────
    // Visible only within THIS FILE (AccessLevelsDemo.swift).
    // Other .swift files in the same module cannot access it.
    fileprivate var fileprivateInfo: String = "I am visible in THIS FILE only"

    // ── PRIVATE ───────────────────────────────────────────────
    // Visible only within THIS DECLARATION (the struct body)
    // and its extensions in the same file.
    private var privateInfo: String = "I am visible only INSIDE this struct"

    // Public method — acts as controlled gateway
    public func showAll() {
        print("  [public]       \(publicInfo)")
        print("  [internal]     \(internalInfo)")
        print("  [fileprivate]  \(fileprivateInfo)")
        print("  [private]      \(privateInfo)")
    }

    // Public method that safely exposes a filtered view
    public func publicSummary() -> String {
        return "Public: '\(publicInfo)' | Internal: '\(internalInfo)'"
    }
}

// MARK: - Same-file extension (can access fileprivate)

extension AccessLevelsDemo {
    /// This extension is in the SAME FILE → can read fileprivateInfo.
    func sameFileExtensionDemo() {
        // ✅ fileprivate is accessible here (same file)
        print("  [same-file ext] fileprivateInfo → \(fileprivateInfo)")
        // ✅ private is accessible in same-file extension
        print("  [same-file ext] privateInfo     → \(privateInfo)")
    }
}

// MARK: - Access Level Explanation Table

/// Prints a formatted explanation table of all Swift access levels.
public func printAccessLevelExplanation() {
    print("""

    ┌────────────────┬────────────────────────────────────────────────────────┐
    │  Access Level  │  Visible To                                            │
    ├────────────────┼────────────────────────────────────────────────────────┤
    │  private       │  Current declaration + same-file extensions only       │
    │  fileprivate   │  Entire source file (.swift file) it is declared in    │
    │  internal      │  Entire module (target / app) — DEFAULT level          │
    │  public        │  Any module that imports this module                   │
    │  open*         │  Any module; also allows subclassing & overriding      │
    └────────────────┴────────────────────────────────────────────────────────┘
    * open is the most permissive; not demonstrated here as not needed.

    In this project:
      BankAccount.balance        → private   (no external read OR write)
      BankAccount.validateAmount → fileprivate (used by same-file extension)
      BankAccount.accountHolder  → internal  (visible across project files)
      BankAccount (class itself) → public    (callable from main.swift)
    """)
}
