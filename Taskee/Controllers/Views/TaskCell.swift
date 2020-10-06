//
//  TaskCell.swift
//  Taskee
//
//  Created by Benjamin Simpson on 10/5/20.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    
static var identifier = "TaskCell"

let check = CheckBox.init()
var tapCheck: (()->Void)?

let taskLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = UIFont(name: "system", size: 12)
    return label
}()

let dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: "system", size: 10)
    label.textColor = .systemGray
    return label
}()

override func awakeFromNib() {
    super.awakeFromNib()
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
}

func setup(){
    self.contentView.addSubview(check)
    self.contentView.addSubview(taskLabel)
    self.contentView.addSubview(dateLabel)
    check.frame = CGRect(x: 25, y: 25, width: 35, height: 35)
    check.style = .tick
    check.borderStyle = .roundedSquare(radius: 8)
    check.addTarget(self, action: #selector(todoChecked(_:)), for: .valueChanged)
    
    check.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    check.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
    taskLabel.topAnchor.constraint(equalTo: check.topAnchor).isActive = true
    taskLabel.leadingAnchor.constraint(equalTo: check.trailingAnchor, constant: 20).isActive = true
    dateLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 5).isActive = true
    dateLabel.leadingAnchor.constraint(equalTo: check.trailingAnchor, constant: 20).isActive = true
        
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
}

@objc func todoChecked(_ sender: CheckBox) {
    tapCheck!()
}

}

