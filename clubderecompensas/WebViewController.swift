//
//  WebViewController.swift
//  Club de Recompensas
//
//  Created by Doctor on 11/18/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet var webView: UIWebView!
    
    // VARIABLES
    var webRecibida: String!
    var url: NSURL!


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
        
        print(webRecibida)
        
        // Definir url recibida y hacer request
        url = NSURL(string: "http://" + webRecibida)
        let request = NSURLRequest(URL: url)
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
    
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.webView.loadRequest(request)
            JHProgressHUD.sharedHUD.hide()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
