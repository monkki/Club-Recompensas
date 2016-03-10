//
//  ViewController.swift
//  clubderecompensas
//
//  Created by Roberto Gutierrez on 16/11/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // OUTLETS
    @IBOutlet var vistaAdeudo: UIView!
    @IBOutlet var nombreTextfield: UITextField!
    @IBOutlet var correoTextfield: UITextField!
    @IBOutlet var clave1Textfield: UITextField!
    @IBOutlet var clave2Textfield: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var toggleBoton: UIButton!
    @IBOutlet var nombreLabel: UILabel!
    @IBOutlet var correoLabel: UILabel!
    @IBOutlet var claveLabel: UILabel!
    @IBOutlet var separadorLabel: UILabel!
    
    var estatusRegistro: Bool!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreTextfield.delegate = self
        correoTextfield.delegate = self
        clave1Textfield.delegate = self
        clave2Textfield.delegate = self
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 1500)
        vistaAdeudo.transform = CGAffineTransformConcat(scale, translate)
        
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        loginButton.setTitle("Login", forState: UIControlState.Normal)
        toggleBoton.setTitle("Registrar", forState: UIControlState.Normal)
        nombreLabel.transform = CGAffineTransformConcat(scale, translate)
        nombreTextfield.transform = CGAffineTransformConcat(scale, translate)
        
        estatusRegistro = false
        nombreTextfield.enabled = false
        
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if let nombre = NSUserDefaults.standardUserDefaults().objectForKey("nombre") as? String {
            self.performSegueWithIdentifier("inicioSegue", sender: self)
            print(nombre)
        }
    }


    @IBAction func login(sender: AnyObject) {
        
        let nombre = nombreTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let correo = correoTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
        let clave = clave1Textfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString + "-" + clave2Textfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString;
        
        if estatusRegistro == true {
        
                //  self.performSegueWithIdentifier("inicioSegue", sender: self)
        
            if Reachability.isConnectedToNetwork() == true {
                //print("Estas conectado a Internet")
            
                if(nombre == "" || correo == "" || clave == "" ){
                
                    mostrarMensaje("Favor de completar los datos!", titulo: "Club de Recompensas")
                
                } else if(!isValidEmail(correo)) {
                
                    mostrarMensaje("Favor de escribir un correo válido!", titulo: "Club de Recompensas")
                
                } else {
                
                    // Iniciar Loader
                    JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
                    validateRegistro(nombre,correo: correo, clave: clave)
                
                }
            
            
            } else {
            
                print("La conexion a Internet falló")
                let alert = UIAlertView(title: "No hay conexión a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            
            }
            
        } else {
            
            if Reachability.isConnectedToNetwork() == true {
                //print("Estas conectado a Internet")
                
                if(correo == "" || clave == "" ){
                    
                    mostrarMensaje("Favor de completar los datos!", titulo: "Club de Recompensas")
                    
                } else if(!isValidEmail(correo)) {
                    
                    mostrarMensaje("Favor de escribir un correo válido!", titulo: "Club de Recompensas")
                    
                } else {
                    
                    // Iniciar Loader
                    JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
                    validateLogin( correo , clave: clave)
                }
                
                
            } else {
                
                print("La conexion a Internet falló")
                let alert = UIAlertView(title: "No hay conexión a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
            }
            
        }
        
    }
    
    func validateRegistro( var nombre: String, var correo: String, var clave: String ) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        nombre = nombre.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        correo = correo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        clave = clave.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://quierotaxiservicios.dctimx.com/club_cm/registro.php?clave=" + clave + "&nombre=" + nombre + "&correo=" + correo
        
        let url = NSURL(string: urlString)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            
            if (error != nil) {
                
                print(error!.localizedDescription)
                
            }
            do {
                
                if let data = data {
                
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                
                    print(jsonResult[0])
                
                    let aux_exito: String! = jsonResult[0]["success"] as! NSString as String
                    let mensaje: String! = jsonResult[0]["mensaje"] as! NSString as String
                
                
                
                    if(aux_exito == "1"){
                    
                        dispatch_async(dispatch_get_main_queue(), {
                        
                            let alertView_usuario_incorrecto = UIAlertController(title: "Club de Recompensas", message: mensaje, preferredStyle: .Alert)
                        
                            alertView_usuario_incorrecto.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: { (alertAction) -> Void in
                                
                                JHProgressHUD.sharedHUD.hide()
                            
                                self.performSegueWithIdentifier("inicioSegue", sender: self)
                            
                                let id_tarjeta: String! = jsonResult[0]["id_tarjeta"] as! NSString as String
                                let id_usuario: String! = jsonResult[0]["id_usuario"] as! NSString as String
                                let id_residencial: String! = jsonResult[0]["id_residencial"] as! NSString as String
                                let id_condominio: String! = jsonResult[0]["id_condominio"] as! NSString as String
                                let nombre: String! = jsonResult[0]["nombre"] as! NSString as String
                            
                                prefs.setObject(id_tarjeta, forKey: "id_tarjeta")
                                prefs.setObject(id_usuario, forKey: "id_usuario")
                                prefs.setObject(id_residencial, forKey: "id_residencial")
                                prefs.setObject(id_condominio, forKey: "id_condominio")
                                prefs.setObject(nombre, forKey: "nombre")
                                prefs.synchronize();
                                                        
                            }))
                        
                            self.presentViewController(alertView_usuario_incorrecto, animated: true, completion: nil)
                        
                        })
                    
                    } else if(aux_exito == "2") {
                    
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            JHProgressHUD.sharedHUD.hide()
                            self.mostrarMensaje(mensaje, titulo:"Club de Recompensas")
                        })
                    
                    } else if(aux_exito == "3") {
                    
                      dispatch_async(dispatch_get_main_queue(), {
                        
                          UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                            
                                JHProgressHUD.sharedHUD.hide()
                            
                                let scale = CGAffineTransformMakeScale(1, 1)
                            
                                let translate = CGAffineTransformMakeTranslation(0, 0)
                            
                                self.vistaAdeudo.transform = CGAffineTransformConcat(scale, translate)
                            
                              }, completion: nil)
                        
                      })
                    
                    }
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let alert = UIAlertView(title: "No hay respuesta del servidor", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    })
                    
                }
                
            }catch {
                
                print(error)
                
            }
            
        })
        
        jsonQuery.resume()
        
    }

    
    func validateLogin( var correo: String, var clave: String ) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        correo = correo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        clave = clave.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let login = Urls()
        let loginUrl = login.getUrlLogin(clave, correo: correo)
        
        let url = NSURL(string: loginUrl)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            
            if (error != nil) {
                
                print(error!.localizedDescription)
                
            }
            do {
                
                if let data = data {
                    
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                    
                    print(jsonResult[0])
                    
                    let aux_exito: String! = jsonResult[0]["success"] as! NSString as String
                    let mensaje: String! = jsonResult[0]["mensaje"] as! NSString as String
                    
                    
                    
                    
                    if(aux_exito == "1"){
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let alertView_usuario_incorrecto = UIAlertController(title: "Club de Recompensas", message: mensaje, preferredStyle: .Alert)
                            
                            alertView_usuario_incorrecto.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: { (alertAction) -> Void in
                                
                                JHProgressHUD.sharedHUD.hide()
                                
                                self.performSegueWithIdentifier("inicioSegue", sender: self)
                                
                                let id_tarjeta: String! = jsonResult[0]["id_tarjeta"] as! NSString as String
                                let id_usuario: String! = jsonResult[0]["id_usuario"] as! NSString as String
                                let id_residencial: String! = jsonResult[0]["id_residencial"] as! NSString as String
                                let id_condominio: String! = jsonResult[0]["id_condominio"] as! NSString as String
                                let nombre: String! = jsonResult[0]["nombre"] as! NSString as String
                                
                                prefs.setObject(id_tarjeta, forKey: "id_tarjeta")
                                prefs.setObject(id_usuario, forKey: "id_usuario")
                                prefs.setObject(id_residencial, forKey: "id_residencial")
                                prefs.setObject(id_condominio, forKey: "id_condominio")
                                prefs.setObject(nombre, forKey: "nombre")
                                prefs.synchronize();
                                
                            }))
                            
                            self.presentViewController(alertView_usuario_incorrecto, animated: true, completion: nil)
                            
                        })
                        
                    } else if(aux_exito == "2") {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            JHProgressHUD.sharedHUD.hide()
                            self.mostrarMensaje(mensaje, titulo:"Club de Recompensas")
                        })
                        
                    } else if(aux_exito == "0") {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            JHProgressHUD.sharedHUD.hide()
                            self.mostrarMensaje(mensaje, titulo:"Club de Recompensas")
                        })
                        
                    }  else if(aux_exito == "3") {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                                
                                JHProgressHUD.sharedHUD.hide()
                                
                                let scale = CGAffineTransformMakeScale(1, 1)
                                
                                let translate = CGAffineTransformMakeTranslation(0, 0)
                                
                                self.vistaAdeudo.transform = CGAffineTransformConcat(scale, translate)
                                
                                }, completion: nil)
                            
                        })
                        
                    }

                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let alert = UIAlertView(title: "No hay respuesta del servidor", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    })
                    
                }
                
            } catch {
                
                print(error)
                
            }
            
        })
        
        jsonQuery.resume()
        
    }

    
    
    
    func mostrarMensaje(mensaje: String, titulo: String){
        
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(testStr)
        
    }
    
    
    @IBAction func cancelar(sender: AnyObject) {
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 1500)
        vistaAdeudo.transform = CGAffineTransformConcat(scale, translate)
        
    }

    @IBAction func verAdeudos(sender: AnyObject) {
        
        
    }
    
    @IBAction func toggleBotonPresionado(sender: AnyObject) {
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        
        if estatusRegistro == true {
            
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            toggleBoton.setTitle("Registrar", forState: UIControlState.Normal)
            
            nombreLabel.transform = CGAffineTransformConcat(scale, translate)
            nombreTextfield.transform = CGAffineTransformConcat(scale, translate)
            correoLabel.transform = CGAffineTransformConcat(scale, translate)
            correoTextfield.transform = CGAffineTransformConcat(scale, translate)
            claveLabel.transform = CGAffineTransformConcat(scale, translate)
            clave1Textfield.transform = CGAffineTransformConcat(scale, translate)
            separadorLabel.transform = CGAffineTransformConcat(scale, translate)
            clave2Textfield.transform = CGAffineTransformConcat(scale, translate)
            loginButton.transform = CGAffineTransformConcat(scale, translate)
            
            UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.correoLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.correoTextfield.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.claveLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.clave1Textfield.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.9, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.separadorLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)

            
            UIView.animateWithDuration(0.8, delay: 1.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.clave2Textfield.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.loginButton.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            nombreTextfield.enabled = false
            estatusRegistro = false
            
            
        } else {
            
            loginButton.setTitle("Registrar", forState: UIControlState.Normal)
            toggleBoton.setTitle("Login", forState: UIControlState.Normal)
            
            nombreLabel.transform = CGAffineTransformConcat(scale, translate)
            nombreTextfield.transform = CGAffineTransformConcat(scale, translate)
            correoLabel.transform = CGAffineTransformConcat(scale, translate)
            correoTextfield.transform = CGAffineTransformConcat(scale, translate)
            claveLabel.transform = CGAffineTransformConcat(scale, translate)
            clave1Textfield.transform = CGAffineTransformConcat(scale, translate)
            separadorLabel.transform = CGAffineTransformConcat(scale, translate)
            clave2Textfield.transform = CGAffineTransformConcat(scale, translate)
            loginButton.transform = CGAffineTransformConcat(scale, translate)
            
            
            UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.nombreLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.nombreTextfield.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.correoLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.correoTextfield.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 0.9, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.claveLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 1.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.clave1Textfield.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.separadorLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 1.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.clave2Textfield.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, delay: 1.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.loginButton.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)
            
            nombreTextfield.enabled = true
            estatusRegistro = true

        }
        
    }
    

}

