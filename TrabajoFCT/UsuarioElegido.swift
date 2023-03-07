class UsuarioElegido : Codable{
    public let id: String
    public let nombre: String
    
    init(json: [String: Any]) {
        id = json["id"] as? String ?? ""
        nombre = json["nombre"] as? String ?? ""
        
    }
}
