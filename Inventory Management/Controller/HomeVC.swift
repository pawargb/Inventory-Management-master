//
//  ViewController.swift
//  Inventory Management
//
//  Created by Ganesh Balaji Pawar on 11/01/19.
//  Copyright © 2019 Ganesh Balaji Pawar. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    @IBOutlet var dashboardView: UIView!
    @IBOutlet var toDoTableView: UITableView!
    
    @IBOutlet var DBdueTodayButton: UIButton!
    @IBOutlet var DBopenButton: UIButton!
    @IBOutlet var DBtodoButton: UIButton!
    @IBOutlet var DBoverdueButton: UIButton!
    @IBOutlet var sortByLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [ToDoItems]()
    
    var dueTodayItemArray = [ToDoItems]()
    var openItemArray = [ToDoItems]()
    var overdueItemArray = [ToDoItems]()
    var todoItemArray = [ToDoItems]()
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - View life cycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeDashboardView()
        
        refreshControl.addTarget(self, action: #selector(fetchToDoItems), for: .valueChanged)
        toDoTableView.addSubview(refreshControl)
        
        toDoTableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "todoItem")
        fetchToDoItems()
        //deleteAll()
    }
    
    @IBAction func newButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "newItemSegue", sender: self)
    }
    
    @IBAction func dashboardButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 0: //overDue
            sortByLabel.text = "Over Due"
            itemArray = overdueItemArray
        case 1: //todo
            sortByLabel.text = "To Do"
            itemArray = todoItemArray
        case 2: //open
            sortByLabel.text = "Open"
            itemArray = openItemArray
        default: //dueToday
            sortByLabel.text = "Due Today"
            itemArray = dueTodayItemArray
        }
        
        toDoTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! NewItemVC
        destination.delegate = self
    }
    
    //MARK: - Logic Method
    
    func deleteAll(){
        
        for obj in itemArray{
            
            context.delete(obj)
        }
        
        do{
            try context.save()
        }catch{
            print("error while deleting")
        }
        toDoTableView.reloadData()
    }
    
    @objc func fetchToDoItems(){
        
        let request: NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()
        
        do{
            itemArray = try context.fetch(request)
            todoItemArray = itemArray
            toDoTableView.reloadData()
            updateDashboardData()
            sortByLabel.text = "All Items"
            refreshControl.endRefreshing()
        }catch{
            print("something went wrong while fetching ToDoItems")
        }
    }
    
    func updateDashboardData(){
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        let todayDate = dateformatter.string(from: Date())
        
        openItemArray.removeAll()
        dueTodayItemArray.removeAll()
        overdueItemArray.removeAll()
        
        for obj in itemArray{
            
            //open count
            if obj.status == "OPEN"{
                
                openItemArray.append(obj)
            }
            
            //Due today
            let tempStringDate = obj.dueDate!.components(separatedBy: " ")
            if todayDate == tempStringDate[0]{
                
                dueTodayItemArray.append(obj)
            }
            
            // over due
            dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
            let tempDate = dateformatter.date(from: obj.dueDate!)
            
            if let temp = tempDate, temp < Date(){
                
                overdueItemArray.append(obj)
            }
        }
        
        DBopenButton.setTitle(String(openItemArray.count), for: .normal)
        DBtodoButton.setTitle(String(itemArray.count), for: .normal)
        DBdueTodayButton.setTitle(String(dueTodayItemArray.count), for: .normal)
        DBoverdueButton.setTitle(String(overdueItemArray.count), for: .normal)
    }
    
    func customizeDashboardView(){
        
        dashboardView.layer.masksToBounds = false
        dashboardView.layer.shadowColor = UIColor.black.cgColor
        dashboardView.layer.shadowOpacity = 0.5
        dashboardView.layer.shadowOffset = CGSize(width: -1, height: 1)
        dashboardView.layer.shadowRadius = 1
    }
}

extension HomeVC: NewItemDelegate{
    
    func newItemAdded() {
        
        fetchToDoItems()
    }
    
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return itemArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16))
//        headerView.backgroundColor = UIColor(displayP3Red: 213, green: 210, blue: 209, alpha: 1)
        headerView.backgroundColor = UIColor(rgb: 0xEBEBEB)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItem", for: indexPath) as! ToDoTableViewCell
        
        cell.typeLabel.text = itemArray[indexPath.section].type
        cell.statusLabel.text = itemArray[indexPath.section].status
        cell.titleLabel.text = itemArray[indexPath.section].title
        
        cell.analystLabel.text = itemArray[indexPath.section].parentName!.name
        
        if itemArray[indexPath.section].type == "ASSETS"{
            
            cell.typeImageView.image = UIImage(named: "asset")
        }else{
            cell.typeImageView.image = UIImage(named: "troubleshoot")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
