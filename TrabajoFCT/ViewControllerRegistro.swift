import UIKit

class ViewControllerRegistro: UIViewController {

    @IBOutlet weak var myButton: UIButton!
       
    @IBOutlet weak var nombreUsuario: UITextField!
    
    @IBOutlet weak var contraUsuario: UITextField!
    
    @IBOutlet weak var fechaNacimiento: UIDatePicker!
    
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T
    }
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 14),
          .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
             
      
      override func viewDidLoad() {
         super.viewDidLoad()
        
         let attributeString = NSMutableAttributedString(
            string: "Términos y Condiciones",
            attributes: yourAttributes
         )
         myButton.setAttributedTitle(attributeString, for: .normal)
      }

    @IBAction func registrarse(_ sender: Any) {

        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: fechaNacimiento.date)
            self.view.endEditing(true)
        
        let newName : String = nombreUsuario.text!
        
        let newPass : String = contraUsuario.text!
        
        let postUser: [String : Any] = [
            "contrasena" : newPass,
            "fechaDeNacimiento" : dateString,
            "nombre" : newName
        ]
        print(postUser)
        
        let url = URL(string: "http://127.0.0.1:5000/api/usuario")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postUser, options: .prettyPrinted)
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
                let responseObject = try JSONDecoder().decode(ResponseObject<Usuario>.self, from: data)
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
            performSegue(withIdentifier: "volverAlLogin", sender: (Any).self)
        }
    }
    

