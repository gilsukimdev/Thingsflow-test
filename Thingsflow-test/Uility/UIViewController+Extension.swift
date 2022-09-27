//
//  UIViewController+Extension.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import UIKit
 
extension UIViewController {
    func alert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "확인", style: .default)
        alert.addAction(done)
        self.present(alert, animated: true)
    }
}
