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
    
    let projectTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura", size: 21)
        //label.textColor = .systemGreen
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = .systemGray2
        return label
    }()
    
    let colorSection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = view.frame.size.width/2
        return view
    }()
    
    init(color: String, title: String, tasks: Int) {
        super.init(style: .default, reuseIdentifier: "ProjectCell")
        projectTitle.text = title
        taskLabel.text = "\(tasks) tasks to do"
        colorSection.backgroundColor = UIColor(named: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTaskView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureTaskView(){
        contentView.addSubview(projectTitle)
        contentView.addSubview(taskLabel)
        contentView.addSubview(colorSection)
        
        projectTitle.leadingAnchor.constraint(equalTo: colorSection.leadingAnchor, constant: 70).isActive = true
        projectTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        projectTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        projectTitle.heightAnchor.constraint(equalToConstant: contentView.frame.height/2).isActive = true
            
        taskLabel.topAnchor.constraint(equalTo: projectTitle.bottomAnchor, constant: 5).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: colorSection.trailingAnchor, constant: 70).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
            
        colorSection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        colorSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        colorSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        colorSection.widthAnchor.constraint(equalToConstant: 50).isActive = true
    
    }
}
