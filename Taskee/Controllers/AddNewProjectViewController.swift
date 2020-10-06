//
//  AddNewTaskViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/28/20.
//

import Foundation
import UIKit
import CoreData
import Toast


class AddNewProjectViewController: UIViewController {
    
    var coreDataStack: CoreDataStack?
    var project: Project?
    var confirmColor: UIColor? = .systemBackground
    var delegate: ProjectEntryDelegate?
    var childContext: NSManagedObjectContext!
    var notify = ToastStyle()

    let colors: [UIColor] = [.black, .blue, .yellow, .gray, .red, .brown, .green, .orange, .purple]
    
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
    
    //let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    lazy var collectionView: UICollectionView = {
        let iv = ColorLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 200, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: iv)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
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
        
        guard let color = project.color else { return }
        
        confirmColor = color
        view.backgroundColor = confirmColor
        
    }
    
    @objc func save(){
        if project == nil{
            let newProject = Project(context: coreDataStack!.managedContext)
            newProject.title = titleText.text
            newProject.color = confirmColor
            coreDataStack?.saveContext()
        }else{
            project?.title = titleText.text
            project?.color = confirmColor
            coreDataStack?.saveContext()
        }
        notify.messageColor = .white
        self.view.makeToast("You made a new Project", duration: 3.0, position: .bottom, style: notify)
        self.navigationController?.popViewController(animated: true)
    }
    
//    func setupLeftImage(imageName: String){
//        imageView.image = UIImage(named: imageName)!
//              let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
//               imageContainerView.addSubview(imageView)
//        titleText.leftView = imageView
//        titleText.leftViewMode = .always
//        titleText.tintColor = .lightGray
//    }
    
    
    
    
}

extension AddNewProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = cell.frame.size.width/2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let cyan = UIColor.cyan
        cell?.isSelected = true
        cell?.layer.borderColor = cyan.cgColor
        cell?.layer.borderWidth = 5
        confirmColor = colors[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let clear = UIColor.clear
        cell?.isSelected = false
        cell?.layer.borderColor = clear.cgColor
    }
}

protocol ProjectEntryDelegate {
    func didSaveProject(vc: AddNewProjectViewController, didSave: Bool)
}
