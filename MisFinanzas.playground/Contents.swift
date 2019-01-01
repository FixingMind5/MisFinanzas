class PERSONA {
    var name: String
    var lastName: String
    var Cuenta:CUENTA?
    
    var Activos: [ACTIVO] = []
    var Deudas: [DEUDA] = []
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
}

class CUENTA {
    var saldoCuenta: Float
    
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
