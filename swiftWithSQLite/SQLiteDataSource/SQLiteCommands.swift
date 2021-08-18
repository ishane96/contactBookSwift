//
//  SQLiteCommands.swift
//  swiftWithSQLite
//
//  Created by Achintha Kahawalage on 2021-08-08.
//

import Foundation
import SQLite

class SQLiteCommands {
    
    static var table = Table("contact")
    
    //expressions
    static let id = Expression<Int>("id")
    static let firstName = Expression<String>("firstName")
    static let lastName = Expression<String>("lastName")
    static let phoneNumber = Expression<String>("phoneNumber")
    static let photo = Expression<Data>("photo")
    
    //Creating Table
    static func createTable(){
        guard let database = SQLiteDatabase.shared.database else {
            print("DB connection error")
            return
        }
        
        do {
            //IfNotExists: true = will not create a table if it's already exists
            try database.run(table.create(ifNotExists: true){ table in
                table.column(id, primaryKey: true)
                table.column(firstName)
                table.column(lastName)
                table.column(phoneNumber)
                table.column(photo)
            })
        } catch {
            print("Already Exists")
        }
    }
    
    //Inseting a row
    static func insertRow(_ contactValues: Contact) -> Bool? {
        guard let database = SQLiteDatabase.shared.database
        else {
            print("DB Connection Error")
            return nil
        }
        do {
            try  database.run(table.insert(firstName <- contactValues.firstName, lastName <- contactValues.lastName, phoneNumber <- contactValues.phoneNumber, photo <- contactValues.photo))
            return true
            
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT{
            print("Insert Row Field: \(message), in  \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed\(error)")
            return false
        }
    }
    
    //Present rows
    static func presentRows() -> [Contact]? {
        guard let database = SQLiteDatabase.shared.database else {
            print("Database connection Error")
            return nil
        }
        
        //Contact Array
        var contactArray = [Contact]()
        
        //Sorting data in descending order by ID
        table = table.order(id.desc)
        
        do {
            for contact in try database.prepare(table){
                let idValue = contact[id]
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                let phoneNumberValue = contact[phoneNumber]
                let photoValue = contact[photo]
                
                //Create Object
                let contactObject = Contact(id: idValue, firstName: firstNameValue, lastName: lastNameValue, phoneNumber: phoneNumberValue, photo: photoValue)
                
                //Add Object to an Array
                contactArray.append(contactObject)
                
                print("FirstName::::\(contact[firstName])")
            }
            
        } catch {
            print("Present Row Error: \(error)")
        }
        return contactArray
    }
    
    //Presenting Rows
    static func updateRow(contactValues: Contact) -> Bool? {
        guard let database = SQLiteDatabase.shared.database else {
            print("Datastore Connection Error")
            return nil
        }
        
        //extracts the appropriate contact from table according to the id
        let contact = table.filter(id == contactValues.id).limit(1)
        
        do {
            //update the contact's values
            if try database.run(contact.update(firstName <- contactValues.firstName, lastName <- contactValues.lastName, phoneNumber <- contactValues.phoneNumber, photo <- contactValues.photo)) > 0{
                print("Updated")
                return true
            } else {
                print("Could not update the contact: Contact not found")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT{
            print("update failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Update failed: \(error)")
            return false
        }
    }
    
}
