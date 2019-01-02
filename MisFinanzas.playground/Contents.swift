import Foundation
//=======================================================
//Typealias==============================================

//typealias Endeudamiento = ( (_ valorDeudas: Float, _ valorIngreso: Float) -> Float)

//=======================================================
//PROTOCOLS==============================================
protocol addActivo {
    func addActivo(_ activo: ACTIVO)
}

protocol allCreditCards {
    var numberCard: UInt64 { get }
    var cvv: Int { get }
    var propietario: PERSONA { get }
    var expireDate: Date { get }
    var cutDate: Date { get }
    var payDate: Date { get }
}

protocol addDeuda {
    func addDeuda(_ deuda: DEUDA)
}

protocol transactions {
    var transName: String { get set }
    var transValue: Float { get set }
    var transDate: Date { get set }
}

protocol gainTypes : transactions {
    var gainType: gainCategory { get }
}

protocol debitTypes : transactions {
    var debitType: debitCategory { get }
}

protocol flujoCaja {
    func flujoCaja(_ trans: transactionIs) throws -> Float
}

protocol extractValue {
    func extractValue(_ trans: transactions)
}
//=======================================================
//ENUMS==================================================
enum gainCategory : String {
    case salary = "Sueldo"
    case bienes = "Cosas que tenemos"
    case deuda = "Deudas que tienen conmigo"
}

enum debitCategory : String {
    case ahorro = "Ahorros"
    case vivienda = "Vivienda"
    case transporte = "Pasajes"
    case ocio = "Ocio"
    case educacion = "Escuela"
    case necesidades = "Cuidado personal"
    case trabajo = "Trabajo"
}

enum transactionIs {
    case gain(
        gainName: String,
        gainValue: Float,
        gainDate: Date,
        gainType: gainCategory
    )
    
    case debit(
        debitName: String,
        debitValue: Float,
        debitDate: Date,
        debitType: debitCategory
    )
}

enum transactionExceptions : Error {
    case saldoNegativo
}

//=======================================================
//CLASS==================================================
class PERSONA {
    var name: String
    var lastName: String
    var ingresoNeto: Float {
        return cuenta?.ingresos.reduce(0.0, { $0 + $1.transValue } ) ?? 0
    }
    var deudaConsumo: Float {
        return cuenta?.deudas.reduce(0.0, { $0 + $1.transValue } ) ?? 0
    }
    var porcentajeDeuda: Float {
        return ingresoNeto / deudaConsumo
    }
    var cuenta: CUENTA?
    weak var tarjeta: creditCard?
    
    var activos: [ACTIVO] = []
    var deudas: [DEUDA] = []
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
}

class CUENTA {
    var saldoCuenta: Float {
        didSet {
            print("Tenemos un nuevo valor", saldoCuenta)
        }
    }
    var miFlujo: [transactions] = []
    var ingresos: [GAIN] = []
    var deudas: [DEBIT] = []
    
    init(saldoCuenta: Float) {
        self.saldoCuenta = saldoCuenta
    }
}

class ACTIVO {
    var valorActivo: Float
    var liquidez: Float
    var productividad: Bool
    var observaciones: String?
    
    init(valorActivo: Float, liquidez: Float, productividad: Bool) {
        self.valorActivo = valorActivo
        self.liquidez = liquidez
        self.productividad = productividad
    }
}

class creditCard : allCreditCards {
    var numberCard: UInt64
    var cvv: Int
    var propietario: PERSONA
    var expireDate: Date
    var cutDate: Date
    var payDate: Date
    
    init(
        numberCard: UInt64,
        cvv: Int,
        propietario: PERSONA,
        expireDate: Date,
        cutDate: Date,
        payDate: Date
        ) {
        self.numberCard = numberCard
        self.cvv = cvv
        self.propietario = propietario
        self.expireDate = expireDate
        self.cutDate = cutDate
        self.payDate = payDate
    }
}

class DEUDA {
    var saldoDeuda: Float
    var cuota: Float
    var tasa: Float
    var beneficio: Bool
    var observaciones: String?
    
    init(saldoDeuda: Float, cuota: Float, tasa: Float, beneficio: Bool) {
        self.saldoDeuda = saldoDeuda
        self.cuota = cuota
        self.tasa = tasa
        self.beneficio = beneficio
    }
}

class GAIN : gainTypes {
    var gainType: gainCategory
    var transName: String
    var transValue: Float
    var transDate: Date
    
    init(transName: String, transValue: Float, transDate: Date, gainType: gainCategory) {
        self.transName = transName
        self.transValue = transValue
        self.gainType = gainType
        self.transDate = transDate
    }
}

class DEBIT : debitTypes {
    var debitType: debitCategory
    var transName: String
    var transValue: Float
    var transDate: Date
    
    init(transName: String, transValue: Float, transDate: Date, debitType: debitCategory) {
        self.transName = transName
        self.transValue = transValue
        self.debitType = debitType
        self.transDate = transDate
    }
}

//=======================================================
//EXTENSIONS=============================================
extension PERSONA : addActivo {
    func addActivo(_ activo: ACTIVO) {
        activos.append(activo)
    }
}

extension PERSONA : addDeuda {
    func addDeuda(_ deuda: DEUDA) {
        deudas.append(deuda)
    }
}

extension Date {
    init(day: Int, month: Int, year: Int) {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        self = calendar.date(from: dateComponents) ?? Date()
    }
}

extension CUENTA : flujoCaja {
    func flujoCaja(_ trans: transactionIs) throws -> Float {
        
        switch trans {
        case .gain(let gName, let gValue, let gDate, let gType):
            
            let gain = GAIN(
                transName: gName,
                transValue: gValue,
                transDate: gDate,
                gainType: gType
            )
            
            ingresos.append(gain)
            miFlujo.append(gain)
            saldoCuenta += gain.transValue
            
        case .debit(let dName, let dValue, let dDate, let dType):
            
            let debit = DEBIT(
                transName: dName,
                transValue: dValue,
                transDate: dDate,
                debitType: dType
            )
            
            deudas.append(debit)
            deudas.filter({ (transaction) -> Bool in
                guard let transaction = transaction as? DEBIT else {
                    return false
                }
                return transaction.debitType == debitCategory.ocio
            })
            miFlujo.append(debit)
            saldoCuenta -= debit.transValue
            
            if (saldoCuenta < 0) {
                print("saldo negativo")
                throw transactionExceptions.saldoNegativo
            }
        }
        
        return saldoCuenta
    }
}
//=======================================================
//SOMETHING==============================================
var manu = PERSONA(name: "Manuel", lastName: "Aguilar")

manu.cuenta = CUENTA(saldoCuenta: 500)
