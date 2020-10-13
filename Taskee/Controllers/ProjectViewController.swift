//
//  ViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/24/20.
//

import UIKit
import CoreData
import Toast

class ProjectViewController: UIViewController {
    
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.allowsSelectionDuringEditing = true
        table.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
        return table
    }()
    
    var coreDataStack = CoreDataStack()
    
    var notify = ToastStyle()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchController.delegate = self
        
        return fetchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = editButtonItem
        displayTable()
        addButton()
        fetchResults()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchResults()
        tableView.reloadData()
    }
    
    func fetchResults(){
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func displayTable(){
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.rowHeight = 100
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func addButton(){
        let newProjectButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newProject))
        self.navigationItem.rightBarButtonItem = newProjectButton
    }
    
    @objc func newProject() {
        let addVC = AddNewProjectViewController()
        addVC.coreDataStack = coreDataStack
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
//    func addingProject(project: Project?){
//        let addNew = AddNewProjectViewController()
//        addNew.coreDataStack = coreDataStack
//        addNew.delegate = self
//        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        childContext.parent = coreDataStack.managedContext
//        addNew.childContext = childContext
//        if project == nil { //new project
//            let newProject = Project(context: childContext)
//            addNew.project = newProject
//            addNew.title = "New Project"
//        } else { //edit project
//            let projectToEdit = childContext.object(with: project!.objectID) as? Project
//            addNew.project = projectToEdit
//            addNew.title = "Edit Project"
//        }
//        self.navigationController?.pushViewController(addNew, animated: true)
//    }
    
    
    @objc func showEditing(sender: UIBarButtonItem){
        if(self.tableView.isEditing == true){
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
}

extension ProjectViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //sections
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCell.identifier) as! ProjectCell
        configure(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing == true{
            let project = fetchedResultsController.object(at: indexPath)
            let addVC = AddNewProjectViewController()
            addVC.coreDataStack = coreDataStack
            addVC.project = project
            self.navigationController?.pushViewController(addVC, animated: true)
        }else{
            let cell = tableView.cellForRow(at: indexPath) as! ProjectCell
            let vc = TaskViewController()
            let project = fetchedResultsController.object(at: indexPath)
            vc.coreDataStack = coreDataStack
            vc.projectTitle = cell.projectTitle.text ?? ""
            vc.projectSpecs = project
            notify.messageColor = .white
            self.view.makeToast("You made a new Project", duration: 3.0, position: .bottom, style: notify)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
          return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataStack.managedContext.delete(fetchedResultsController.object(at: indexPath))
            coreDataStack.saveContext()
            notify.messageColor = .white
            self.view.makeToast("Your project has been deleted!", duration: 3.0, position: .bottom, style: notify)
        }
    }
    
    
}

extension ProjectViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
      switch type {
      case .insert:
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
      case .delete:
        tableView.deleteRows(at: [indexPath!], with: .automatic)
      case .update:
        let cell = tableView.cellForRow(at: indexPath!) as! ProjectCell
        configure(cell: cell, for: indexPath!)
      case .move:
        tableView.deleteRows(at: [indexPath!], with: .automatic)
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
    }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.endUpdates()
    }
}

extension ProjectViewController{
    func configure(cell: UITableViewCell, for indexPath: IndexPath){
        
        guard let cell = cell as? ProjectCell else { return }
        let project = fetchedResultsController.object(at: indexPath)
        
        cell.projectTitle.text = project.title
        if let colorSection = project.color {
            cell.colorSection.backgroundColor = colorSection
        } else {
            cell.colorSection.backgroundColor = nil
        }
        
        guard let tasks = project.tasks else { return }
        var count = 0
        for task in tasks{
            if (task as AnyObject).status == false{
                count += 1
            }
        }
        cell.taskLabel.text = "\(count) pending tasks"
    }
}
