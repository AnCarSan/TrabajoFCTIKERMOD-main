class EnLista : Codable{
    public let nombre: String
    public let enLista: String
    
    init(json: [String: Any]) {
        nombre = json["nombre"] as? String ?? ""
        enLista = json["enLista"] as? String ?? ""
        
    }
}
