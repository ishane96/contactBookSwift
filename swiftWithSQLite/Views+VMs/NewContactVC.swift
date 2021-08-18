//
//  ViewController.swift
//  swiftWithSQLite
//
//  Created by Achintha Kahawalage on 2021-08-08.
//

import UIKit

class NewContactVC: UIViewController {
    
    @IBOutlet weak var displayPic: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    var vm: NewContactVM!
    var details: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable()
        firstNameTF.becomeFirstResponder()
        phoneNumberTF.delegate = self
        setData()
    }
    
    func createTable(){
        
        let database = SQLiteDatabase.shared
        
        database.createTable()
    }
    
    func setData(){
        if let vm = vm {
            firstNameTF.text = vm.firstName
            lastNameTF.text = vm.lastName
            phoneNumberTF.text = vm.phoneNumber
            displayPic.image = vm.photo
        }
    }
    
    @IBAction func saveBtnActn(_ sender: Any) {
        
        let id = vm == nil ? 0 : vm.id!
        let firstName = firstNameTF.text ?? ""
        let lastName = lastNameTF.text ?? ""
        let phoneNumber = phoneNumberTF.text ?? ""
        let uiimage = displayPic.image
        guard let photo = uiimage?.pngData()  else {return}
        
        let contactValues = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, photo: photo)
        
        // if vm is nil creating a new contact otherwise updating the existing the contact
        if vm == nil {
            createNewContact(contactValues)
        } else {
            updateContact(contactValues: contactValues)
        }
        
        createNewContact(contactValues)
        
        
        //MARK: - Update the contact
        func updateContact(contactValues: Contact){
            let contact = SQLiteCommands.updateRow(contactValues: contactValues)
            
            //phone number is unique to each contact so we check if it is already exists
            if contact == true {
                if let cellClicked = navigationController {
                    cellClicked.popViewController(animated: true)
                }
            } else {
                print("Cannot Update -  Already exists")
            }
        }
    }
    
    //MARK: - Create New Contact
    
    func createNewContact(_ contactValues: Contact){
        let contactAddToTable = SQLiteCommands.insertRow(contactValues)
        
        //phone number is unique to each contact so we check if its already exists
        if contactAddToTable == true {
            dismiss(animated: true, completion: nil)
        } else {
            print("Already Exists this contact")
        }
    }
    
    @IBAction func cancelBtnActn(_ sender: Any) {
        let addBtnClicked = presentingViewController is UINavigationController
        
        //If the user clicked add button on the previous screen
        if addBtnClicked {
            //dismiss
            dismiss(animated: true, completion: nil)
        } else if let cellClicked = navigationController {
            cellClicked.popViewController(animated: true)
        } else {
            print("not in navigationController")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension NewContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: - Image Tap gesture
    @IBAction func uploadImage(_ sender: Any) {
        // let the user pick a picture from library
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        displayPic.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

extension NewContactVC: UITextFieldDelegate {
    //MARK: - Phone number validation
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        guard  let text  = textField.text  else {
            return false
        }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
        return false
    }
}
