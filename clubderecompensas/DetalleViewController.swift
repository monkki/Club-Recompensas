//
//  DetalleViewController.swift
//  Club de Recompensas
//
//  Created by Doctor on 11/17/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController, UIPageViewControllerDataSource {
    
    // VALORES RECIBIDOS DEL VIEW ANTERIOR
    var descripcionRecibida: String!
    var direccionRecibida: String!
    var estatusRecibido: String!
    var idSocioRecibido: String!
    var nombreRecibido: String!
    var telefonoRecibido: String!
    var webRecibido: String!
    var categoriaRecibido: String!
    var idCondominioRecibido: String!
    
    
    // ARRAYS
    var idSociosArray = [String]()
    var idPromocionArray = [String]()
    var nombrePromoArray = [String]()
    var imagenArray = [String]()
    var descripcionArray = [String]()
    var imagenesUIImages = [UIImage]()
    var cantidadArray = [String]()
    var destacadoArray = [String]()
    var validoArray = [String]()
    
    // ARRAY DE ENCABEZADOS
    var encabezadosArray = ["enc-contacto", "enc-escuelas", "enc-eventos", "enc-hogar", "enc-restaurantes", "enc-salud", "enc-servicios"]
    
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
    @IBOutlet var vistaAdeudo: UIView!

    
    // IDS
    let idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("id_usuario") as! String
    let idTarjeta = NSUserDefaults.standardUserDefaults().objectForKey("id_tarjeta") as! String
    let idResidencial = NSUserDefaults.standardUserDefaults().objectForKey("id_residencial") as! String
    
    
    // VARIABLES PAGE VIEW CONTROLLER
    private var pageViewController: UIPageViewController?
    var contentImages:[UIImage] = []
    var cantidad: [String] = []
     

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Texto backbutton
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        // Imagen encabezado
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo-cabeza")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationItem.titleView!.sizeThatFits(CGSize(width: 320, height: 65))
        
        // Obtener promos
        obtenerJson()
        
        // Customizar Page Control
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func obtenerJson() {
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
        
        let urls = Urls()
        
        let urlString = urls.getUrlPromociones(categoriaRecibido, id_residencial: idResidencial, id_condominio: idCondominioRecibido, id_tarjeta: idTarjeta, id_socio: idSocioRecibido)
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                } else {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                        
                        // print(jsonResponse[0])
                        let aux_exito: String! = jsonResponse[0]["success"] as! NSString as String
                        print(aux_exito)
                        
                        if(aux_exito == "1"){
                            
                            let jsonResult = jsonResponse[0]["mensaje"] as? NSMutableArray
                            
                            let respuestaJson = jsonResult! as NSMutableArray
                           // print(respuestaJson)
                            
                            for json in respuestaJson {
                                
                                let cantidad = json["cantidad"] as! String
                                let descripcion = json["descripcion"] as! String
                                let destacado = json["destacado"] as! String
                                let valido = json["fecha"] as! String
                                let id_promocion = json["id_promocion"] as! String
                                //let id_socio = json["id_socio"] as! String
                                let imagen = json["imagen"] as! String
                                let nombrePromo = json["nombre"] as! String
                                
                                
                                self.cantidadArray.append(cantidad)
                                self.descripcionArray.append(descripcion)
                                self.destacadoArray.append(destacado)
                                self.validoArray.append(valido)
                                self.idPromocionArray.append(id_promocion)
                               // self.idSociosArray.append(id_socio)
                                self.imagenArray.append(imagen)
                                self.nombrePromoArray.append(nombrePromo)
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                for imagenes in self.imagenArray {
                                    
                                    if let decodedData = NSData(base64EncodedString: imagenes, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                                        
                                        let decodedimage = UIImage(data: decodedData)
                                        
                                        if let decodedImagen = decodedimage {
                                            self.imagenesUIImages.append(decodedImagen)
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                                self.contentImages = self.imagenesUIImages
                                self.cantidad = self.cantidadArray
                                self.createPageViewController()
                                self.setupPageControl()
                                
                                JHProgressHUD.sharedHUD.hide()
                                
                            })

                            
                        } else if(aux_exito == "2"){
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.mostrarMensaje("De momento no encontramos promociones de este socio", titulo:"No hay promociones")
                            })
                            
                        } else if(aux_exito == "0"){
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.mostrarMensaje("Intente nuevamente mas tarde", titulo:"Error al obtener datos")
                            })
                            
                        } else if(aux_exito == "3") {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                                    
                                    let scale = CGAffineTransformMakeScale(1, 1)
                                    
                                    let translate = CGAffineTransformMakeTranslation(0, -1500)
                                    
                                    self.vistaAdeudo.transform = CGAffineTransformConcat(scale, translate)
                                    
                                    JHProgressHUD.sharedHUD.hide()
                                    
                                    }, completion: nil)
                                
                            })
                            
                            
                        }

                        
                        
                    } catch {}
                    
                    
                }
                
            }
            task.resume()
            
        }
        
    }
    
    
    func mostrarMensaje(mensaje: String, titulo: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    
    
    // PAGE VIEW CONTROLLER METODOS
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.clearColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            pageItemController.label1 = cantidad[0]
            pageItemController.direccionRecibida = direccionRecibida
            pageItemController.descripcionRecibida = descripcionRecibida
            pageItemController.estatusRecibido = estatusRecibido
            pageItemController.idSocioRecibido = idSocioRecibido
            pageItemController.nombreRecibido = nombreRecibido
            pageItemController.telefonoRecibido = telefonoRecibido
            pageItemController.webRecibido = webRecibido
            pageItemController.categoriaRecibido = categoriaRecibido
            pageItemController.nombrePromo = nombrePromoArray[itemIndex]
            pageItemController.descripcionPromo = descripcionArray[itemIndex]
            pageItemController.validezPromo = validoArray[itemIndex]
            pageItemController.cantidad = cantidadArray[itemIndex]
            pageItemController.idSocio = idSocioRecibido
            pageItemController.idPromocion = idPromocionArray[itemIndex]
            pageItemController.esDestacado = destacadoArray[itemIndex]
            
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func aceptarVistaAdeudo(sender: AnyObject) {
        
        self.performSegueWithIdentifier("AtrasSegue", sender: self)
        
    }

    

}
