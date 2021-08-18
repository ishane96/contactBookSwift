//
//  SQLiteDatabase.swift
//  swiftWithSQLite
//
//  Created by Achintha Kahawalage on 2021-08-08.
//

import Foundation
import SQLite

class SQLiteDatabase {
    
    static let shared = SQLiteDatabase()
    var database: Connection?
    
    private init(){
        //Create connection to database
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("contactList").appendingPathExtension("sqLite3")
            
            database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable(){
        SQLiteCommands.createTable()
    }
    
}
