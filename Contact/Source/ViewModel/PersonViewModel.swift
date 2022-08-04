//
//  PersonViewModel.swift
//  Contact
//
//  Created by JUNO on 2022/07/31.
//

import Foundation

class PersonViewModel {

    var personList: [Person] = []
    var contactList: Dictionary<String,[Person]> = [:]
    
    var numOfPeopleList: Int {
        
        var count = 0
        
        contactList.values.forEach {
            count += $0.count
        }
        
        return count
    }
    
    var sectionHeaderList: [String] {
        return makeHangulFirst(with: Array(Set(contactList.keys)).sorted())
    }
    
    func addPerson(person: Person){
        let firstString: String = person.familyName.firstIndexString
        
        if contactList[firstString] == nil {
            contactList[firstString] = [person]
            personList.append(person)
        }else{
            contactList[firstString]?.append(person)
            personList.append(person)
        }
        
        contactList[firstString] = contactList[firstString]?.sorted { $0.firstName < $1.firstName }
        contactList[firstString] = contactList[firstString]?.sorted { $0.familyName < $1.familyName }
    }
    
    func peopleList(at index: Int) -> Person {
        return personList[index]
    }
    
    private func generateFirstStringList(list: [String]) -> [String] {
        var startIndexStringList: [String] = []
        
        list.forEach {
            startIndexStringList.append(String($0[$0.startIndex]))
        }
        
        return startIndexStringList
    }
    
    private func makeHangulFirst(with headerList: [String]) -> [String] {
        var letterSectionList: [String] = []
        var hangulSectionList: [String] = []
        
        headerList.forEach {
            if $0.isAlpha() {
                letterSectionList.append($0)
            } else {
                hangulSectionList.append($0)
            }
        }
        
        return hangulSectionList + letterSectionList
    }
}
