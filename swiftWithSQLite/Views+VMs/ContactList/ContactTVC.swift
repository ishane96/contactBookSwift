//
//  ContactTVC.swift
//  swiftWithSQLite
//
//  Created by Achintha Kahawalage on 2021-08-19.
//

import UIKit

class ContactTVC: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var displayPic: UIImageView!
    
    func setupCell(contact: Contact){
        nameLbl.text = contact.firstName + " " + contact.lastName
        phoneLbl.text = contact.phoneNumber
        
        let image = UIImage(data: contact.photo)
        displayPic.image = image
    }
}
