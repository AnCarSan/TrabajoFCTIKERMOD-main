//
//  ViewController.swift
//  TrabajoFCT
//
//  Created by Apps2M on 7/2/23.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myButton: UIButton!
    let dataManager : DataManager = DataManager()
    
    let url0 = URL(string: "http://127.0.0.1:5000/api/usuario")
    
    let url1 = URL(string: "http://127.0.0.1:5000/api/usuarioElegido")
    
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

    var IdElegido = ""
    var NombreElegido = ""
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    @IBOutlet weak var nomUsuario: UITextField!
    @IBOutlet weak var contrasenUsuario: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "IniciarSesion"{
            let destinationVC = segue.destination as? ViewControllerHome
            destinationVC?.nombreUsuario = listaUserNombre[1]
        }
        
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
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
        sleep(1)
    }
    
    func chargeUser() {
        let postUserElegido: [String : Any] = [
            "id" : IdElegido,
            "nombre" : NombreElegido
        ]
        
        let url = URL(string: "http://127.0.0.1:5000/api/usuarioElegido")!
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
                let responseObject = try JSONDecoder().decode(ResponseObject<UsuarioElegido>.self, from: data)
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
    
    
      let yourAttributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 14),
          .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
 
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame:  CGRect(x: 0, y: 0, width: 200, height: 250))
        imageView.image = UIImage(named: "LogoProyecto")
        return imageView
    }()
    
    override func viewDidLoad() {
        loadUsers()
         super.viewDidLoad()
         view.addSubview(imageView)
        
         let attributeString = NSMutableAttributedString(
            string: "¿Olvidaste tu contraseña?",
            attributes: yourAttributes
         )
         myButton.setAttributedTitle(attributeString, for: .normal)
      }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    
    private func animate() {
        UIView.animate(withDuration: 0.5, animations: {
            let size = self.view.frame.size.width * 0.5
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.width - size
            
            self.imageView.frame = CGRect(
                x:-(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
            
            self.imageView.alpha = 0
            
        })
            
        
    }
    
    @IBAction func IniciarSesion(_ sender: Any) {
        sleep(1 + 1/2)
        var logIN = false
        for i in 1...listaUserNombre.count{
            if listaUserNombre[i-1] == nomUsuario.text && listaUserContrasena[i-1] == contrasenUsuario.text{
                print("match")
                IdElegido = String(listaUserId[i-1])
                NombreElegido = listaUserNombre[i-1]
                chargeUser()
                logIN = true
                break
            }
            else if listaUserNombre.count == i{
                self.showToast(message: "Revisa los datos", font: .systemFont(ofSize: 12.0))
                print("Revisa los datos")
            }
            else{
                print("error")
            }
        }
        if logIN == true{
            performSegue(withIdentifier: "IniciarSesion", sender: (Any).self)
        }
    }
    
}
