//
//  String+.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import Foundation

extension String {
    
    func isAlpha() -> Bool {
       switch self {
       case "a"..."z":
           return true
       case "A"..."Z":
           return true
       default:
           return false
       }
    }
    
    var firstIndexString: String {
        return self.decomposedStringWithCompatibilityMapping.unicodeScalars.map { String($0) }[0]
    }
}
