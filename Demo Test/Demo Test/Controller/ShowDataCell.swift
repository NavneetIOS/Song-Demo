//
//  ShowDataCell.swift
//  Demo Test
//
//  Created by MAC-21 on 15/07/21.
//

import UIKit

class ShowDataCell: UITableViewCell {
    
    @IBOutlet weak var lblArtist:UILabel!
    @IBOutlet weak var lbltitle:UILabel!
    @IBOutlet weak var imguser:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
