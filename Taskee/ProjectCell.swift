//
//  TaskCell.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/28/20.
//

import Foundation
import UIKit

class ProjectCell: UITableViewCell {
    static var identifier = "ProjectCell"
    
    let taskTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Times New Roman", size: 21)
        label.textColor = .systemGreen
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = .systemGray2
        return label
    }()
    
    let imageSection: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = view.frame.size.width/2
        return view
    }()
    
    init(image: String, title: String, tasks: Int) {
        super.init(style: .default, reuseIdentifier: "ProjectCell")
        taskTitle.text = title
        taskLabel.text = "\(tasks) tasks to do"
        imageSection.image = UIImage(named: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTaskView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureTaskView(){
        contentView.addSubview(taskTitle)
        contentView.addSubview(taskLabel)
        contentView.addSubview(imageSection)
        
        NSLayoutConstraint.activate([
            taskTitle.leadingAnchor.constraint(equalTo: imageSection.leadingAnchor, constant: 10),
            taskTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            taskTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            taskTitle.heightAnchor.constraint(equalToConstant: contentView.frame.height/2),
            
            taskLabel.topAnchor.constraint(equalTo: taskTitle.bottomAnchor, constant: 5),
            taskLabel.leadingAnchor.constraint(equalTo: imageSection.trailingAnchor, constant: 10),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            
            imageSection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            imageSection.widthAnchor.constraint(equalToConstant: 50),
        
        ])
    }
}
