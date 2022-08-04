//
//  ContactCell.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import UIKit
import SnapKit
import NaturalLanguage

class ContactCell: UITableViewCell {
    
    private lazy var contactTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        
        return label
    }()
    
    func setCell(contact: Person){
        
        var lang = ""
        if (!contact.familyName.isEmpty){
            lang = detectedLanguage(for: contact.familyName) ?? ""
        } else {
            lang = detectedLanguage(for: contact.firstName) ?? ""
        }
        
        let boldAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
        ]
        let regularAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18.0)!
        ]
        
        let newString = NSMutableAttributedString()
        
        if (lang == "한국어")
        {
            let regularText = NSAttributedString(string: contact.firstName, attributes: regularAttribute)
            let boldText = NSAttributedString(string: contact.familyName, attributes: boldAttribute)
            newString.append(boldText)
            newString.append(regularText)
        }
        else
        {
            let regularText = NSAttributedString(string: (contact.firstName), attributes: regularAttribute)
            let boldText = NSAttributedString(string: " \(contact.familyName)", attributes: boldAttribute)
            newString.append(regularText)
            newString.append(boldText)
        }

        contactTitle.attributedText = newString
        
        self.addSubview(contactTitle)
        
        contactTitle.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    func detectedLanguage(for string: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLanguage
    }
}
