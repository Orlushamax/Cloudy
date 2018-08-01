//
//  +UIViewController.swift
//  Cloudy
//
//  Created by Орлов Максим on 02.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String?, title: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(oKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
