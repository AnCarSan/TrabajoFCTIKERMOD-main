class Aparicion : Codable{
    public let aparicion: String
    
    init(json: [String: Any]) {
        aparicion = json["aparicion"] as? String ?? ""
        
    }
}
