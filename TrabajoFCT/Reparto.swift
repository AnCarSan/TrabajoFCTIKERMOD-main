class Reparto : Codable{
    public let nombre: String
    public let rol: String
    
  
    
    init(json: [String: Any]) {
        nombre = json["nombre"] as? String ?? ""
        rol = json["rol"] as? String ?? ""
        }
}
