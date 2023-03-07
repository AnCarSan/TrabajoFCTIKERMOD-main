import UIKit

class ViewControllerHome: UIViewController {
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    var imgArr = [  UIImage(named:"CyberpunkSlider"),
                    UIImage(named:"BreakingBadSlider") ,
                    UIImage(named:"InsideJob")
    ]
    
    let dataManager : DataManager = DataManager()
    
    let url3 = URL(string: "http://127.0.0.1:5000/api/serie")
    
    let url5 = URL(string: "http://127.0.0.1:5000/api/pelicula")
   
    let url1 = URL(string: "http://127.0.0.1:5000/api/usuarioElegido")
    
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
    
    
    var listaPeliculaNombre : [String] = []
    var listaPeliculaGenero : [String] = []
    var listaPeliculaDirector : [String] = []
    var listaPeliculaProtagonista : [String] = []
    var listaPeliculaDesripcionCorta : [String] = []
    var listaPeliculaFoto : [String] = []
    var listaPeliculaAnoDePublicacion : [String] = []
    var listaPeliculaDuracion : [String] = []
    
    var UserElegidoNombre: [String] = []
    var UserElegidoId: [String] = []

    var timer = Timer()
    var counter = 0
    
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
    }
    
    
    @IBAction func botonPrueba(_ sender: Any) {
        print(nombreUsuario)
        print(UserElegidoId)
        print(UserElegidoNombre)
        
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
