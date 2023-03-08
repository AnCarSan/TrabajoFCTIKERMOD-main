import UIKit

class PruebaListaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CustomTableViewCell
        cell.Titulo.text = listaMusicaNombre[indexPath.row]
        let imageMusic = convertBase64StringToImage(imageBase64String: listaMusicaFoto[indexPath.row])
        cell.imagen.image = imageMusic
        cell.aparicion.text = listaMusicaMomentoDeAparicion[indexPath.row]
        
        
        
        return cell
    }
    
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexpath = indexPath.row
        performSegue(withIdentifier: "entrarPV", sender: (Any).self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMusicaNombre.count
    }
    
    var indexpath : Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "entrarPV"{
            let destinationVC = segue.destination as? PlayerViewVC
            destinationVC?.idMusica = listaMusicaId[indexpath]
        }
        
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    @IBAction func recargar(_ sender: Any) {
        table.reloadData()
    }
    
    func chargeLista(listNombre:String, listInstancia:String) {
        let postFav: [String : Any] = [
            "nombre" : listNombre,
            "enLista" : listInstancia
        ]
        
        let url = URL(string: "http://127.0.0.1:5000/api/lista")!
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
                let responseObject = try JSONDecoder().decode(ResponseObject<EnLista>.self, from: data)
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
    
    @IBOutlet weak var botonStyle: UIButton!
    @IBAction func anadirALista(_ sender: Any) {
        
            if MultimediaFav == "true"{
                chargeLista(listNombre: nombreSerie, listInstancia: "false")
                botonStyle.setTitle("+Añadir a tu lista", for: .normal)
                MultimediaFav = "false"
                
            }
            else if listaMusicaFavorito[0] == "false"{
                botonStyle.setTitle("-Quitar de tu lista", for: .normal)
                chargeLista(listNombre: nombreSerie, listInstancia: "true")
                MultimediaFav = "true"
            }
    }
    
    @IBOutlet weak var TítuloSeriePeli: UILabel!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var nombreMultim: UILabel!
    @IBOutlet weak var ImagenPeliSerie: UIImageView!
    
    
    
    let dataManager : DataManager = DataManager()
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    var imgStr : String = ""
    var nombreSerie : String = ""
    var MultimediaFav : String = ""
    var listaMusicaId : [String] = []
    var listaMusicaNombre : [String] = []
    var listaMusicaGenero : [String] = []
    var listaMusicaCantante : [String] = []
    var listaMusicaFoto : [String] = []
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
    

    
    let url1 = URL(string: "http://127.0.0.1:5000/api/musicaRapida")
    
    func loadMusic() {

            URLSession.shared.dataTask(with: url1!) {(data, response, error) in

                guard let data = data,

                      let response = response as? HTTPURLResponse,

                      response.statusCode == 200, error == nil else {return}

                do {

                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

                    self.dataManager.musica.removeAll()

                    for nombre in json as! [[String : Any]] {

                        self.dataManager.musica.append(Musica(json: nombre))

                    }

                    self.listaMusicaId.removeAll()
                    self.listaMusicaNombre.removeAll()
                    self.listaMusicaGenero.removeAll()
                    self.listaMusicaCantante.removeAll()
                    self.listaMusicaFoto.removeAll()
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


                    for musicas in self.dataManager.musica{
                        self.listaMusicaId.append(String(musicas.id))
                        self.listaMusicaNombre.append(musicas.nombre)
                        self.listaMusicaGenero.append(musicas.genero)
                        self.listaMusicaCantante.append(musicas.cantante)
                        self.listaMusicaFoto.append(musicas.foto)
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

    @IBAction func botonAtras(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func chargeMultimedia() {
        let postUserElegido: [String : Any] = [
            "aparicion" : nombreSerie,
        ]
        
        
        
        let url = URL(string: "http://127.0.0.1:5000/api/aparicion")!
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
                let responseObject = try JSONDecoder().decode(ResponseObject<Aparicion>.self, from: data)
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
        sleep(1)
        }
    
    func chargeMusica() {
        let postUserElegido: [String : Any] = [
            "nombre" : "Everyday",
        ]
        
        
        let url2 = URL(string: "http://127.0.0.1:5000/api/musicaElegida")!
        var request = URLRequest(url: url2)
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
                let responseObject = try JSONDecoder().decode(ResponseObject<MusicaElegida>.self, from: data)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chargeMultimedia()
        chargeMusica()
        loadMusic()
        nombreMultim.text = nombreSerie
        ImagenPeliSerie.image = convertBase64StringToImage(imageBase64String: imgStr)
        table.dataSource = self
        sleep(2)
        if MultimediaFav == "true"{
            botonStyle.setTitle("-Quitar de tu lista", for: .normal)
        }
        else if MultimediaFav == "false"{
            botonStyle.setTitle("+Añadir a tu lista", for: .normal)
        }
        
    }
    
    
}
