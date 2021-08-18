//
//  NewContactViewModel.swift
//  swiftWithSQLite
//
//  Created by Achintha Kahawalage on 2021-08-18.
//

import UIKit

class NewContactVM {
    var contactValue: Contact?
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let photo: UIImage?
    
    init(contactValues: Contact?){
        self.contactValue = contactValues
        
        self.id = self.contactValue?.id
        self.firstName = self.contactValue?.firstName
        self.lastName = self.contactValue?.lastName
        self.phoneNumber = self.contactValue?.phoneNumber
        self.photo = UIImage(data: self.contactValue!.photo)
    }
}
