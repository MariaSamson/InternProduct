//
//  ViewController.swift
//  FinalProject
//
//  Created by Maria Andreea on 11.03.2022.
//

import UIKit


class ProductsViewController: UIViewController {

    static var sendersMessage: Double = Double()

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var passMustMatch: UILabel!

    @IBAction func registerButton(_ sender: Any) {
        passMustMatch.isHidden = true
        let username : String? = user.text
        let password : String? = pass.text
        let confirmPassword : String? = confirm.text

        if checkPasswords(password!, confirmPassword!) {
                   passMustMatch.isHidden = false}

        if passwordsMatch(password!, confirmPassword!){
             let url = URL(string: "http://localhost:8080/register?username=\(username!)&password=\(password!)")
             guard let requestUrl = url else { fatalError() }
             var request = URLRequest(url: requestUrl)
             request.httpMethod = "GET"
             let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                  if let error = error {
                      print("Error took place \(error)")
                      return
                  }
                  if let data = data, let dataString = String(data: data, encoding: .utf8) {
                       print("Response data string:\n \(dataString)")
                       let dict = self.convertToDictionary(text: dataString)
                       let loginT = dict?["loginToken"]
                       let response = dict?["status"]
                       if response as! String == "FAILED" {
                           DispatchQueue.main.async {
                               self.alertUserExist()
                           }
                       }else if response as! String == "SUCCESS"{
                           ProductsViewController.sendersMessage = Double(loginT as! Substring) ?? 0.0
                           DispatchQueue.main.async {
                               self.performSegue(withIdentifier: "ShowProducts", sender: self)
                           }
                       }
                  }
             }
          task.resume()
        }
    }


    @IBAction func loginButton(_ sender: Any) {
        let username : String? = username.text
        let password : String? = password.text
        let url = URL(string: "http://localhost:8080/login?username=\(username!)&password=\(password!)")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    let dict = self.convertToDictionary(text: dataString)
                    let loginT = dict?["loginToken"]
                    let response = dict?["status"]
                    let message = dict?["message"]

                    if response as! String == "SUCCESS"{
                        ProductsViewController.sendersMessage = Double(loginT as! Substring) ?? 0.0
                        DispatchQueue.main.async {
                            performSegue(withIdentifier: "ShowProducts", sender: self)
                        }
                    }
                    else if response as! String == "FAILED" && message as! String == "No such user with username: \(username!)"{
                        DispatchQueue.main.async {
                        alertUser(name : username!)
                        }
                    }
                    else if response as! String == "FAILED" && message as! String != "No such user with username: \(username!)" {
                        DispatchQueue.main.async {
                          alertPassword()
                        }
                    }
                }
        }
        task.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func alertUserExist(){
        let dialogMessage = UIAlertController(title: "", message: "Username already used", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

    func alertPassword(){
        let dialogMessage = UIAlertController(title: "", message: "Passwords mismatch!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    func alertUser(name: String){
        let dialogMessage = UIAlertController(title: "", message: "No such user with username : \(name)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }


    func checkPasswords(_ firstTextField: String, _ secondTextField : String) -> Bool{
           if firstTextField == secondTextField {
               return false
           }
          return true
      }

    func passwordsMatch(_ firstTextField: String, _ secondTextField : String) -> Bool{
        if firstTextField == secondTextField{
            return true
        }
        return false
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
