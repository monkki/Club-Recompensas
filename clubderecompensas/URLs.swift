//
//  URLs.swift
//  Club de Recompensas
//
//  Created by Doctor on 11/19/15.
//  Copyright © 2015 Roberto Gutierrez. All rights reserved.
//

import Foundation

class Urls{
    
    
    
    let RAIZ_WS = "http://quierotaxiservicios.dctimx.com/club_cm/";
    
    let LOGIN = "login.php?";
    
    let REGISTRO = "registro.php?";
    
    let SOCIOS = "get_socios.php?";
    
    let PROMOCIONES = "get_promocion.php?";
    
    let CODIGO = "take_promo.php?"
    
    
    func getUrlLogin(clave: String, correo: String)-> String{
        
        let url = RAIZ_WS + LOGIN + "clave=" + clave + "&correo=" + correo;
        
        return url;
        
    }
    
    
    
    func getUrlRegistro(clave: String, nombre: String, correo: String ) -> String {
        
        let url = RAIZ_WS + REGISTRO + "clave=" + clave + "&nombre=" + nombre + "&correo=" + correo;
        
        return url;
        
    }
    
    
    
    func getUrlSocios(id_residencial: String, id_condominio:String,id_tarjeta: String, id_categoria: String)-> String{
        
        let url = RAIZ_WS + SOCIOS + "id_residencial=" + id_residencial + "&id_condominio=" + id_condominio + "&id_tarjeta=" + id_tarjeta + "&id_categoria=" + id_categoria;
        
        return url;
        
    }
    
    
    
    func getUrlPromociones(id_Categoria: String,id_residencial: String, id_condominio: String, id_tarjeta: String, id_socio: String)-> String{
        
        let url = RAIZ_WS + PROMOCIONES + "id_categoria=" + id_Categoria + "&id_residencial=" + id_residencial + "&id_condominio=" + id_condominio  + "&id_tarjeta=" + id_tarjeta + "&id_socio=" + id_socio;
        
        return url;
        
    }
    

    func getCodigoPromociones(id_residencial: String, id_condominio:String, id_tarjeta: String, id_Categoria: String, id_socio: String, id_usuario: String, id_promocion: String )-> String{
        
        let url = RAIZ_WS + CODIGO + "id_residencial=" + id_residencial + "&id_condominio=" + id_condominio +  "&id_tarjeta=" + id_tarjeta + "&id_socio=" + id_socio + "&id_categoria=" + id_Categoria  + "&id_usuario=" + id_usuario + "&id_promocion=" + id_promocion;
        
        return url;
        
    }

    
    
}

