//
//  TODOCell.swift
//  To_Do_List_App_With_Tableview_Methods_Swif_4
//
//  Created by DeEp KapaDia on 06/07/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit

protocol TODOCellDelegate {
    
    func DidDelete (_ cell:TODOCell)
    func DidComplete(_ cell:TODOCell)
    func DidShare (_ cell:TODOCell)
}

class TODOCell: UITableViewCell {

    @IBOutlet weak var LBLtxt: UILabel!
    
    var delegate:TODOCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func CompleteBtn(_ sender: UIButton) {
        
        if let delegateObj = self.delegate {
            
            delegateObj.DidComplete(self)
            
        }
        
    }
   
    @IBAction func ShareBtn(_ sender: UIButton) {
        
        if let delegateObj = self.delegate {
            
            delegateObj.DidShare(self)
            
        }
        
    }
        

    
    
    @IBAction func DeleteBtn(_ sender: UIButton) {
        
        
        if let delegateObj = self.delegate {
            
            delegateObj.DidDelete(self)
            
        }
        
    }
    
}

