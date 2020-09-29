//
//  TaskCell.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/28/20.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    static var identifier = "TaskCell"
    
    let taskTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Times New Roman", size: 21)
        label.textColor = .systemBlue
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = .systemGray2
        return label
    }()
    
    let colorSelection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = view.frame.size.width/2
        return view
    }()
    
    init(color: String, title: String, tasks: Int) {
        super.init(style: .default, reuseIdentifier: "TaskCell")
        taskTitle.text = title
        taskLabel.text = "\(tasks) tasks to do"
        colorSelection.backgroundColor = UIColor(named: color)
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
        contentView.addSubview(colorSelection)
        
        NSLayoutConstraint.activate([
            taskTitle.leadingAnchor.constraint(equalTo: colorSelection.leadingAnchor, constant: 10),
            taskTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            taskTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            taskTitle.heightAnchor.constraint(equalToConstant: contentView.frame.height/2),
            
            taskLabel.topAnchor.constraint(equalTo: taskTitle.bottomAnchor, constant: 5),
            taskLabel.leadingAnchor.constraint(equalTo: colorSelection.trailingAnchor, constant: 10),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            
            colorSelection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            colorSelection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            colorSelection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            colorSelection.widthAnchor.constraint(equalToConstant: 50),
        
        ])
    }
}
