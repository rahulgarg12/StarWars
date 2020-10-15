//
//  SWListTableCell.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit

final class SWListTableCell: SWTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryType = .disclosureIndicator
    }
    
    func set(people: SWPeopleResultModel) {
        nameLabel.text = people.name
    }
}
