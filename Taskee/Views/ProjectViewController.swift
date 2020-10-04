//
//  ViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/24/20.
//

import UIKit
import CoreData

class ProjectViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
        return table
    }()
    
    var coreDataStack = CoreDataStack()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Projects> = {
        let fetchRequest: NSFetchRequest<Projects> = Projects.fetchRequest()
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
        self.view.backgroundColor = .systemGray
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
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func addButton(){
        let newProject = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addingProject))
        self.navigationItem.rightBarButtonItem = newProject
    }
    
    @objc func addingProject(){
        let addNew = AddNewTaskViewController()
        addNew.coreDataStack = coreDataStack
        self.navigationController?.pushViewController(addNew, animated: true)
    }
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCell.identifier) as! ProjectCell
        return cell
    }
    
    
}
