class Cantante : Codable{
    public let nombre: String
    public let grupo: String
    
  
    
    init(json: [String: Any]) {
        nombre = json["nombre"] as? String ?? ""
        grupo = json["grupo"] as? String ?? ""
        }
}
