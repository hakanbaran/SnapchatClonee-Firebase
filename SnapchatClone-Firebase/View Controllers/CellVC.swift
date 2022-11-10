//
//  CellVC.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 7.11.2022.
//

import UIKit

class CellVC: UITableViewCell {

    //@IBOutlet weak var snapUsernameLabel: UILabel!
    @IBOutlet weak var snapImageView: UIImageView!
    @IBOutlet weak var snapUsernameLAbel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
