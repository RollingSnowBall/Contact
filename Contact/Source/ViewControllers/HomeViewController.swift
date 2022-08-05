//
//  HomeViewController.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    var contactInfo = PersonViewModel()
    var allSectionHeaderList = [String]()
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }
    
    private lazy var tableVC: UITableView = {
        let tableView = UITableView()
        
        tableView.dataSource = self
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setSearchBar()
        setTable()
        loadContactList()
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
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setTable(){
        
        view.addSubview(tableVC)
        
        tableVC.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
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

extension HomeViewController: AddContactRegisterDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func didSelectRegister(contact: Person) {
        contactInfo.addPerson(person: contact)
        saveContact()
        tableVC.reloadData()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        if isFiltering {
            return 0
        }
        else
        {
            return contactInfo.sectionHeaderList.firstIndex(of: title) ?? 0
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering {
            return nil
        }
        else
        {
            return allSectionHeaderList
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if contactInfo.sectionHeaderList.count == 0 {
            return nil
        }
        
        if isFiltering {
            return ""
        }
        else
        {
            return contactInfo.sectionHeaderList[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return contactInfo.filteredList.count
        }
        else
        {
            return sectionArray(at: section).count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        else
        {
            return contactInfo.sectionHeaderList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let person = sectionArray(at: indexPath.section)[indexPath.row]
        
        self.navigationController?.pushViewController(DetailViewController(person: person), animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { return UITableViewCell() }
        
        if isFiltering {
            if(contactInfo.filteredList.count != 0){
                let person = contactInfo.filteredList[indexPath.row]
                cell.setCell(contact: person)
            }
        }
        else
        {
            if(contactInfo.numOfPeopleList != 0){
                let person = sectionArray(at: indexPath.section)[indexPath.row]
                cell.setCell(contact: person)
            }
        }

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        contactInfo.filteredPerson(keyword: text)
        tableVC.reloadData()
    }
}
