//
//  LoginCodeCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/10/19.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit


protocol LoginCodeCellDelegate: class {
    func saveToCode(text:String)
    func sendCode()
    
}

class LoginCodeCell: UITableViewCell {

    @IBOutlet weak var codeTextView: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    
    weak var delegate:LoginCodeCellDelegate?
    
    @IBAction func ButAction(_ sender: Any) {
        delegate!.sendCode()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        codeBtn.layer.cornerRadius = 6;
        codeBtn.layer.masksToBounds = true;
        codeBtn.layer.borderWidth = 0.5

        codeBtn.layer.borderColor = ZYJColor.main.cgColor
        
        codeTextView!.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension LoginCodeCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let account = textField.text
        delegate!.saveToCode(text: account ?? "")
        return true
    }
}
