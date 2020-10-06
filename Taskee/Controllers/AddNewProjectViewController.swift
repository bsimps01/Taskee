//
//  AddNewTaskViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/28/20.
//

import Foundation
import UIKit
import CoreData


class AddNewProjectViewController: UIViewController {
    
    var coreDataStack: CoreDataStack?
    var project: Project?
    var imageName: String = ""
    var delegate: ProjectEntryDelegate?
    var childContext: NSManagedObjectContext!
    
    var imageNames: [String] = ["school", "gift", "pray", "trip", "working", "home", "shopping", "health", "lifting"]
    var images: [UIImage] = [UIImage(named: "school")!, UIImage(named: "gift")!, UIImage(named: "health")!, UIImage(named: "home")!, UIImage(named: "lifting")!, UIImage(named: "pray")!, UIImage(named: "shopping")!, UIImage(named: "trip")!, UIImage(named: "working")!]
    
    let titleText: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Name of Project"
        text.backgroundColor = .systemBackground
        //text.leftView = UIImageView()
        text.font = UIFont.systemFont(ofSize: 35)
        text.borderStyle = .roundedRect
        return text
    }()
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    lazy var collectionView: UICollectionView = {
        let iv = ImageLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 200, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: iv)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .yellow
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    
    var imageSelection: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        self.title = "New/Edit Project"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        setup()
        
        configuration()
        
        //setupLeftImage(imageName: "pray")
        
    }
    
    func setup(){
        self.view.addSubview(titleText)
        self.view.addSubview(collectionView)
        titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
    }
    
    fileprivate func configuration() {
        guard let project = project else { return }
        titleText.text = project.title
        
        guard let image = project.image else { return }
        
        imageSelection = image as? UIImage
        
        self.imageView.image = imageSelection
        
    }
    
    @objc func save(){
        //        if project == nil{
        //            let newProject = Projects(context: coreDataStack!.managedContext)
        //            newProject.title = titleText.text
        //            newProject.image = imageName
        //            coreDataStack?.saveContext()
        //        }else{
        project?.title = titleText.text
        project?.image = imageName as NSObject
        //            coreDataStack?.saveContext()
        delegate?.didSaveProject(vc: self, didSave: true)
        //        }
        //        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLeftImage(imageName: String){
        imageView.image = UIImage(named: imageName)!
        //        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        //        imageContainerView.addSubview(imageView)
        titleText.leftView = imageView
        titleText.leftViewMode = .always
        titleText.tintColor = .lightGray
    }
    
    
    
    
}

extension AddNewProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageNames.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let imageName = imageNames[indexPath.row]
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageview.image = UIImage(named: imageName)!
        cell.contentView.addSubview(imageview)
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.blue.cgColor
        cell?.layer.borderWidth = 2
        imageName = imageNames[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = UIColor.yellow.cgColor
            cell.layer.borderWidth = 2
        }
    }
}

protocol ProjectEntryDelegate {
    func didSaveProject(vc: AddNewProjectViewController, didSave: Bool)
}
