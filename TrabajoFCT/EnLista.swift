class EnLista : Codable{
    public let EnLista: String
    
    init(json: [String: Any]) {
        EnLista = json["enLista"] as? String ?? ""
        
    }
}
