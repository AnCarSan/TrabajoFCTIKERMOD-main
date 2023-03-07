class Grupo : Codable{
    public let nombre: String
    public let cantante: String
    
  
    
    init(json: [String: Any]) {
        nombre = json["nombre"] as? String ?? ""
        cantante = json["cantante"] as? String ?? ""
        }
}
