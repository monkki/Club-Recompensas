//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by Olga Dalton on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    // ARRAY DE ENCABEZADOS
    var encabezadosArray = ["enc-contacto", "enc-escuelas", "enc-eventos", "enc-hogar", "enc-restaurantes", "enc-salud", "enc-servicios"]
    
    // VALORES RECIBIDOS DEL VIEW ANTERIOR
    var descripcionRecibida: String!
    var direccionRecibida: String!
    var estatusRecibido: String!
    var idSocioRecibido: String!
    var nombreRecibido: String!
    var telefonoRecibido: String!
    var webRecibido: String!
    var categoriaRecibido: String!
    
    // OUTLETS
    @IBOutlet var imagenPromocion: UIImageView!
    @IBOutlet var nombreRestaurant: UILabel!
    @IBOutlet var restaurateTipo: UILabel!
    @IBOutlet var promocionEncabezadoLabel: UILabel!
    @IBOutlet var promocionLabel: UILabel!
    @IBOutlet var telefonoBoton: UIButton!
    @IBOutlet var webBoton: UIButton!
    @IBOutlet var direccionLabel: UILabel!
    @IBOutlet var validezLabel: UILabel!
    @IBOutlet var encabezadoImageView: UIImageView!
    @IBOutlet var codigoTextfield: UITextField!
    @IBOutlet var cantidadPromos: UILabel!
    
    //@IBOutlet var contentImageView: UIImageView?
    @IBOutlet var label: UILabel!
    
    // IDS
    let idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("id_usuario") as! String
    let idTarjeta = NSUserDefaults.standardUserDefaults().objectForKey("id_tarjeta") as! String
    let idResidencial = NSUserDefaults.standardUserDefaults().objectForKey("id_residencial") as! String
    let idCondominio = NSUserDefaults.standardUserDefaults().objectForKey("id_condominio") as! String
    
    // ARRAYs
    var idSociosArray = [String]()
    var idPromocionArray = [String]()
    var nombrePromoArray = [String]()
    var imagenArray = [String]()
    var descripcionArray = [String]()
    var imagenesUIImages = [UIImage]()
    var cantidadArray = [String]()
    var destacadoArray = [String]()
    var validoArray = [String]()
    
    // VALORES RECIBIDOS PROMO
    var nombrePromo = String()
    var descripcionPromo = String()
    var validezPromo = String()
    var cantidad = String()
    var idSocio = String()
    var idPromocion = String()
    var esDestacado = String()

    
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName = UIImage() {
        
        didSet {
            
            if let imageView = imagenPromocion {
                imageView.image = imageName
            }
            
        }
    }
    
    var label1: String = "" {
        
        didSet {
            
            if let textoLabel = label {
                textoLabel.text = label1
            }
            
        }
    }

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.view.frame.size.width == 320){
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            imagenPromocion.contentMode = UIViewContentMode.ScaleToFill
        }
        else if (self.view.frame.size.width == 375){
            //iPhone 6
            imagenPromocion.contentMode = UIViewContentMode.ScaleAspectFill
        }
        else if (self.view.frame.size.width == 414){
            //iPhone 6 Plus
            imagenPromocion.contentMode = UIViewContentMode.ScaleAspectFill
        }

        
        imagenPromocion!.image = imageName

        
        // Asignar imagen encabezado
        asignarEncabezado(categoriaRecibido)
        
        // Asignar valores recibido a outlets
        //nombreRestaurant.text = nombreRecibido
        telefonoBoton.setTitle(telefonoRecibido, forState: UIControlState.Normal)
        webBoton.setTitle(webRecibido, forState: UIControlState.Normal)
        direccionLabel.text = direccionRecibida
        restaurateTipo.text = descripcionRecibida
        
        // Asignar valores recibidos en Promos
        self.promocionEncabezadoLabel.text = nombrePromo
        self.promocionLabel.text = descripcionPromo
        self.validezLabel.text = "Válido del " + validezPromo
        self.cantidadPromos.text = cantidad
        
        // Animacion del label promocion
        if esDestacado == "3" {
            
            let scale = CGAffineTransformMakeScale(0.0, 0.0)
            let translate = CGAffineTransformMakeTranslation(0, -600)
            self.promocionEncabezadoLabel.transform = CGAffineTransformConcat(scale, translate)
            self.promocionEncabezadoLabel.font = self.promocionEncabezadoLabel.font.fontWithSize(18)
            
            UIView.animateWithDuration(1.0, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                let scale = CGAffineTransformMakeScale(1, 1)
                
                let translate = CGAffineTransformMakeTranslation(0, 0)
                
                self.promocionEncabezadoLabel.transform = CGAffineTransformConcat(scale, translate)
                
                }, completion: nil)

        }
    }
    
    func asignarEncabezado(categoria: String) {
        
        switch categoria {
        case "1":
            encabezadoImageView.image = UIImage(named: self.encabezadosArray[4])
        case "2":
            encabezadoImageView.image = UIImage(named: self.encabezadosArray[1])
        case "3":
            encabezadoImageView.image = UIImage(named: self.encabezadosArray[5])
        case "4":
            encabezadoImageView.image = UIImage(named: self.encabezadosArray[2])
        case "5":
            encabezadoImageView.image = UIImage(named: self.encabezadosArray[3])
        case "6":
            encabezadoImageView.image = UIImage(named: self.encabezadosArray[6])
        default:
            break
        }
        
    }
    
    
    func obtenerJsonBotonPromos() {
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando Promo", andFooter: "Por favor espere...")
        
        var jsonMensaje = ""
        var jsonCantidad = ""
        var jsonCodigo = ""
        
        let urlString = Urls()
        
        let g = urlString.getCodigoPromociones(idResidencial, id_condominio: idCondominio, id_tarjeta: idTarjeta, id_Categoria: categoriaRecibido, id_socio: idSocio, id_usuario: idUsuario, id_promocion: idPromocion)
        
        let url = NSURL(string: g)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                } else {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                        
                        print(jsonResponse[0])
                        let aux_exito: String! = jsonResponse[0]["success"] as! NSString as String
                        jsonMensaje = jsonResponse[0]["mensaje"] as! NSString as String
                        
                        if(aux_exito == "1"){
                            
                            
                            jsonCantidad = jsonResponse[0]["cantidad"] as! NSString as String
                            jsonCodigo = jsonResponse[0]["codigo"] as! NSString as String
                            
                            print(jsonMensaje)
                            print(jsonCantidad)
                            print(jsonCodigo)
                            
                            
                        } else if(aux_exito == "2"){
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.mostrarMensaje(jsonMensaje, titulo:"No hay promociones")
                            })
                            
                        } else if(aux_exito == "0"){
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.mostrarMensaje(jsonMensaje, titulo:"Promociones")
                            })
                            
                        }
                        
                        
                    } catch {}
                    
                    
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let mostrarCodigo = self.codigoTextfield {
                        mostrarCodigo.text = jsonCodigo
                    }
                    
                    if let promoTextfield = self.cantidadPromos {
                        promoTextfield.text = jsonCantidad
                    }
                    
                    JHProgressHUD.sharedHUD.hide()
                })
            }
            task.resume()
            
        }
        
    }
    
    
    @IBAction func obtenerPromo(sender: AnyObject) {
        
        obtenerJsonBotonPromos()
    }
    
    
    func mostrarMensaje(mensaje: String, titulo: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    @IBAction func llamarBoton(sender: AnyObject) {
        
//        if let telefonoRecibido = telefonoRecibido {
//            let url:NSURL = NSURL(string: "telprompt://\(telefonoRecibido)")!
//            UIApplication.sharedApplication().openURL(url)
//        }
    }
    
    @IBAction func webViewBoton(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Estas conectado a Internet")
            
            self.performSegueWithIdentifier("webViewSegue", sender: self)
            
        }  else {
            
            print("La conexion a Internet falló")
            let alert = UIAlertView(title: "No hay conexión a Internet", message: "Asegurese que su dispositivo este conectado a Internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "webViewSegue" {
            let destinoVC = segue.destinationViewController as? WebViewController
            destinoVC?.webRecibida = webRecibido
        }
        
    }


    
}
