//
//  DetailViewController.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import UIKit

class DetailViewController: UIViewController {
    
    var person: Person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        print("\(person.familyName) \(person.firstName)")
    }
    
    init(person: Person){
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
