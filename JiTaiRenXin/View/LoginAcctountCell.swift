//
//  LoginAcctountCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/10/19.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol LoginAcctountCellDelegate: class {
    func saveToAccount(text:String)
 
}
 

class LoginAcctountCell: UITableViewCell {

    @IBOutlet weak var accountTextField: UITextField!
    weak var delegate:LoginAcctountCellDelegate?
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accountTextField!.delegate = self

        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension LoginAcctountCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let account = textField.text
        delegate!.saveToAccount(text: account ?? "")
        return true
    }
}
