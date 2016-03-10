//
//  InicioViewController.swift
//  Club de Recompensas
//
//  Created by Roberto Gutierrez on 17/11/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet var nombreClienteLabel: UILabel!
    @IBOutlet var logoutBoton: UIBarButtonItem!
    @IBOutlet var vistaAdeudo: UIView!
    @IBOutlet var encabezadoResidencial: UIImageView!
    @IBOutlet var introduccionLabel: UILabel!
    
    
    // VARIABLES
    var id_usuario: String!
    var id_residencial: String!
    var id_condominio: String!
    var categoria: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Texto Introduccion
        if (self.view.frame.size.width == 320){
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            introduccionLabel.font = UIFont(name: "GothamBook", size: 9)
            nombreClienteLabel.font = UIFont(name: "GothamBold", size: 13)
        }
        else if (self.view.frame.size.width == 375){
            //iPhone 6
            introduccionLabel.font = UIFont(name: "GothamBook", size: 15)
            nombreClienteLabel.font = UIFont(name: "GothamBold", size: 19)
        }
        else if (self.view.frame.size.width == 414){
            //iPhone 6 Plus
            introduccionLabel.font = UIFont(name: "GothamBook", size: 19)
            nombreClienteLabel.font = UIFont(name: "GothamBold", size: 24)
        }
        
        // Texto backbutton
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton

        
        // Imagen navigation controller
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo-cabeza")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationItem.titleView!.sizeThatFits(CGSize(width: 320, height: 65))
        
        // Logout boton
        if let font = UIFont(name: "Helvetica", size: 13) {
            logoutBoton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        // Nombre de cliente
        nombreClienteLabel.text = "¡Bienvenido " + (NSUserDefaults.standardUserDefaults().objectForKey("nombre") as? String)! + "!"
        
        // id de usuario
        let id = NSUserDefaults.standardUserDefaults().objectForKey("id_usuario")
        id_usuario = id as! String
        print("Su id usuario es " +  id_usuario)
        
        // id de residencial
        let id_residencia = NSUserDefaults.standardUserDefaults().objectForKey("id_residencial")
        id_residencial = id_residencia as! String
        print("Su id residencial es " + id_residencial)
        
        // id de condominio
        let condominio = NSUserDefaults.standardUserDefaults().objectForKey("id_condominio")
        id_condominio = condominio as! String
        print("Su id condominio es " + id_condominio)
        
        
        // Asignar imagen de encabezado segun residencial
        if id_residencial == "1"{
            encabezadoResidencial.image = UIImage(named: "encabezado-qro")
        } else if id_residencial == "2" {
            encabezadoResidencial.image = UIImage(named: "encabezado-montana")
        } else if id_residencial == "3" {
            encabezadoResidencial.image = UIImage(named: "encabezado-leon")
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "encabezado-azul")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func educacionBoton(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Estas conectado a Internet")
            categoria = "2"
            self.performSegueWithIdentifier("sociosSegue", sender: self)
            
        } else {
            
            print("La conexion a Internet falló")
            let alert = UIAlertView(title: "No hay conexion a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }

    }
    
    @IBAction func RestaurantesBoton(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Estas conectado a Internet")
            categoria = "1"
            self.performSegueWithIdentifier("sociosSegue", sender: self)
            
        }  else {
            
            print("La conexion a Internet falló")
            let alert = UIAlertView(title: "No hay conexion a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }


    }
    
    @IBAction func saludBoton(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Estas conectado a Internet")
            categoria = "3"
            self.performSegueWithIdentifier("sociosSegue", sender: self)
            
        }  else {
            
            print("La conexion a Internet falló")
            let alert = UIAlertView(title: "No hay conexion a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }

    }

    @IBAction func decoracionBoton(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Estas conectado a Internet")
            categoria = "5"
            self.performSegueWithIdentifier("sociosSegue", sender: self)
            
        }  else {
            
            print("La conexion a Internet falló")
            let alert = UIAlertView(title: "No hay conexion a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }

    }
    
    
    @IBAction func eventosBoton(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Estas conectado a Internet")
            categoria = "4"
            self.performSegueWithIdentifier("sociosSegue", sender: self)
            
        }  else {
            
            print("La conexion a Internet falló")
            let alert = UIAlertView(title: "No hay conexion a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }

    }
    
    
    @IBAction func serviciosBoton(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Estas conectado a Internet")
            categoria = "6"
            self.performSegueWithIdentifier("sociosSegue", sender: self)

            
        } else {
            
            print("La conexion a Internet falló")
            let alert = UIAlertView(title: "No hay conexion a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }

    }
    
    @IBAction func contactoBoton(sender: AnyObject) {
        
    }
    
    @IBAction func logoutBotonPresionado(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("nombre")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("id_tarjeta")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("id_usuario")
        self.performSegueWithIdentifier("logoutSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sociosSegue" {
            let destinoVC = segue.destinationViewController as! RestaurantesViewController
            destinoVC.categoria = categoria
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
