//
//  ContactListVC.swift
//  swiftWithSQLite
//
//  Created by Achintha Kahawalage on 2021-08-19.
//

import UIKit

class ContactListVC: UIViewController {
    
    let vm = ContactListVM()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.fetchData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.fetchData()
        tableView.reloadData()
    }
}

extension ContactListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTVC") as! ContactTVC
        
        if let _cell = cell as? ContactTVC {
            _cell.setupCell(contact: vm.contactArray[indexPath.row])
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //parse data
        if segue.identifier == "edit" {
            
            guard let newContactVC = segue.destination as? NewContactVC else {return}
            
            guard let selectedCell = sender as? ContactTVC else {return}
            
            if let indexPath = tableView.indexPath (for: selectedCell){
                let selectedContact = vm.contactArray[indexPath.row]
                newContactVC.vm = NewContactVM(contactValues: selectedContact)
            }
        }
    }
}
