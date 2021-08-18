//
//  ContactListVM.swift
//  swiftWithSQLite
//
//  Created by Achintha Kahawalage on 2021-08-19.
//

import Foundation

class ContactListVM {
    
    var contactArray = [Contact]()
    
    func connectToDatabase(){
        _ = SQLiteDatabase.shared
    }
    
    func fetchData(){
        contactArray = SQLiteCommands.presentRows() ?? []
    }
    
    
}
