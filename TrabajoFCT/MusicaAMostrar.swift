class MusicaAMostrar : Codable{
    public let id: Int
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 0
        
    }
}
