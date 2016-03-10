//
//  RestaurantesViewController.swift
//  Club de Recompensas
//
//  Created by Doctor on 11/17/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class RestaurantesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // ARRAYS
    var descripcionArray = [String]()
    var direccionArray = [String]()
    var idsArray = [String]()
    var imagenArray = [String]()
    var nombreArray = [String]()
    var telefonoArray = [String]()
    var webArray = [String]()
    var ciudadArray = [String]()
    var idsResidencialArray = [String]()
    
    // VARIABLES
    var imagenesUIImages = [UIImage]()
    var categoria: String!
    var id_tarjeta: String!
    var id_residencial: String!
    
    //OUTLETS
    @IBOutlet var collectionVista: UICollectionView!
    @IBOutlet var encabezadoImagen: UIImageView!
    @IBOutlet var vistaAdeudo: UIView!
    
    
    // ARRAY DE ENCABEZADOS
    var encabezadosArray = ["enc-contacto", "enc-escuelas", "enc-eventos", "enc-hogar", "enc-restaurantes", "enc-salud", "enc-servicios"]
    
    // IDS
    let idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("id_usuario") as! String
    let idTarjeta = NSUserDefaults.standardUserDefaults().objectForKey("id_tarjeta") as! String
    let idResidencial = NSUserDefaults.standardUserDefaults().objectForKey("id_residencial") as! String
    let idCondominio = NSUserDefaults.standardUserDefaults().objectForKey("id_condominio") as! String
    
    // INDEX
    var index: Int!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo-cabeza")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationItem.titleView!.sizeThatFits(CGSize(width: 320, height: 65))
        
        self.collectionVista.backgroundColor = UIColor.clearColor()
        self.collectionVista.delegate = self
        self.collectionVista.dataSource = self
        
        print("La categoria es \(categoria)")
        asignarEncabezado(categoria)
        
        let id = NSUserDefaults.standardUserDefaults().objectForKey("id_tarjeta")
        id_tarjeta = id as! String
        
        print("id de tarjeta: \(id_tarjeta)")
        
        let id_res = NSUserDefaults.standardUserDefaults().objectForKey("id_residencial")
        id_residencial = id_res as! String
        
        print("id de residencial: \(id_residencial)")
        
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 1500)
        vistaAdeudo.transform = CGAffineTransformConcat(scale, translate)
        
        obtenerJson()
    }
    
    func obtenerJson() {
        
       // let url = NSURL(string: "http://quierotaxiservicios.dctimx.com/club_cm/get_socios.php?id_residencial=" + id_residencial + "&id_condominio=" + idCondominio + "&id_tarjeta=" + idTarjeta + "&id_categoria=" + categoria)
        
        let urls = Urls()
        
        let urlString = urls.getUrlSocios(idResidencial, id_condominio: idCondominio, id_tarjeta: idTarjeta, id_categoria: categoria)
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                } else {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                        
                         print(jsonResponse[0])
                        let aux_exito: String! = jsonResponse[0]["success"] as! NSString as String
                        print(aux_exito)
                        
                        if(aux_exito == "1"){
                    
                            let jsonResult = jsonResponse[0]["socios"] as? NSMutableArray
                            
                            let respuestaJson = jsonResult! as NSMutableArray
                            
                            // print(respuestaJson)
                        
                            for json in respuestaJson {
                            
                            
                                let descripcion = json["descripcion"] as! String
                                let direccion = json["direccion"] as! String
                                let idSocio = json["id_socio"] as! String
                                let imagen = json["image"] as! String
                                let nombre = json["nombre"] as! String
                                let telefono = json["telefono"] as! String
                                let web = json["web"] as! String
                                let ciudad = json["ciudad"] as! String
                                let idResidencialPromo = json["id_residencial"] as! String
                            
                                self.descripcionArray.append(descripcion)
                                self.direccionArray.append(direccion)
                                self.idsArray.append(idSocio)
                                self.imagenArray.append(imagen)
                                self.nombreArray.append(nombre)
                                self.telefonoArray.append(telefono)
                                self.webArray.append(web)
                                self.ciudadArray.append(ciudad)
                                self.idsResidencialArray.append(idResidencialPromo)
                    
                            }
                    
                        } else if(aux_exito == "2"){
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.mostrarMensaje("No se encuentran establecimientos en esta categoria", titulo:"Club de Recompensas")
                            })
                            
                        } else if(aux_exito == "0"){
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.mostrarMensaje("Intente nuevamente mas tarde", titulo:"Error al obtener datos")
                            })
                            
                        } else if(aux_exito == "3") {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                                    
                                    let scale = CGAffineTransformMakeScale(1, 1)
                                    
                                    let translate = CGAffineTransformMakeTranslation(0, 0)
                                    
                                    self.vistaAdeudo.transform = CGAffineTransformConcat(scale, translate)
                                    
                                    }, completion: nil)
                                
                            })

                            
                        }
                        
                        
                    
                    
                    } catch {}
                    
                   dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                        for imagenes in self.imagenArray {
                        
                            let decodedData = NSData(base64EncodedString: imagenes, options: NSDataBase64DecodingOptions(rawValue: 0))
                            let decodedimage = UIImage(data: decodedData!)
                        
                            if let decodedImagen = decodedimage {
                                self.imagenesUIImages.append(decodedImagen)
                            }
                        
                        }
                    
                    })
                    
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionVista.reloadData()
                    JHProgressHUD.sharedHUD.hide()
                })
            }
            task.resume()
            
        }
        
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nombreArray.count
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var anchoCelda = 0
        var altoCelda = 0
        
        if (self.view.frame.size.width == 320){
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            anchoCelda = 150
            altoCelda = 177
        }
        else if (self.view.frame.size.width == 375){
            //iPhone 6
            anchoCelda = 175
            altoCelda = 202
        }
        else if (self.view.frame.size.width == 414){
            //iPhone 6 Plus
            anchoCelda = 195
            altoCelda = 222
        } else if (self.view.frame.size.width > 414){
            //iPad
            anchoCelda = 345
            altoCelda = 372
        }

        return CGSize(width: anchoCelda, height: altoCelda)
    }
   
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
    
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if self.imagenesUIImages.count > 0 {
                
                cell.imagen.image = self.imagenesUIImages[indexPath.row]
                cell.nombre.text = self.nombreArray[indexPath.row]
                cell.tipoLabel.text = self.descripcionArray[indexPath.row]
                cell.ciudadLabel.text = self.ciudadArray[indexPath.row]
                
            }
            
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        index = indexPath.row
        
        if idResidencial == idsResidencialArray[indexPath.row] {
            
            self.performSegueWithIdentifier("detalleSegue", sender: self)
            
        } else {
            
            self.mostrarMensaje("Esta promoción no aplica para su residencial", titulo: "Club de Recompensas")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detalleSegue" {
            
                let destinoVC = segue.destinationViewController as! DetalleViewController
                destinoVC.nombreRecibido = nombreArray[index]
                destinoVC.descripcionRecibida = descripcionArray[index]
                destinoVC.direccionRecibida = direccionArray[index]
                destinoVC.idSocioRecibido = idsArray[index]
                destinoVC.telefonoRecibido = telefonoArray[index]
                destinoVC.webRecibido = webArray[index]
                destinoVC.categoriaRecibido = categoria
                destinoVC.idCondominioRecibido = idCondominio
                
                //destinoVC.imagenPasada = imagenesUIImages[indexPath.row]
            
            
        }
    }
    
    func mostrarMensaje(mensaje: String, titulo: String){
        
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    func asignarEncabezado(categoria: String) {
        
        switch categoria {
        case "1":
            encabezadoImagen.image = UIImage(named: self.encabezadosArray[4])
        case "2":
            encabezadoImagen.image = UIImage(named: self.encabezadosArray[1])
        case "3":
            encabezadoImagen.image = UIImage(named: self.encabezadosArray[5])
        case "4":
            encabezadoImagen.image = UIImage(named: self.encabezadosArray[2])
        case "5":
            encabezadoImagen.image = UIImage(named: self.encabezadosArray[3])
        case "6":
            encabezadoImagen.image = UIImage(named: self.encabezadosArray[6])
        default:
            break
        }
        
    }

    @IBAction func aceptarVistaAdeudo(sender: AnyObject) {
        
        self.performSegueWithIdentifier("AtrasSegue", sender: self)
        
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
