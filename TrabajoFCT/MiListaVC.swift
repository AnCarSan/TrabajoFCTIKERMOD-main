import UIKit

class MiLIstaViewController: UIViewController {
    
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "entrarMusica"{
            let destinationVC = segue.destination as? PruebaListaViewController
            destinationVC?.imgStr = listaSerieFotoPaisaje[indexpath]
            destinationVC?.nombreSerie = listaSerieNombre[indexpath]
            destinationVC?.MultimediaFav = listaSerieEnLista[indexpath]
        }
        
    }
    
    var indexpath : Int = 0
    
    let url3 = URL(string: "http://127.0.0.1:5000/api/lista")
    let url5 = URL(string: "http://127.0.0.1:5000/api/listaPelicula")
    
    var listaSerieNombre : [String] = []
    var listaSerieGenero : [String] = []
    var listaSerieDirector : [String] = []
    var listaSerieProtagonista : [String] = []
    var listaSerieDescripcionCorta : [String] = []
    var listaSerieTemporadas : [String] = []
    var listaSerieEpisodios : [String] = []
    var listaSerieFoto : [String] = []
    var listaSerieAnoDePublicacion : [String] = []
    var listaSerieDuracion : [String] = []
    var listaPeliculaNombre : [String] = []
    var listaPeliculaGenero : [String] = []
    var listaPeliculaDirector : [String] = []
    var listaPeliculaProtagonista : [String] = []
    var listaPeliculaDesripcionCorta : [String] = []
    var listaPeliculaFoto : [String] = []
    var listaPeliculaAnoDePublicacion : [String] = []
    var listaPeliculaDuracion : [String] = []
    var listaSerieFotoPaisaje : [String] = []
    var listaSerieEnLista : [String] = []
    
    let dataManager : DataManager = DataManager()
    
    func loadMovies() {
        
        URLSession.shared.dataTask(with: url5!) {(data, response, error) in
            
            guard let data = data,
                  
                    let response = response as? HTTPURLResponse,
                  
                    response.statusCode == 200, error == nil else {return}
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                self.dataManager.pelicula.removeAll()
                
                for nombre in json as! [[String : Any]] {
                    
                    self.dataManager.pelicula.append(Pelicula(json: nombre))
                    
                }
                
                
                for peliculas in self.dataManager.pelicula{
                    
                    self.listaSerieNombre.append(peliculas.nombre)
                    
                    self.listaSerieFoto.append(peliculas.foto)
                    
                    self.listaSerieFotoPaisaje.append(peliculas.imagenPaisaje)
                    self.listaSerieEnLista.append(peliculas.enLista)
                    
                    
                    
                    
                }
                
                
                
            } catch let errorJson {
                
                print(errorJson)
                
            }
            
        }.resume()
        sleep(4)
        
    }
    
    func loadSeries() {
        
        URLSession.shared.dataTask(with: url3!) {(data, response, error) in
            
            guard let data = data,
                  
                    let response = response as? HTTPURLResponse,
                  
                    response.statusCode == 200, error == nil else {return}
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                self.dataManager.serie.removeAll()
                
                for nombre in json as! [[String : Any]] {
                    
                    self.dataManager.serie.append(Serie(json: nombre))
                    
                }
    
                
                self.listaSerieNombre.removeAll()
                
                self.listaSerieGenero.removeAll()
                
                self.listaSerieDirector.removeAll()
                
                self.listaSerieProtagonista.removeAll()
                
                self.listaSerieDescripcionCorta.removeAll()
                
                self.listaSerieTemporadas.removeAll()
                
                self.listaSerieEpisodios.removeAll()
                
                self.listaSerieFoto.removeAll()
                
                self.listaSerieAnoDePublicacion.removeAll()
                
                self.listaSerieDuracion.removeAll()
                
                self.listaSerieFotoPaisaje.removeAll()
                sleep(2)
                
                
                
                
                for series in self.dataManager.serie{
                    
                    self.listaSerieNombre.append(series.nombre)
                    
                    self.listaSerieGenero.append(series.genero)
                    
                    self.listaSerieDirector.append(series.director)
                    
                    self.listaSerieProtagonista.append(series.protagonista)
                    
                    self.listaSerieDescripcionCorta.append(series.descripcionCorta)
                    
                    self.listaSerieTemporadas.append(String(series.temporadas))
                    
                    self.listaSerieEpisodios.append(String(series.episodios))
                    
                    self.listaSerieFoto.append(series.foto)
                    
                    self.listaSerieAnoDePublicacion.append(String(series.anoDePublicacion))
                    
                    self.listaSerieDuracion.append(series.duracion)
                    
                    self.listaSerieFotoPaisaje.append(series.imagenPaisaje)
                    self.listaSerieEnLista.append(series.enLista)
                    
                }
                
                
                
            } catch let errorJson {
                
                print(errorJson)
                
            }
            
        }.resume()
        sleep(2)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSeries()
        sleep(2)
        loadMovies()
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.dataSource = self
    }
    
    @IBAction func botonRecargar(_ sender: Any) {
        viewDidLoad()
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
}

extension MiLIstaViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaSerieNombre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellReuseIdentifier", for: indexPath)
        as! CustomCollectionViewCell
        
        cell.nombreMulti.text = listaSerieNombre[indexPath.row]
        cell.subtituloMulti.text = listaSerieNombre[indexPath.row]
        cell.imagenMulti.image = convertBase64StringToImage(imageBase64String: listaSerieFoto[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexpath = indexPath.row
        performSegue(withIdentifier: "entrarMusica", sender: (Any).self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-10)/2
        return CGSize(width: size, height: size * 2)
    }
}
