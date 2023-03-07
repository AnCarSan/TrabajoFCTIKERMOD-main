class Serie : Codable{
    public let nombre: String
    public let genero: String
    public let director: String
    public let protagonista: String
    public let descripcionCorta: String
    public let temporadas: Int
    public let episodios: Int
    public let foto: String
    public let anoDePublicacion: Int
    public let duracion: String
    public let enLista: String
    public let imagenPaisaje: String
    
  
    
    init(json: [String: Any]) {
        nombre = json["nombre"] as? String ?? ""
        genero = json["contrasena"] as? String ?? ""
        director = json["director"] as? String ?? ""
        protagonista = json["protagonista"] as? String ?? ""
        descripcionCorta = json["descripcionCorta"] as? String ?? ""
        temporadas = json["temporadas"] as? Int ?? 0
        episodios = json["episodios"] as? Int ?? 0
        foto = json["foto"] as? String ?? ""
        anoDePublicacion = json["anoDePublicacion"] as? Int ?? 0
        duracion = json["duracion"] as? String ?? ""
        
        enLista = json["favorito"] as? String ?? ""
        
        imagenPaisaje = json["imagenPaisaje"] as? String ?? ""
        }
}
