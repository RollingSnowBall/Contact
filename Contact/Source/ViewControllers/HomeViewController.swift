//
//  HomeViewController.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import UIKit

class HomeViewController: UITableViewController {

    var contactInfo = PersonViewModel()
    var allSectionHeaderList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setSearchBar()
        setTable()
        loadContactList()
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return contactInfo.sectionHeaderList.firstIndex(of: title) ?? 0
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return allSectionHeaderList
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if contactInfo.sectionHeaderList.count == 0 {
            return nil
        }
        
        return contactInfo.sectionHeaderList[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionArray(at: section).count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        contactInfo.sectionHeaderList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let person = sectionArray(at: indexPath.section)[indexPath.row]
        
        self.navigationController?.pushViewController(DetailViewController(person: person), animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { return UITableViewCell() }
        
        if(contactInfo.numOfPeopleList != 0){
            let person = sectionArray(at: indexPath.section)[indexPath.row]
            cell.setCell(contact: person)
        }

        return cell
    }
}

private extension HomeViewController {
    
    func setNavigationBar(){
        view.backgroundColor = .systemBackground
        title = "연락처"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "그룹",
                                                           style: .plain,
                                                           target: self,
                                                           action: nil
                                                          )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addContact)
                                                          )
    }
    
    func setSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        //searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setTable(){
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
    }
    
    func saveContact(){
        let data = contactInfo.personList.map {
            [
                "uuid" : $0.uuid,
                "firstName" : $0.firstName,
                "familyName" : $0.familyName,
                "jobName" : $0.jobTitle
            ]
        }
        
        let userDefault = UserDefaults.standard
        userDefault.set(data, forKey: "contactList")
    }
    
    func loadContactList(){
        let userDefualts = UserDefaults.standard
        guard let data = userDefualts.object(forKey: "contactList") as? [[String: Any]] else { return }
        
        let List: [Person] = data.compactMap {
            guard let uuid = $0["uuid"] as? String else { return nil}
            guard let firstName = $0["firstName"] as? String else { return nil}
            guard let familyName = $0["familyName"] as? String else { return nil}
            guard let jobTitle = $0["jobName"] as? String? else { return nil}
            
            return Person(uuid: uuid, firstName: firstName, familyName: familyName, jobTitle: jobTitle)
        }
        
        List.forEach { person in
            contactInfo.addPerson(person: person)
        }
    }
    
    @objc func addContact(){
        let AddContactVC = AddContactViewController()
        present(UINavigationController(rootViewController: AddContactVC.self), animated: true){
            AddContactVC.delegate = self
        }
    }
    
    func generateAllSectionList() { /// section index title UI 표시 용도
        let tempSectionHeader = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅍ", "ㅌ", "ㅎ"]
        for index in 0..<tempSectionHeader.count {
            allSectionHeaderList.append(tempSectionHeader[index].precomposedStringWithCompatibilityMapping)
        }
        for dec in 65...90 {
            allSectionHeaderList.append(String(UnicodeScalar(dec)!))
        }
    }
    
    func sectionArray(at section: Int) -> [Person] {
        return contactInfo.contactList[contactInfo.sectionHeaderList[section]]!
    }
}

extension HomeViewController: AddContactRegisterDelegate{
    func didSelectRegister(contact: Person) {
        contactInfo.addPerson(person: contact)
        saveContact()
        self.tableView.reloadData()
    }
}
