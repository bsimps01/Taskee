//
//  NewEditTaskViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 10/5/20.
//

import Foundation
import UIKit
import CoreData
import Toast

class AddNewTaskViewController: UIViewController {
    
    var project: Project!
    var task: Task?
    var coreDataStack: CoreDataStack?
    var notify = ToastStyle()
    
    let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.datePickerMode = .date
        return date
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date Deadline"
        return label
    }()
    
    let titleField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "What are you going to work on today?"
        return field
    }()
    
    let dateField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "mm/dd/yyyy"
        return field
    }()
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Task or Edit"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTask))
        setup()
        if task != nil{
            config()
            notify.messageColor = .white
            self.view.makeToast("You made a new Project", duration: 3.0, position: .bottom, style: notify)
        }
        
    }
    
    //MARK: Setup
    func setup(){
        self.view.addSubview(titleLabel)
        self.view.addSubview(titleField)
        self.view.addSubview(dateLabel)
        self.view.addSubview(datePicker)
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
        titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        titleField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
        dateLabel.topAnchor.constraint(equalTo: self.titleField.bottomAnchor, constant: 30).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
        datePicker.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    func config(){
        guard let task = task else { return }
        titleField.text = task.title
        datePicker.date = task.datedue!
        
    }
    
    //MARK: Save Task
    @objc func saveTask(){
        if task == nil{
            let newTask = Task(context: coreDataStack!.managedContext)
            newTask.title = titleField.text
            newTask.status = false
            newTask.datedue = datePicker.date
            newTask.project = project
            coreDataStack?.saveContext()
        }else{
            task?.title = titleField.text
            task?.status = false
            task?.datedue = datePicker.date
            task?.project = project
            coreDataStack?.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
    }

}
