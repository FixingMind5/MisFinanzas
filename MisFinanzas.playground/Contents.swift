import Foundation

//=======================================================
//PROTOCOLS==============================================
protocol addActivo {
    func addActivo(_ activo: ACTIVO)
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

//=======================================================
//CLASS==================================================
class PERSONA {
    var name: String
    var lastName: String
    var Cuenta: CUENTA?
    
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

//=======================================================
//SOMETHING==============================================
var manu = PERSONA(name: "Manuel", lastName: "Aguilar")

manu.Cuenta = CUENTA(saldoCuenta: 500)

let ropa = ACTIVO(
    valorActivo: 1_000,
    liquidez: 1,
    productividad: true
)
