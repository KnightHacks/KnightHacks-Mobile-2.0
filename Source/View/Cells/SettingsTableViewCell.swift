//
//  SettingsTableViewCell.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/3/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

internal class SettingsTableViewCell: UITableViewCell {
    
    public static let identifier: String = "SettingsTableViewCell"
    
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var model: SettingsMenuModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            buttonImageView.image = UIImage(named: model.imageName)
            buttonImageView.contentMode = .scaleAspectFit
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        addSpecifiedShadow(customBackgroundView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) { }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if let baseColor = self.backgroundColor?.rgba {
            self.backgroundColor = UIColor(red: baseColor.red, green: baseColor.green, blue: baseColor.blue, alpha: highlighted ? 0.65 : 1)
        }
    }
    
}
