//
//  TODOCell.swift
//  To_Do_List_App_With_Tableview_Methods_Swif_4
//
//  Created by DeEp KapaDia on 06/07/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit



class TODOCell: UITableViewCell {

    @IBOutlet weak var LBLtxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentView.backgroundColor = UIColor.white
        
    }
    
}

