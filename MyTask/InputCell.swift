//
//  InputCell.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/02/01.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {
    @IBOutlet weak var weightImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
