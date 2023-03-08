class Musica : Codable{
    public let id: Int
    public let nombre: String
    public let genero: String
    public let cantante: String
    public let foto: String
    public let aparicion: String
    public let momentoDeAparicion: String
    public let grupo: String
    public let anoDePublicacion: Int
    public let duracion: String
    public let enlaceYoutube: String
    public let enlaceAmazon: String
    public let enlaceItunes: String
    public let enlaceSpotify: String
    public let favorito: String
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 0
        nombre = json["nombre"] as? String ?? ""
        genero = json["genero"] as? String ?? ""
        cantante = json["cantante"] as? String ?? ""
        foto = json["foto"] as? String ?? ""
        aparicion = json["aparicion"] as? String ?? ""
        momentoDeAparicion = json["momentoAparicion"] as? String ?? ""
        grupo = json["grupo"] as? String ?? ""
        anoDePublicacion = json["anoDePublicacion"] as? Int ?? 0
        duracion = json["duracion"] as? String ?? ""
        enlaceYoutube = json["enlaceYoutube"] as? String ?? ""
        enlaceAmazon = json["enlaceAmazon"] as? String ?? ""
        enlaceItunes = json["enlaceItunes"] as? String ?? ""
        enlaceSpotify = json["enlaceSpotify"] as? String ?? ""
        favorito = json["favorito"] as? String ?? ""
        
    }
}
