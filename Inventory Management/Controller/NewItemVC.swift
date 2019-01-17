//
//  NewItemVC.swift
//  Inventory Management
//
//  Created by Ganesh Balaji Pawar on 11/01/19.
//  Copyright © 2019 Ganesh Balaji Pawar. All rights reserved.
//

import UIKit
import CoreData

protocol NewItemDelegate {
    func newItemAdded()
}

class NewItemVC: UIViewController {

    var nameArray = [Analyst]()
    var statusArray = ["OPEN", "ACCEPTED", "IN PROGRESS", "ON HOLD", "SOLVED"]
    var typeArray = ["ASSETS", "TROUBLESHOOT"]
    
    var dropDownButtonTag = 0
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dateFormatter = DateFormatter()
    var selectedNameIndex = 0
    var isNewItemAdded = false
    
    var delegate: NewItemDelegate?
    
    @IBOutlet var dueDatePickerView: UIDatePicker!
    @IBOutlet var listPickerView: UIPickerView!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var analystNameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDatePickerView.minimumDate = Date()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        fetchAnalystNames()
    }
    
    @objc func viewTapped(){
        
        listPickerView.isHidden = true
        dueDatePickerView.isHidden = true
    }

    @IBAction func dropDownButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 1:
            dropDownButtonTag = 1
            analystNameLabel.text = nameArray[0].name!
            fetchAnalystNames()
        case 2:
            dropDownButtonTag = 2
            statusLabel.text = statusArray[0]
        default:
            dropDownButtonTag = 3
            typeLabel.text = typeArray[0]
        }
        
        listPickerView.isHidden = false
        dueDatePickerView.isHidden = true
        listPickerView.reloadAllComponents()
    }
    
    @IBAction func selectDateButtonPressed(_ sender: Any) {
        
        dueDateLabel.text = dateFormatter.string(from: Date())
        listPickerView.isHidden = true
        dueDatePickerView.isHidden = false
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func addAnalystButtonPressed(_ sender: Any) {
        
        var analystNameTextField: UITextField?
        
        let alert = UIAlertController(title: "Create Analyst", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            analystNameTextField = textField
            textField.placeholder = "Enter Name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
            
            if let _ = analystNameTextField!.text{
                
                self.createAnalyst(name: analystNameTextField!.text!)
            }else{
                
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        dismiss(animated: true) {
            
            if self.isNewItemAdded{
                self.delegate!.newItemAdded()
            }
        }
    }
    
    //creates To Do Item
    @IBAction func createButtonPressed(_ sender: Any) {
        
        let todoItemManagedObject = ToDoItems(context: context)
        
//        if areAllFieldsSelected() {
            todoItemManagedObject.title = titleTextField.text!
            todoItemManagedObject.parentName = nameArray[selectedNameIndex]
            todoItemManagedObject.status = statusLabel.text!
            todoItemManagedObject.type = typeLabel.text!
            todoItemManagedObject.dueDate = dueDateLabel.text!
        
//        }
        
        do{
            try context.save()
            CustomAlert.present(title: "Item Added", message: "To Do Item has been added successfully", vc: self)
            clearAllfields()
            isNewItemAdded = true
        }catch{
            CustomAlert.present(title: "Failed", message: "Error while adding Item, Try again!", vc: self)
        }
    }
    
    // MARK: - TODO
    
//    func areAllFieldsSelected() -> Bool{
//
//        guard titleTextField.text?.isEmpty ?? <#default value#> else{
//
//        }
//
//        guard <#condition#> else {
//            <#statements#>
//        }
//        analystNameLabel.text = ""
//        statusLabel.text = ""
//        typeLabel.text = ""
//        dueDateLabel.text = ""
//    }
    
    func clearAllfields(){
        
        titleTextField.text = ""
        analystNameLabel.text = ""
        statusLabel.text = ""
        typeLabel.text = ""
        dueDateLabel.text = ""
        listPickerView.isHidden = true
        dueDatePickerView.isHidden = true
    }
    
    func createAnalyst(name: String){
        
        let analystManagedObject = Analyst(context: context)

        analystManagedObject.name = name
        
        do{
            try context.save()
            CustomAlert.present(title: "Analyst Created", message: "Analyst has been created successfully", vc: self)
            fetchAnalystNames()
        }catch{
            CustomAlert.present(title: "Failed", message: "Error while creating Analyst, Try again!", vc: self)
        }
    }
    
    func fetchAnalystNames(){
        
        let request: NSFetchRequest<Analyst> = Analyst.fetchRequest()
        
        do{
            nameArray = try context.fetch(request)
            
            if dropDownButtonTag == 1{
                listPickerView.reloadAllComponents()
            }
        }catch{
            print("Error wihle fetching: \(error.localizedDescription)")
        }
    }
    
} // END of class

extension NewItemVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRows = 0
        
        switch dropDownButtonTag {
            
        case 1:
            numberOfRows = nameArray.count
        case 2:
            numberOfRows = statusArray.count
        default:
            numberOfRows = typeArray.count
        }
        
        return numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title = ""
        
        switch dropDownButtonTag {
            
        case 1:
            title = nameArray[row].name!
        case 2:
            title = statusArray[row]
        default:
            title = typeArray[row]
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch dropDownButtonTag {
            
        case 1:
            analystNameLabel.text = nameArray[row].name!
            selectedNameIndex = row
        case 2:
            statusLabel.text = statusArray[row]
        default:
            typeLabel.text = typeArray[row]
        }
    }
}
