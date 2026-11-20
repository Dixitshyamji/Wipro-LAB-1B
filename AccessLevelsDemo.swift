
import Foundation


public struct AccessLevelsDemo {

    
    public var publicInfo: String = "I am visible to ALL modules"

    
    var internalInfo: String = "I am visible within this MODULE only"

    
    fileprivate var fileprivateInfo: String = "I am visible in THIS FILE only"

    
    private var privateInfo: String = "I am visible only INSIDE this struct"

    public func showAll() {
        print("  [public]       \(publicInfo)")
        print("  [internal]     \(internalInfo)")
        print("  [fileprivate]  \(fileprivateInfo)")
        print("  [private]      \(privateInfo)")
    }

    public func publicSummary() -> String {
        return "Public: '\(publicInfo)' | Internal: '\(internalInfo)'"
    }
}


extension AccessLevelsDemo {
    func sameFileExtensionDemo() {
        print("  [same-file ext] fileprivateInfo → \(fileprivateInfo)")
        print("  [same-file ext] privateInfo     → \(privateInfo)")
    }
}


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
