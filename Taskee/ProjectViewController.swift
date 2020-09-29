//
//  ViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/24/20.
//

import UIKit
import CoreData

class ProjectViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Projects"
        self.view.backgroundColor = .systemGray
        navigationItem.leftBarButtonItem = editButtonItem
        displayTable()
        
        
    }
    
    func displayTable(){
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBlue
        tableView.rowHeight = 100
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func addButton(){
        let newProject = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProject))
    }
    
    @objc func addProject(){
        //let addNew = AddNewTaskViewController()
        //self.navigationController?.pushViewController(addNew, animated: true)
    }

}

extension ProjectViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        project.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}
