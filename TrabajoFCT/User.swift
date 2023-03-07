class Usuario : Codable{
    public let id: Int
    public let nombre: String
    public let genero: String
    public let foto: String
    public let contrasena: String
    public let DNI: String
    public let tipoDeCuenta: String
    public let fechaDeNacimiento: String
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 0
        nombre = json["nombre"] as? String ?? ""
        genero = json["contrasena"] as? String ?? ""
        foto = json["foto"] as? String ?? ""
        contrasena = json["contrasena"] as? String ?? ""
        DNI = json["DNI"] as? String ?? ""
        tipoDeCuenta = json["tipoDeCuenta"] as? String ?? ""
        fechaDeNacimiento = json["fechaDeNacimiento"] as? String ?? ""
    }
}
