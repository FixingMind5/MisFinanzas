protocol addActivo {
    func addActivo(_ activo: ACTIVO)
}

protocol addDeuda {
    func addDeuda(_ deuda: DEUDA)
}

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

var manu = PERSONA(name: "Manuel", lastName: "Aguilar")

manu.Cuenta = CUENTA(saldoCuenta: 500)
