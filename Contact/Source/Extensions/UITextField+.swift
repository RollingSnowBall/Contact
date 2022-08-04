//
//  UITextField+.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import UIKit

public extension UITextField {
    
    func setPlaceHolderColor(color: UIColor){
        attributedPlaceholder = NSAttributedString(
                    string: placeholder ?? "",
                    attributes: [
                        .foregroundColor: color,
                        .font: font
                    ].compactMapValues { $0 }
        )
    }
}
