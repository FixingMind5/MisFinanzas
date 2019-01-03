import Foundation
//=======================================================
//Typealias==============================================

typealias transactionHandler = ( (_ completed: Bool, _ confirmation: Date) -> Void)

//=======================================================
//PROTOCOLS==============================================
protocol addActivo {
    func addActivo(_ activo: ACTIVO)
}

protocol miAhorro {
    var valorAhorro: Float { get set }
    var nombreAhorro: String { get set }
}

protocol addAhorro {
    func addAhorro(ahorro: AHORRO)
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
    var transValid: Bool { get }
    var transHandler: transactionHandler? { get }
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
    var totalAhorro: Float {
        return ahorros.reduce(0.0, { $0 + $1.valorAhorro })
    }
    
    var porcentajeDeuda: Float {
        return ingresoNeto / deudaConsumo
    }
    var porcentajeAhorro: Float {
        return totalAhorro / ingresoNeto
    }
    var mesesRiesgo: Float {
        return totalAhorro / cuenta!.deudas.reduce(0.0, { $0 + $1.transValue })
    }
    
    var cuenta: CUENTA?
    weak var tarjeta: creditCard?
    
    var activos: [ACTIVO] = []
    var misDeudas: [DEUDA] = []
    var ahorros: [AHORRO] = []
    
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

class AHORRO : miAhorro {
    var valorAhorro: Float
    var nombreAhorro: String
    
    init(valorAhorro: Float, nombreAhorro: String) {
        self.valorAhorro = valorAhorro
        self.nombreAhorro = nombreAhorro
    }
}

class GAIN : gainTypes {
    var gainType: gainCategory
    var transName: String
    var transValue: Float
    var transDate: Date
    var transValid: Bool
    var transHandler: transactionHandler?
    
    init(
        transName: String,
        transValue: Float,
        transDate: Date,
        transValid: Bool,
        gainType: gainCategory
        ) {
        self.transName = transName
        self.transValue = transValue
        self.gainType = gainType
        self.transDate = transDate
        self.transValid = transValid
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.transHandler?(true, Date())
        }
    }
}

class DEBIT : debitTypes {
    var debitType: debitCategory
    var transName: String
    var transValue: Float
    var transDate: Date
    var transValid: Bool
    var transHandler: transactionHandler?
    
    init(transName: String,
         transValue: Float,
         transDate: Date,
         transValid: Bool,
         debitType: debitCategory
        ) {
        self.transName = transName
        self.transValue = transValue
        self.debitType = debitType
        self.transDate = transDate
        self.transValid = transValid
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.transHandler?(true, Date())
        }
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

//=======================================================
//EXTENSIONS=============================================
extension PERSONA : addActivo {
    func addActivo(_ activo: ACTIVO) {
        activos.append(activo)
    }
}

extension PERSONA : addDeuda {
    func addDeuda(_ deuda: DEUDA) {
        misDeudas.append(deuda)
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
        case .gain(let gName, let gValue, let gDate, let gValid, let gType):
            
            let gain = GAIN(
                transName: gName,
                transValue: gValue,
                transDate: gDate,
                transValid: gValid,
                gainType: gType
            )
            
            gain.transHandler = { (completed, confirmation) in
                gain.transDate = confirmation
                self.ingresos.append(gain)
                self.miFlujo.append(gain)
                self.saldoCuenta += gain.transValue
            }

            
        case .debit(let dName, let dValue, let dDate, let dValid, let dType):
            
            let debit = DEBIT(
                transName: dName,
                transValue: dValue,
                transDate: dDate,
                transValid: dValid,
                debitType: dType
            )
            
            debit.transHandler = { (completed, confirmation) in
                debit.transDate = confirmation
                self.deudas.append(debit)
                self.deudas.filter({ (transaction) -> Bool in
                    guard let transaction = transaction as? DEBIT else {
                        return false
                    }
                    return transaction.debitType == debitCategory.ocio
                })
                self.miFlujo.append(debit)
                self.saldoCuenta -= debit.transValue
            }
            
            
            if (saldoCuenta < 0) {
                print("saldo negativo")
                throw transactionExceptions.saldoNegativo
            }
        }
        
        return saldoCuenta
    }
}

extension PERSONA : addAhorro {
    func addAhorro(ahorro: AHORRO) {
        ahorros.append(ahorro)
    }
}

//=======================================================
//SOMETHING==============================================
var manu = PERSONA(name: "Manuel", lastName: "Aguilar")

manu.cuenta = CUENTA(saldoCuenta: 500)
