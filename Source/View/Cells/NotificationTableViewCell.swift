//
//  NotificationTableViewCell.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 2/4/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

internal class NotificationTableViewCell: UITableViewCell {
    
    public static let identifier: String = "NotificationTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var customBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        addSpecifiedShadow(customBackgroundView)
    }
}
