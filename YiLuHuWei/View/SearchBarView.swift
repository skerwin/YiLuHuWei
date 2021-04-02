  //
//  SearchBarView.swift
 //
//  Created by YuliangTao on 16/3/1.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//

import UIKit

protocol SearchBarViewDelegate {
    func searchAction(searchText: String)
 }

class SearchBarView: UIView {
    
    var delegate: SearchBarViewDelegate!
    
    var searchTypeButtonWidth: CGFloat?
    
 
    init(frame: CGRect, searchTypeButtonWidth: CGFloat) {
        super.init(frame: frame)
        self.frame = frame
        self.searchTypeButtonWidth = searchTypeButtonWidth
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    var searchTextField: UITextField? // 搜索框
    
    func initView() {
     
       // init search textfield
        searchTextField = CustomTextField()
        searchTextField?.backgroundColor = UIColor.white
 
        searchTextField?.frame = CGRect.init(x: 7, y: 5, width: screenWidth - 85 , height: 35)
        searchTextField?.clearButtonMode = .whileEditing
        searchTextField?.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        searchTextField?.layer.borderWidth = 1
        searchTextField!.layer.cornerRadius = 12
        searchTextField!.returnKeyType = .search
        searchTextField!.delegate = self
        addSubview(searchTextField!)
//
//        /// add search icon
        searchTextField!.font = UIFont.systemFont(ofSize: 16)
          let searchIcon = UIImageView(frame: CGRect.init(x: 7, y: 7.5, width: 15, height: 15))
        searchIcon.image = UIImage(named: "icon_search_blue_bold")
//
 
        let leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 20))
        searchTextField?.leftView = leftView
        searchTextField!.leftView?.frame.origin.x = 15
        searchTextField!.leftViewMode = .always
        searchTextField!.addSubview(searchIcon)
        
    }
    
    func setPlaceHolder(holderText: String) {
        if let textField = searchTextField {
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) // Note the !
            ]

            textField.attributedPlaceholder = NSAttributedString(string: holderText, attributes: attributes)
        }
    }

}

extension SearchBarView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate.searchAction(searchText: textField.text!)
        return true
    }
}
