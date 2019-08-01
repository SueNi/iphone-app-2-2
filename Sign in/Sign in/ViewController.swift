//
//  ViewController.swift
//  Sign in
//
//  Created by GWC on 7/12/19.
//  Copyright © 2019 SMHS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var ID: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func addTask() {
        if (input.text != "") {
            let context = (UIApplication.shared.delegate as!   AppDelegate).persistentContainer.viewContext
            let newTask = Task(context: context)
            newTask.name = input?.text
            if ID.text != ""{
                newTask.id = ID?.text
            }
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YY"
            let currentDate = formatter.string(from: date)
            newTask.date = currentDate
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            let currentTime = timeFormatter.string(from: date)
            newTask.time = currentTime
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //print(newTask.name!)
                    
        }
    }
    
    @IBAction func signin(_ sender: Any) {
        addTask()
        input.text = ""
        input.resignFirstResponder()
        ID.text = ""
        ID.resignFirstResponder()
    }

}

