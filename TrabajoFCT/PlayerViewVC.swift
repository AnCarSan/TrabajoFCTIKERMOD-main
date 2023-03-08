//
//  PlayerViewVC.swift
//  TrabajoFCT
//
//  Created by Apps2M on 16/2/23.
//
import UIKit
import youtube_ios_player_helper

class PlayerViewVC: UIViewController {
    
    @IBOutlet var playerView: YTPlayerView!
    
    let dataManager : DataManager = DataManager()
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    let url1 = URL(string: "http://127.0.0.1:5000/api/recogerMusicaConcreta")
    
    @IBOutlet weak var nombreCancion: UILabel!
    
    @IBOutlet weak var nombreCancionPequeno: UILabel!
    
    @IBOutlet weak var duracionCancion: UILabel!
    
    @IBOutlet weak var momentoAparicion: UILabel!
    
    @IBOutlet weak var generoCancion: UILabel!
    
    @IBOutlet weak var cantanteOGrupo: UILabel!
    
    @IBAction func botonSpoty(_ sender: Any) {
        if let url = URL(string: listaMusicaEnlaceSpotify[0]) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    @IBAction func botonYoutube(_ sender: Any) {
        if let url = URL(string: listaMusicaEnlaceYoutube[0]) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func botonITunes(_ sender: Any) {
        if let url = URL(string: listaMusicaEnlaceItunes[0]) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func botonAmazonMusic(_ sender: Any) {
        if let url = URL(string: listaMusicaEnlaceAmazon[0]) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func chargeFav(favID:Int, favInstancia:String) {
        let postFav: [String : Any] = [
            "id" : favID,
            "favorito" : favInstancia
        ]
        
        let url = URL(string: "http://127.0.0.1:5000/api/favorito")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postFav, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
          
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<Favorito>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
        }
    
    var listaMusicaId : [String] = []
    var listaMusicaNombre : [String] = []
     var listaMusicaGenero : [String] = []
     var listaMusicaCantante : [String] = []
     var listaMusicaAparicion : [String] = []
     var listaMusicaMomentoDeAparicion : [String] = []
     var listaMusicaGrupo : [String] = []
     var listaMusicaAnoDePublicacion : [String] = []
     var listaMusicaDuracion : [String] = []
     var listaMusicaEnlaceYoutube : [String] = []
     var listaMusicaEnlaceAmazon : [String] = []
     var listaMusicaEnlaceItunes : [String] = []
     var listaMusicaEnlaceSpotify : [String] = []
    var listaMusicaFavorito : [String] = []
    
    
    @IBAction func favoritoAcc(_ sender: Any) {
        
    }
    
    @IBOutlet weak var FAvView: UIButton!
    
    var idMusica : String = ""
    
    func chargeMusic() {
        let postUserElegido: [String : Any] = [
            "id" : Int(idMusica)
        ]
        
        let url = URL(string: "http://127.0.0.1:5000/api/musicaAMostrar")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postUserElegido, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
          
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<MusicaAMostrar>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
        sleep(1 + 1/2)
        }
    
    func loadMusic() {

            URLSession.shared.dataTask(with: url1!) {(data, response, error) in

                guard let data = data,

                      let response = response as? HTTPURLResponse,

                      response.statusCode == 200, error == nil else {return}

                do {

                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

                    self.dataManager.musicaPrueba.removeAll()

                    for nombre in json as! [[String : Any]] {

                        self.dataManager.musicaPrueba.append(MusicaPrueba(json: nombre))

                    }

                    self.listaMusicaId.removeAll()
                    
                    self.listaMusicaNombre.removeAll()

                    self.listaMusicaGenero.removeAll()

                    self.listaMusicaCantante.removeAll()


                    self.listaMusicaAparicion.removeAll()

                    self.listaMusicaMomentoDeAparicion.removeAll()

                    self.listaMusicaGrupo.removeAll()

                    self.listaMusicaAnoDePublicacion.removeAll()

                    self.listaMusicaDuracion.removeAll()

                    self.listaMusicaEnlaceYoutube.removeAll()

                    self.listaMusicaEnlaceAmazon.removeAll()

                    self.listaMusicaEnlaceItunes.removeAll()

                    self.listaMusicaEnlaceSpotify.removeAll()
                    
                    self.listaMusicaFavorito.removeAll()

                    for musicas in self.dataManager.musicaPrueba{

                        self.listaMusicaId.append(String(musicas.id))
                        
                        self.listaMusicaNombre.append(musicas.nombre)

                        self.listaMusicaGenero.append(musicas.genero)

                        self.listaMusicaCantante.append(musicas.cantante)

                        self.listaMusicaAparicion.append(musicas.aparicion)

                        self.listaMusicaMomentoDeAparicion.append(musicas.momentoDeAparicion)

                        self.listaMusicaGrupo.append(musicas.grupo)

                        self.listaMusicaAnoDePublicacion.append(String(musicas.anoDePublicacion))

                        self.listaMusicaDuracion.append(musicas.duracion)

                        self.listaMusicaEnlaceYoutube.append(musicas.enlaceYoutube)

                        self.listaMusicaEnlaceAmazon.append(musicas.enlaceAmazon)

                        self.listaMusicaEnlaceItunes.append(musicas.enlaceItunes)

                        self.listaMusicaEnlaceSpotify.append(musicas.enlaceSpotify)
                        
                        self.listaMusicaFavorito.append(musicas.favorito)


                    }

                    

                } catch let errorJson {

                    print(errorJson)

                }

            }.resume()
        sleep(2)

        }
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chargeMusic()
        loadMusic()
        sleep(1)
        let enlace = extractYoutubeIdFromLink(link: listaMusicaEnlaceYoutube[0])!
        playerView.load(withVideoId: enlace)
        nombreCancion.text = listaMusicaNombre[0]
        nombreCancionPequeno.text = listaMusicaNombre[0]
        duracionCancion.text = listaMusicaDuracion[0]
        generoCancion.text = listaMusicaGenero[0]
        momentoAparicion.text = listaMusicaMomentoDeAparicion[0]
        cantanteOGrupo.text = listaMusicaCantante[0]
        if listaMusicaFavorito[0] == "true"{
            FAvView.setImage(UIImage(named: "FavoritoTrue"), for: .normal)
        }
        else if listaMusicaFavorito[0] == "false"{
            FAvView.setImage(UIImage(named: "FavoritoFalse"), for: .normal)
        }
    
    
        
    }
    
    @IBAction func favAcct(_ sender: Any) {
        if listaMusicaFavorito[0] == "true"{
            FAvView.setImage(UIImage(named: "FavoritoFalse"), for: .normal)
            chargeFav(favID: Int(listaMusicaId[0])!, favInstancia: "false")
            listaMusicaFavorito[0] = "false"
            
        }
        else if listaMusicaFavorito[0] == "false"{
            FAvView.setImage(UIImage(named: "FavoritoTrue"), for: .normal)
            chargeFav(favID: Int(listaMusicaId[0])!, favInstancia: "true")
            listaMusicaFavorito[0] = "true"
        }
    }
    
    @IBAction func dissmis(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

