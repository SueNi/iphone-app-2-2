//
//  tableController.swift
//  Don't forget me
//
//  Created by GWC on 7/11/19.
//  Copyright © 2019 Sue. All rights reserved.
//

import UIKit

class tableController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var table: UITableView!
    var tasks: [Task] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 10
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    func getData() {
        do {
            tasks = try context.fetch(Task.fetchRequest())
            print(tasks)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        } catch {
            print("Couldn't fetch Data")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table", for: indexPath)
        cell.textLabel?.backgroundColor = .white
        let date = tasks[indexPath.row].date
        let time = tasks[indexPath.row].time
        let id = tasks[indexPath.row].id
        // Configure the cell...
        if let id = id{
            cell.textLabel?.text = tasks[indexPath.row].name! + "   Student ID: " + id
        }else{
            cell.textLabel?.text = tasks[indexPath.row].name!
        }
        var timeStamp = ""
        if let date = date, let time = time{
            timeStamp = "Signed in \(date) at \(time)"
        }
        cell.detailTextLabel?.text = timeStamp
        return cell
    }
    
    func check(indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath)
        cell?.textLabel?.backgroundColor = .green
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let time = timeFormatter.string(from: date)
        cell?.detailTextLabel?.text?.append(" Sign out at \(time)")
    
    }

    override func tableView(_ tableView: UITableView,leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let hand =  { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.check(indexPath: indexPath)
            success(true)
        }
        let closeAction = UIContextualAction(style: .normal, title: "Sign Out", handler: hand)
        closeAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let task = self.tasks[indexPath.row]
            self.context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
