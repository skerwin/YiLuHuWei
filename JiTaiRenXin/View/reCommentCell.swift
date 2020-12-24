//
//  reCommentCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/14.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class reCommentCell: UITableViewCell {
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var contentlabel: UILabel!
    @IBOutlet weak var publishlabel: UILabel!
    
 
    var model:CommentModel?
    
 
    func configModel(){
        headImage.displayHeadImageWithURL(url: model?.users?.avatar_url)
        
        if (model?.users?.nickname.isLengthEmpty())! {
            nameLable.text = model?.users?.mobile
        }else{
            nameLable.text = model?.users?.nickname
        }
        
        var parentName = ""
 
        if (model?.parent_user?.nickname.isLengthEmpty())! {
            parentName = model?.parent_user?.mobile ?? ""
        }else{
            parentName = model?.parent_user?.nickname ?? ""
        }
 
        let ranStr = "@" + nameLable.text! + "  "
        let cintent = model?.content
        let strg = ranStr + cintent!
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
        //颜色处理的范围
        let str = NSString(string: strg)
        let theRange = str.range(of: ranStr)
        //颜色处理
        
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:ZYJColor.main, range: theRange)
        //行间距
        
        let paragraphStye = NSMutableParagraphStyle()
        
        paragraphStye.lineSpacing = 5
        
        //行间距的范围
        let distanceRange = NSMakeRange(0, CFStringGetLength(strg as CFString?))
        
        attrstring .addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: distanceRange)
        contentlabel.attributedText = attrstring//赋值方法
        
        publishlabel.text = DateUtils.timeStampToStringDetail("\(String(describing: model!.created_at))")
        //时间戳转换
        // publishlabel.text = DateUtils.timeStampToStringDetail((model?.createtime)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 17;
        headImage.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
