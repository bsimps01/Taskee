//
//  TaskViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 10/5/20.
//

import Foundation
import CoreData
import UIKit
import Toast

class TaskViewController: UIViewController{
    
    var projectSpecs: Project?
    var coreDataStack: CoreDataStack!
    var projectTitle: String = "Project Name"
    let dateCreator = DateFormatter()
    var notify = ToastStyle()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    let todoSelector: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .systemBlue
        return control
    }()
    
    let taskTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = projectTitle
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(addTask))
        setupControl()
        setupTable()
        fetchTodoTasks()
        taskTable.reloadData()
    }
    
    func setupTable(){
        self.view.addSubview(taskTable)
        taskTable.delegate = self
        taskTable.dataSource = self
        
        taskTable.topAnchor.constraint(equalTo: self.todoSelector.bottomAnchor, constant: 20).isActive = true
        taskTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        taskTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        taskTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupControl(){
        todoSelector.insertSegment(withTitle: "TODO", at: 0, animated: true)
        todoSelector.insertSegment(withTitle: "DONE", at: 1, animated: true)
        todoSelector.selectedSegmentIndex = 0
        todoSelector.addTarget(self, action: #selector(changeUp), for: .valueChanged)
        self.view.addSubview(todoSelector)
        todoSelector.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        todoSelector.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        todoSelector.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        todoSelector.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    
    //MARK: Fetch
    
    func fetchTodoTasks(){
        let projectPredicate = NSPredicate(format: "project = %@", projectSpecs!)
        let statusTodoPredicate = NSPredicate(format: "status = false")
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectPredicate, statusTodoPredicate])
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error)
        }
    }
    
    func fetchDoneTasks(){
        let projectPredicate = NSPredicate(format: "project = %@", projectSpecs!)
        let statusDonePredicate = NSPredicate(format: "status = true")
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectPredicate, statusDonePredicate])
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error)
        }
    }
    
    //MARK: @OBJC
    @objc func addTask(){
        let vc = AddNewTaskViewController()
        vc.coreDataStack = coreDataStack
        vc.project = projectSpecs
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeUp(){
        switch todoSelector.selectedSegmentIndex {
        case 0:
            fetchTodoTasks()
            taskTable.reloadData()
        case 1:
            fetchDoneTasks()
            taskTable.reloadData()
        default:
            break
        }
    }

}

//MARK: Configure
extension TaskViewController{
    func configure(cell: UITableViewCell, for indexPath: IndexPath){
        guard let cell = cell as? TaskCell else { return }
        let task = fetchedResultsController.object(at: indexPath)
        cell.check.isChecked = task.status
        cell.taskLabel.text = task.title
        
        dateCreator.dateFormat = "MM/dd/yyyy"
        guard let formatDate = task.datedue else{
            return
        }
        let selectedDate = dateCreator.string(from: formatDate)
        cell.dateLabel.text = "Due: \(selectedDate)"
        
        cell.tapCheck = {
            if task.status {
                task.status = false
                self.coreDataStack.saveContext()
                self.notify.messageColor = .white
                self.view.makeToast("Nothing has been done!", duration: 3.0, position: .bottom, style: self.notify)
                self.taskTable.reloadData()
            }else{
                task.status = true
                self.coreDataStack.saveContext()
                self.notify.messageColor = .white
                self.view.makeToast("Task Completed!", duration: 3.0, position: .bottom, style: self.notify)
                self.taskTable.reloadData()
            }
        }
    }
}

//MARK: TableView Delegate and Data Source
extension TaskViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo =
            fetchedResultsController.sections?[section] else {
                return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        configure(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataStack.managedContext.delete(fetchedResultsController.object(at: indexPath))
            coreDataStack.saveContext()
            notify.messageColor = .white
            self.view.makeToast("Task Deleted", duration: 3.0, position: .bottom, style: notify)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddNewTaskViewController()
        let task = fetchedResultsController.object(at: indexPath)
        vc.project = projectSpecs
        vc.task = task
        vc.coreDataStack = coreDataStack
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
//MARK: Fetched Results Controller
extension TaskViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      taskTable.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
      
      switch type {
      case .insert:
        taskTable.insertRows(at: [newIndexPath!], with: .automatic)
      case .delete:
        taskTable.deleteRows(at: [indexPath!], with: .automatic)
      case .update:
        let cell = taskTable.cellForRow(at: indexPath!) as! TaskCell
        configure(cell: cell, for: indexPath!)
      case .move:
        taskTable.deleteRows(at: [indexPath!], with: .automatic)
        taskTable.insertRows(at: [newIndexPath!], with: .automatic)
      }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      taskTable.endUpdates()
    }
}
    

