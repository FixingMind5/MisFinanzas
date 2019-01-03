import Foundation

<<<<<<< Updated upstream
public protocol transactions {
    var transName: String { get set }
    var transValue: Float { get set }
    var transDate: Date { get set }
    var transValid: Bool { get }
    var transHandler: transactionHandler? { get }
}

public enum transactionIs {
    case gain(
        gainName: String,
        gainValue: Float,
        gainDate: Date,
        gainValid: Bool,
        gainType: gainCategory
    )
    
    case debit(
        debitName: String,
        debitValue: Float,
        debitDate: Date,
        debitValid: Bool,
        debitType: debitCategory
    )
}

public enum transactionExceptions : Error {
    case saldoNegativo
}
=======
>>>>>>> Stashed changes
