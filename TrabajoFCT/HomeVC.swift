import UIKit

class ViewControllerHome: UIViewController {
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    var imgArr = [  UIImage(named:"CyberpunkSlider"),
                    UIImage(named:"BreakingBadSlider") ,
                    UIImage(named:"InsideJob")
    ]
    
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
    
    let dataManager : DataManager = DataManager()
    

   
    let url1 = URL(string: "http://127.0.0.1:5000/api/usuarioElegido")
    let url3 = URL(string: "http://127.0.0.1:5000/api/pelicula")
    let url5 = URL(string: "http://127.0.0.1:5000/api/serie")
    var nombreUsuario : String = ""
    
    
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
    var listaSerieFotoPaisaje : [String] = []
    var listaSerieEnLista : [String] = []
    
    var UserElegidoNombre: [String] = []
    var UserElegidoId: [String] = []

    var timer = Timer()
    var counter = 0
    
    @IBOutlet weak var imagen1: UIImageView!
    @IBOutlet weak var imagen2: UIImageView!
    @IBOutlet weak var imagen3: UIImageView!
    @IBOutlet weak var imagen4: UIImageView!
    @IBOutlet weak var imagen5: UIImageView!
    @IBOutlet weak var imagen6: UIImageView!
    
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
    @IBOutlet weak var texto3: UILabel!
    @IBOutlet weak var texto4: UILabel!
    @IBOutlet weak var texto5: UILabel!
    @IBOutlet weak var texto6: UILabel!


    @IBAction func boton1(_ sender: Any) {
        indexpath = 0
        performSegue(withIdentifier: "entrarMusica", sender: (Any).self)
    }
    @IBAction func boton2(_ sender: Any) {
        indexpath = 4
        performSegue(withIdentifier: "entrarMusica", sender: (Any).self)
    }
    @IBAction func boton3(_ sender: Any) {
        indexpath = 5
        performSegue(withIdentifier: "entrarMusica", sender: (Any).self)
    }
    @IBAction func boton4(_ sender: Any) {
        indexpath = 1
        performSegue(withIdentifier: "entrarMusica", sender: (Any).self)
    }
    @IBAction func boton5(_ sender: Any) {
        indexpath = 3
        performSegue(withIdentifier: "entrarMusica", sender: (Any).self)
    }
    @IBAction func boton6(_ sender: Any) {
        indexpath = 6
        performSegue(withIdentifier: "entrarMusica", sender: (Any).self)
    }
    
    
    @IBAction func verMas1(_ sender: Any) {
        performSegue(withIdentifier: "entrarVerMas", sender: (Any).self)
    }
    
    @IBAction func verMas2(_ sender: Any) {
        performSegue(withIdentifier: "entrarVerMas", sender: (Any).self)
    }
    
    @IBAction func verMas3(_ sender: Any) {
        performSegue(withIdentifier: "entrarVerMas", sender: (Any).self)
    }
    
    
    
    
    
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
    
    func mostrarDatos() {
        imagen1.image = convertBase64StringToImage(imageBase64String: listaSerieFoto[0])
        print(listaSerieNombre)
        imagen2.image = convertBase64StringToImage(imageBase64String: listaSerieFoto[4])
        imagen3.image = convertBase64StringToImage(imageBase64String: listaSerieFoto[5])
        imagen4.image = convertBase64StringToImage(imageBase64String: listaSerieFoto[1])
        imagen5.image = convertBase64StringToImage(imageBase64String: listaSerieFoto[3])
        imagen6.image = convertBase64StringToImage(imageBase64String: listaSerieFoto[6])
        
        texto1.text = listaSerieNombre[0]
        texto2.text = listaSerieNombre[4]
        texto3.text = listaSerieNombre[5]
        texto4.text = listaSerieNombre[1]
        texto5.text = listaSerieNombre[3]
        texto6.text = listaSerieNombre[6]
        
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
    
    
    func loadUsers() {
        URLSession.shared.dataTask(with: url1!) {(data, response, error) in
            if let response = response as? HTTPURLResponse{
                print(response.statusCode)
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200, error == nil else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                self.dataManager.usuarioElegido.removeAll()
                for nombre in json as! [[String : Any]] {
                    self.dataManager.usuarioElegido.append(UsuarioElegido(json: nombre))
                }
                
                
                self.UserElegidoId.removeAll()
                self.UserElegidoNombre.removeAll()
                
                
                
                
                for usuario in self.dataManager.usuarioElegido{
                    self.UserElegidoId.append(usuario.id)
                    self.UserElegidoNombre.append(usuario.nombre)
                    
                }
                
            } catch let errorJson {
                print(errorJson)
            }
        }.resume()
        sleep(1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        loadSeries()
        sleep(2)
        loadMovies()
        mostrarDatos()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changeImage() {
        
        if counter < imgArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter = 1
        }
        
    }
    
}

extension ViewControllerHome: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CellView
        
        cell?.cellImage.image = imgArr[indexPath.row]
        
        return cell!
    }
}

extension ViewControllerHome: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
