//
//  AddContactViewController.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import UIKit
import SnapKit

protocol AddContactRegisterDelegate: AnyObject {
    func didSelectRegister(contact: Person)
}

class AddContactViewController : UIViewController {
    
    weak var delegate: AddContactRegisterDelegate?
    
    private lazy var familyName: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "성"
        textField.borderStyle = .none
        
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 0.0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemGroupedBackground
        textField.setPlaceHolderColor(color: .secondaryLabel)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var firstName: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "이름"
        textField.borderStyle = .none
        
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 0.0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemGroupedBackground
        textField.setPlaceHolderColor(color: .secondaryLabel)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var jobTitle: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "직업"
        textField.borderStyle = .none
        
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 0.0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemGroupedBackground
        textField.setPlaceHolderColor(color: .secondaryLabel)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setView()
    }
}

private extension AddContactViewController {
    
    func setNavigationBar(){
        view.backgroundColor = .systemGroupedBackground
        
        title = "새로운 연락처"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(AddContact))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setView(){
        [ familyName, firstName, jobTitle].forEach{
            view.addSubview($0)
        }
        
        familyName.snp.makeConstraints{
            $0.top.equalToSuperview().inset(100)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        firstName.snp.makeConstraints{
            $0.top.equalTo(familyName.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        jobTitle.snp.makeConstraints{
            $0.top.equalTo(firstName.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(47)
        }
    }
    
    @objc func textFieldDidChange(){
        self.navigationItem.rightBarButtonItem?.isEnabled =
        (!(familyName.text?.isEmpty ?? false) && !(firstName.text?.isEmpty ?? false))
    }
    
    @objc func dismissView(){
        dismiss(animated: true)
    }
    
    @objc func AddContact(){
        let famailyName: String = familyName.text ?? ""
        let firstName: String = firstName.text ?? ""
        let jobTitle: String = jobTitle.text ?? ""
        
        let person = Person(uuid: UUID().uuidString, firstName: firstName, familyName: famailyName, jobTitle: jobTitle)
        
        self.delegate?.didSelectRegister(contact: person)
        self.dismissView()
    }
}

