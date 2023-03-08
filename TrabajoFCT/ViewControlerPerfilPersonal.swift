import UIKit

class ViewControllerPerfilPersonal: UIViewController {

    @IBOutlet weak var ImagenPerfilPersonal: UIImageView!
    
    let dataManager : DataManager = DataManager()
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    let url0 = URL(string: "http://127.0.0.1:5000/api/usuario")
    
    let url1 = URL(string: "http://127.0.0.1:5000/api/usuarioElegido")
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    var listaUserId : [String] = []
    var listaUserNombre : [String] = []
    var listaUserContrasena : [String] = []
    var listaUserGenero : [String] = []
    var listaUserFoto : [String] = []
    var listaUserDNI : [String] = []
    var listaUserTipoDeCuenta : [String] = []
    var listaUserFechaDeNacimiento : [String] = []
    
    var UserElegidoNombre: [String] = []
    var UserElegidoId: [String] = []
    
    @IBOutlet weak var nombreGrande: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var DNI: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var tipo: UILabel!
    
    func loadUsers() {
        URLSession.shared.dataTask(with: url0!) {(data, response, error) in
            if let response = response as? HTTPURLResponse{
                print(response.statusCode)
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200, error == nil else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                self.dataManager.usuario.removeAll()
                for nombre in json as! [[String : Any]] {
                    self.dataManager.usuario.append(Usuario(json: nombre))
                }
                
                
                self.listaUserId.removeAll()
                self.listaUserNombre.removeAll()
                self.listaUserContrasena.removeAll()
                self.listaUserGenero.removeAll()
                self.listaUserFoto.removeAll()
                self.listaUserDNI.removeAll()
                self.listaUserTipoDeCuenta.removeAll()
                self.listaUserFechaDeNacimiento.removeAll()
                
                
                
                for usuario in self.dataManager.usuario{
                    self.listaUserId.append(String(usuario.id))
                    self.listaUserNombre.append(usuario.nombre)
                    self.listaUserContrasena.append(usuario.contrasena)
                    self.listaUserGenero.append(usuario.genero)
                    self.listaUserFoto.append(usuario.foto)
                    self.listaUserDNI.append(usuario.DNI)
                    self.listaUserTipoDeCuenta.append(usuario.tipoDeCuenta)
                    self.listaUserFechaDeNacimiento.append(usuario.fechaDeNacimiento)
                }
                
            } catch let errorJson {
                print(errorJson)
            }
        }.resume()
        sleep(2)
    }
    
    func loadSelectedUsers() {
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
    
    
    // Dispose of any resources that can be recreated.
      override func viewDidLoad() {
         super.viewDidLoad()
          loadUsers()
          loadSelectedUsers()
          sleep(1)
          ImagenPerfilPersonal.layer.cornerRadius = ImagenPerfilPersonal.frame.size.width/2
          for i in 1...listaUserNombre.count{
              if listaUserNombre[i-1] ==  UserElegidoNombre[0] && UserElegidoId[0] ==  listaUserId[i-1] {
                  DNI.text = listaUserDNI[i-1]
                  nombre.text = listaUserNombre[i-1]
                  nombreGrande.text = listaUserNombre[i-1]
                  fecha.text = listaUserFechaDeNacimiento[i-1]
                  tipo.text = listaUserTipoDeCuenta[i-1]
                  let imageView = convertBase64StringToImage(imageBase64String: listaUserFoto[i-1])
                  ImagenPerfilPersonal.image = imageView
                  print("match")
                  break
              }
          }
          
      }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func botonEditar(_ sender: Any) {
        print(UserElegidoId)
        print(UserElegidoNombre)
        print(listaUserNombre)
        
}
    
}
