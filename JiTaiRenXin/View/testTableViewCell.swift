//
//  testTableViewCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class testTableViewCell: UITableViewCell {

    
    var contentLable:UILabel = UILabel()
    var autoCellHeight: CGFloat = 0
    var readCommentToolView:ReadCommentToolView = (Bundle.main.loadNibNamed("ReadCommentToolView", owner: nil, options: nil)!.first as? ReadCommentToolView)!
    var readCommentTitleView:ReadCommentTitleView = (Bundle.main.loadNibNamed("ReadCommentTitleView", owner: nil, options: nil)!.first as? ReadCommentTitleView)!
    var content:String = ""
    var titleHeight: CGFloat  = 44.0
    var toolHeight: CGFloat  = 32.0
    var contentHeight: CGFloat  = 44
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
               
     var modelCase:CaseModel? {
            didSet {
                
                

                readCommentToolView.frame = CGRect.init(x: 0, y:titleHeight + contentHeight, width: screenWidth, height: toolHeight)
                self.contentView.addSubview(readCommentToolView)
//                view1 = UIView.init(frame: CGRect.init(x: 0, y: titleHeight + contentHeight, width: screenWidth, height: 35))
//                view1!.addSubview(readCommentToolView)
//                self.contentView.addSubview(view1!)

                readCommentTitleView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: titleHeight)
                self.contentView.addSubview(readCommentTitleView)
//                view2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: titleHeight))
//                view2!.addSubview(readCommentTitleView)
//                self.contentView.addSubview(view2!)
                
                
                
                content = (modelCase?.desc)!
                                      
                contentLable.text = content
                contentLable.font=UIFont.systemFont(ofSize: 16)
                
                contentLable.numberOfLines=0
                contentLable.lineBreakMode = NSLineBreakMode.byWordWrapping
            
                contentLable.frame = CGRect(x:15,y:titleHeight,width: screenWidth - 25, height: contentHeight )
                    
                self.contentView.addSubview(contentLable)
                
                
                
                readCommentToolView.headImage.displayHeadImageWithURL(url: modelCase?.publisher?.avatar_url)
                readCommentToolView.writerLabel.text = modelCase?.publisher?.name
                readCommentTitleView.titleLable.text = modelCase?.title
                readCommentToolView.readCountLabel.text = "\(modelCase?.hits ?? 0)"
                readCommentToolView.commentCountLabel.text = "\(modelCase?.comments ?? 0)"
                readCommentToolView.goodeLabel.text = "\(modelCase?.likes ?? 0)"
                
             }
     }
    
    
    var model:ArticleModel? {
             didSet {
                    readCommentToolView.frame = CGRect.init(x: 0, y:titleHeight + contentHeight, width: screenWidth, height: toolHeight)
                    self.contentView.addSubview(readCommentToolView)
 
                     readCommentTitleView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: titleHeight)
                    self.contentView.addSubview(readCommentTitleView)
  
                    content = (model?.desc)!
                                          
                    contentLable.text = (model?.desc)!
                    contentLable.font=UIFont.systemFont(ofSize: 16)
                    
                    contentLable.numberOfLines=0
                    contentLable.lineBreakMode = NSLineBreakMode.byWordWrapping
                
                    contentLable.frame = CGRect(x:15,y:titleHeight,width: screenWidth - 25, height: contentHeight )
                        
                    self.contentView.addSubview(contentLable)
                    
                    
                    
                readCommentToolView.headImage.displayHeadImageWithURL(url: model?.publisher?.avatar_url)
                readCommentToolView.writerLabel.text = model?.publisher?.name
                readCommentTitleView.titleLable.text = model?.title
                readCommentToolView.readCountLabel.text =  "\(model?.hits ?? 0)"
                readCommentToolView.commentCountLabel.text = "\(model?.comments ?? 0)"
                readCommentToolView.goodeLabel.text = "\(model?.likes ?? 0)"
               
            }
    }
   
}

