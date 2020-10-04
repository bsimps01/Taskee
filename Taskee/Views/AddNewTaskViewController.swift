//
//  AddNewTaskViewController.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/28/20.
//

import Foundation
import UIKit
import CoreData


class AddNewTaskViewController: UIViewController {
    
    var coreDataStack: CoreDataStack?
    var project: Projects?
    
    let images: [UIImage] = [UIImage(named: "school")!, UIImage(named: "gift")!, UIImage(named: "health")!, UIImage(named: "home")!, UIImage(named: "lifting")!, UIImage(named: "pray")!, UIImage(named: "shopping")!, UIImage(named: "trip")!, UIImage(named: "working")!]
    
    var titleText: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Name of Project"
        text.leftView = UIImageView()
        return text
    }()
    
    lazy var collectionView: UICollectionView = {
        let iv = ImageLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: iv)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    
    var imageSelection: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        //setupLeftImage(imageName: images)
        self.title = "New/Edit Project"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        setup()
        
        if project != nil {
            config()
        }
        
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
    
    fileprivate func config(){
        guard let project = project else { return }
        
        titleText.text = project.title
    }
    
    @objc func save(){
        if project == nil{
            let newProject = Projects(context: coreDataStack!.managedContext)
            newProject.title = titleText.text
            coreDataStack?.saveContext()
        }else{
            project?.title = titleText.text
            coreDataStack?.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLeftImage(imageName: String?){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: (imageName)!)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        titleText.leftView = imageContainerView
        titleText.leftViewMode = .always
        titleText.tintColor = .lightGray
    }
    
    
    
    
}

extension AddNewTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.titleText.leftView = images[indexPath.count]
    }
    
    
}
