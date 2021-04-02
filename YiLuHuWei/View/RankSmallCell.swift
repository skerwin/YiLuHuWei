//
//  ArticleSmallCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class RankSmallCell: UICollectionViewCell {
    
    var parentNavigationController: UINavigationController?
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageTitle: UIImageView!
    
    @IBOutlet weak var ContentBgView1: UIView!
    @IBOutlet weak var ContentBgView2: UIView!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var headImage1: UIImageView!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var writer1: UILabel!
    @IBOutlet weak var lookCount1: UILabel!
    @IBOutlet weak var commentCount1: UILabel!
    @IBOutlet weak var likeCount1: UILabel!
    
    
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var headImage2: UIImageView!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var writer2: UILabel!
    @IBOutlet weak var lookCount2: UILabel!
    @IBOutlet weak var commentCount2: UILabel!
    @IBOutlet weak var likeCount2: UILabel!
    
    
    var type = 1  //1文章2病例3视频
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
       
        bgView.layer.cornerRadius = 15;
        bgView.layer.masksToBounds = true
        
        
//
        addGestureRecognizerToView(view: ContentBgView1, target: self, actionName: "ContentBgView1Action")
        addGestureRecognizerToView(view: ContentBgView2, target: self, actionName: "ContentBgView2Action")
       
//
        headImage1.layer.cornerRadius = 6;
        headImage2.layer.cornerRadius = 6;
        headImage1.layer.masksToBounds = true
        headImage2.layer.masksToBounds = true


        image1.layer.cornerRadius = 4;
        image2.layer.cornerRadius = 4;
        image1.layer.masksToBounds = true
        image2.layer.masksToBounds = true
        
      
    }
    
    
    func isNative() -> Bool{
        if (stringForKey(key: "ios_orig") != nil && stringForKey(key: "ios_orig") != "" && stringForKey(key: "ios_orig") == "1") {
            return true
        }else{
            return false
        }
    }
    
    @objc func ContentBgView1Action(){
        if modelList!.count == 0{
            return
        }
        if type == 1{
            let controller = ArcticleDetailController()
            controller.fid = modelList![0].id
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }else if type == 2{
            let controller = ArcticleDetailController()
            controller.isCases = true
            controller.fid = modelList![0].id
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        else{
            let controller = VideoContentController()
            controller.fid = modelList![0].id
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func ContentBgView2Action(){
        if modelList!.count == 0 || modelList!.count == 1{
            return
        }
        
        if type == 1{
            let controller = ArcticleDetailController()
            controller.fid = modelList![1].id
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }else if type == 2{
            let controller = ArcticleDetailController()
            controller.isCases = true
            controller.fid = modelList![1].id
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        else{
            let controller = VideoContentController()
            controller.fid = modelList![1].id
            self.parentNavigationController?.pushViewController(controller, animated: true)
            
        }
      
    }
    
    var modelList:[AVCModel]? {
        didSet {
            if modelList?.count == 0{
                return
            }else if modelList?.count == 1{
                if type == 2 {
                    image1.image = UIImage.init(named: "")
                }else{
                    image1.displayImageWithURL(url: modelList![0].thumbnail)
                }
                 headImage1.displayHeadImageWithURL(url: modelList![0].avatar_url)
                if modelList![0].post_title == "" {
                    desc1.text = modelList![0].title
                }else{
                    desc1.text = modelList![0].post_title
                }
                
                writer1.text = modelList![0].user_nickname
                lookCount1.text = modelList![0].format_post_hits
                commentCount1.text = modelList![0].format_comment_count
                likeCount1.text = modelList![0].format_post_like
             }else{
                if type == 2 {
                    image1.image = UIImage.init(named: "")
                }else{
                    image1.displayImageWithURL(url: modelList![0].thumbnail)
                }
                headImage1.displayHeadImageWithURL(url: modelList![0].avatar_url)
                if modelList![0].post_title == "" {
                    desc1.text = modelList![0].title
                }else{
                    desc1.text = modelList![0].post_title
                }
                writer1.text = modelList![0].user_nickname
                lookCount1.text = modelList![0].format_post_hits
                commentCount1.text = modelList![0].format_comment_count
                likeCount1.text = modelList![0].format_post_like
                
 
                if type == 2 {
                    image2.image = UIImage.init(named: "")
                }else{
                    image2.displayImageWithURL(url: modelList![1].thumbnail)
                }
                headImage2.displayHeadImageWithURL(url: modelList![1].avatar_url)
                if modelList![1].post_title == "" {
                    desc2.text = modelList![1].title
                }else{
                    desc2.text = modelList![1].post_title
                }
                writer2.text = modelList![1].user_nickname
                lookCount2.text = modelList![1].format_post_hits
                commentCount2.text = modelList![1].format_comment_count
                likeCount2.text = modelList![1].format_post_like
            }
         }
    }
}
