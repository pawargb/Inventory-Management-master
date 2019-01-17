//
//  CustomAlert.swift
//  Inventory Management
//
//  Created by Ganesh Balaji Pawar on 11/01/19.
//  Copyright © 2019 Ganesh Balaji Pawar. All rights reserved.
//

import UIKit

class CustomAlert: NSObject {
    
    class func present(title: String, message: String, vc: UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

}
