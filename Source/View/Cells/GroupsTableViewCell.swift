//
//  GroupsTableViewCell.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 2/6/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

internal class GroupsTableViewCell: UITableViewCell {
    
    public static let identifier: String = "GroupsTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var customBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        addSpecifiedShadow(customBackgroundView)
    }
}
