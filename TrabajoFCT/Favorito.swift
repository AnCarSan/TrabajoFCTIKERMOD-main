class Favorito : Codable{
    public let id: Int
    public let favorito: String

    
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 0
        favorito = json["favorito"] as? String ?? ""
        
    }
}
