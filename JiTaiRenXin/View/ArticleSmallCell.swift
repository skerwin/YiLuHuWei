//
//  ArticleSmallCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ArticleSmallCell: UICollectionViewCell {
    
    var parentNavigationController: UINavigationController?
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var moretitle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = ZYJColor.main
        
        moretitle.titleLabel?.textColor = ZYJColor.main
        moretitle.setTitleColor(ZYJColor.main, for: .normal)
        
        bgView.layer.borderWidth = 0.5;
        bgView.layer.borderColor = ZYJColor.main.cgColor
        bgView.layer.cornerRadius = 13;
        
        //bgView.layer.borderColor = ZYJColor.mainLine.cgColor;
        addGestureRecognizerToView(view: ContentBgView1, target: self, actionName: "ContentBgView1Action")
        addGestureRecognizerToView(view: ContentBgView2, target: self, actionName: "ContentBgView2Action")
        addGestureRecognizerToView(view: ContentBgView3, target: self, actionName: "ContentBgView3Action")
        
        headImage1.layer.cornerRadius = 6;
        headImage2.layer.cornerRadius = 6;
        headImage3.layer.cornerRadius = 6;
        headImage1.layer.masksToBounds = true
        headImage2.layer.masksToBounds = true
        headImage3.layer.masksToBounds = true
        
        
        image1.layer.cornerRadius = 5;
        image2.layer.cornerRadius = 5;
        image3.layer.cornerRadius = 5;
        image1.layer.masksToBounds = true
        image2.layer.masksToBounds = true
        image3.layer.masksToBounds = true
        
        
        // Initialization code
    }
    
    
    @objc func ContentBgView1Action(){
        if modelList!.count >= 1{
            let controller = ArcticleDetailController()
            controller.fid = modelList![0].id
            controller.menytype = MenuType.Articel
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    @objc func ContentBgView2Action(){
        if modelList!.count >= 2{
            let controller = ArcticleDetailController()
            controller.fid = modelList![1].id
            controller.menytype = MenuType.Articel
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    @objc func ContentBgView3Action(){
        if modelList!.count >= 3{
            let controller = ArcticleDetailController()
            controller.fid = modelList![2].id
            controller.menytype = MenuType.Articel
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        
        
        
    }
    
    
    @IBAction func moreBtnAction(_ sender: Any) {
        let conroller = ChannelArticleController()
        conroller.menupagetype = MenuPageType.HomeMore
        self.parentNavigationController?.pushViewController(conroller, animated: true)
    }
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var ContentBgView1: UIView!
    @IBOutlet weak var ContentBgView2: UIView!
    @IBOutlet weak var ContentBgView3: UIView!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var headImage1: UIImageView!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var writer1: UILabel!
    @IBOutlet weak var lookCount1: UILabel!
    @IBOutlet weak var commentCount1: UILabel!
    
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var headImage2: UIImageView!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var writer2: UILabel!
    @IBOutlet weak var lookCount2: UILabel!
    @IBOutlet weak var commentCount2: UILabel!
    
    
    
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var headImage3: UIImageView!
    @IBOutlet weak var desc3: UILabel!
    @IBOutlet weak var writer3: UILabel!
    @IBOutlet weak var lookCount3: UILabel!
    @IBOutlet weak var commentCount3: UILabel!
    
    
    var modelList:[ArticleModel]? {
        didSet {
            if modelList?.count == 0{
                return
            }else if modelList?.count == 1{
                image1.displayImageWithURL(url: modelList![0].img_url)
                headImage1.displayHeadImageWithURL(url: modelList![0].publisher?.avatar_url)
                desc1.text = modelList![0].title
                writer1.text = modelList![0].publisher?.name
                lookCount1.text = intToString(number: modelList![0].hits)
                commentCount1.text =  intToString(number: modelList![0].comments)
            }else if modelList?.count == 2{
                image1.displayImageWithURL(url: modelList![0].img_url)
                headImage1.displayHeadImageWithURL(url: modelList![0].publisher?.avatar_url)
                desc1.text = modelList![0].title
                writer1.text = modelList![0].publisher?.name
                lookCount1.text = intToString(number: modelList![0].hits)
                commentCount1.text =  intToString(number: modelList![0].comments)
                image2.displayImageWithURL(url: modelList![1].img_url)
                headImage2.displayHeadImageWithURL(url: modelList![1].publisher?.avatar_url)
                desc2.text = modelList![1].title
                writer2.text = modelList![1].publisher?.name
                lookCount2.text = intToString(number: modelList![1].hits)
                commentCount2.text = intToString(number: modelList![1].comments)
            }else if modelList!.count >= 3{
                image1.displayImageWithURL(url: modelList![0].img_url)
                headImage1.displayHeadImageWithURL(url: modelList![0].publisher?.avatar_url)
                desc1.text = modelList![0].title
                writer1.text = modelList![0].publisher?.name
                lookCount1.text = intToString(number: modelList![0].hits)
                commentCount1.text =  intToString(number: modelList![0].comments)


                image2.displayImageWithURL(url: modelList![1].img_url)
                headImage2.displayHeadImageWithURL(url: modelList![1].publisher?.avatar_url)
                desc2.text = modelList![1].title
                writer2.text = modelList![1].publisher?.name
                lookCount2.text = intToString(number: modelList![1].hits)
                commentCount2.text = intToString(number: modelList![1].comments)


                image3.displayImageWithURL(url: modelList![2].img_url)
                headImage3.displayHeadImageWithURL(url: modelList![2].publisher?.avatar_url)
                desc3.text = modelList![2].title
                writer3.text = modelList![2].publisher?.name
                lookCount3.text = intToString(number: modelList![2].hits)
                commentCount3.text = intToString(number: modelList![2].comments)
            }else{
                return
            }
         }
    }
}
