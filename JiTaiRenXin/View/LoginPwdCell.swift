//
//  LoginPwdCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/10/19.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit


protocol LoginPwdCellDelegate: class {
    func saveToPwd(text:String)
 
}

class LoginPwdCell: UITableViewCell {

    
    @IBOutlet weak var pwdTextField: UITextField!
    
    weak var delegate:LoginPwdCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pwdTextField!.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
extension LoginPwdCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let account = textField.text
        delegate!.saveToPwd(text: account ?? "")
        return true
    }
}
