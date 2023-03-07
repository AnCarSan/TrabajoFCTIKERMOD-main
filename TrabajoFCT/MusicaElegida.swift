class MusicaElegida : Codable{
    public let nombre: String
    
    init(json: [String: Any]) {
        nombre = json["nombre"] as? String ?? ""
        
    }
}
