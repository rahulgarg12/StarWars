//
//  SWDetailViewTableCell.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit

final class SWDetailViewTableCell: SWTableViewCell {
    @IBOutlet private weak var headingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func set(title: String?) {
        headingLabel.text = title
    }
}
