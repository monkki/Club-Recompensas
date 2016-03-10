//
//  ContactoViewController.swift
//  Club de Recompensas
//
//  Created by Doctor on 11/20/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit
import MessageUI

class ContactoViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // OUTLETS
    @IBOutlet var vistaEmail: UIView!
    @IBOutlet var nombreTextfield: UITextField!
    @IBOutlet var telefonoTextfield: UITextField!
    @IBOutlet var emailTexfield: UITextField!
    @IBOutlet var ciudadTextfield: UITextField!
    @IBOutlet var comentariosTextView: UITextView!
    @IBOutlet var enviarBoton: UIButton!
    
    // VARIABLES EMAIL
    var nombre: String!
    var telefono: String!
    var email: String!
    var ciudad: String!
    var comentarios: String!
    
    
    // Elementos de animacion
    let scale = CGAffineTransformMakeScale(0.0, 0.0)
    let translate = CGAffineTransformMakeTranslation(0, 500)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Imagen encabezado
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo-cabeza")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationItem.titleView!.sizeThatFits(CGSize(width: 320, height: 65))
    
        vistaEmail.transform = CGAffineTransformConcat(scale, translate)
        
        enviarBoton.layer.borderColor = UIColor.whiteColor().CGColor
        enviarBoton.layer.borderWidth = 2
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.39, blue:0.61, alpha:1.0)
        
        vistaEmail.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "encabezado-azul")!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func llamarBoton(sender: AnyObject) {
        
        let url:NSURL = NSURL(string: "telprompt://4422281340")!
        UIApplication.sharedApplication().openURL(url)
        
    }
    
    @IBAction func emailBoton(sender: AnyObject) {
        
        vistaEmail.hidden = false
        
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            
            let scale = CGAffineTransformMakeScale(1, 1)
            
            let translate = CGAffineTransformMakeTranslation(0, 0)
            
            self.vistaEmail.transform = CGAffineTransformConcat(scale, translate)
            
            }, completion: nil)
        
    }
    
    
    @IBAction func cerrarVistaEmail(sender: AnyObject) {
        
        vistaEmail.transform = CGAffineTransformConcat(scale, translate)
    }
    
    @IBAction func enviarBotonPresionado(sender: AnyObject) {
        
        nombre = nombreTextfield.text! as String
        telefono =  telefonoTextfield.text! as String
        email = emailTexfield.text! as String
        ciudad = ciudadTextfield.text! as String
        comentarios = comentariosTextView.text! as String
        
        if nombre == "" || telefono == "" || email == "" || ciudad == "" || comentarios == "" {
            
            let alerta = UIAlertController(title: "Club Recompensas", message: "Porfavor llene todos los campos", preferredStyle: UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alerta, animated: true, completion: nil)

            
        } else {
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                nombreTextfield.text = ""
                telefonoTextfield.text = ""
                emailTexfield.text = ""
                ciudadTextfield.text = ""
                comentariosTextView.text = ""
                vistaEmail.hidden = true
            } else {
                self.showSendMailErrorAlert()
            }
            
        }
        
    }

    
    
//    // FUNCIONES EMAIL 

    
    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["barbara.rojas@prohabitacion.com"])
        mailComposerVC.setSubject("Email App Prohabitacion")
        mailComposerVC.setMessageBody("Nombre: " + nombre + "\n" + "Teléfono: " + telefono + "\n" + "Email: " + email + "\n" + "Ciudad: " + ciudad + "\n" + "Comentarios: " + comentarios + "\n" , isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "No se pudo enviar Email", message: "Tu dispositivo no puede enviar email. Porfavor configura tu email en ajustes.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
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
