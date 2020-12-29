//
//  ReportSmallCell.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/07/24.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class ReportSmallCell: UICollectionViewCell {
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var contentBg1: UIView!
    @IBOutlet weak var contentBg2: UIView!
    @IBOutlet weak var contentBg3: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var more: UIButton!
    var parentNavigationController: UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = ZYJColor.main
        more.setTitleColor(ZYJColor.main, for: .normal)
        more.titleLabel?.textColor = ZYJColor.main
        
        bgview.layer.borderWidth = 0.5;
         bgview.layer.cornerRadius = 13;
        
        bgview.layer.borderColor = ZYJColor.main.cgColor
        
        addGestureRecognizerToView(view: contentBg1, target: self, actionName: "ContentBgView1Action")
        addGestureRecognizerToView(view: contentBg2, target: self, actionName: "ContentBgView2Action")
        addGestureRecognizerToView(view: contentBg3, target: self, actionName: "ContentBgView3Action")
        
        
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
            controller.menytype = MenuType.Report
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        
        
        
        
        
    }
    @objc func ContentBgView2Action(){
        
        if modelList!.count >= 2{
            let controller = ArcticleDetailController()
            controller.fid = modelList![1].id
            controller.menytype = MenuType.Report
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        
        
        
        
    }
    @objc func ContentBgView3Action(){
        
        if modelList!.count >= 3{
            let controller = ArcticleDetailController()
            controller.fid = modelList![2].id
            controller.menytype = MenuType.Report
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
        
        
        
        
        
    }
    
    @IBOutlet weak var sourceLabel1: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var headImage1: UIImageView!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var writer1: UILabel!
    @IBOutlet weak var lookCount1: UILabel!
    @IBOutlet weak var commentCount1: UILabel!
    
    
    @IBOutlet weak var sourceLabe2: UILabel!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var headImage2: UIImageView!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var writer2: UILabel!
    @IBOutlet weak var lookCount2: UILabel!
    @IBOutlet weak var commentCount2: UILabel!
    
    
    
    @IBOutlet weak var sourceLabel3: UILabel!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var headImage3: UIImageView!
    @IBOutlet weak var desc3: UILabel!
    @IBOutlet weak var writer3: UILabel!
    @IBOutlet weak var lookCount3: UILabel!
    @IBOutlet weak var commentCount3: UILabel!
    
    @IBAction func moreBtnAction(_ sender: Any) {
        let conroller = ChannelReportController()
        conroller.menupagetype = MenuPageType.HomeMore
        self.parentNavigationController?.pushViewController(conroller, animated: true)
    }
    
    var modelList:[CaseModel]? {
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
                sourceLabel1.text = modelList![0].source
                
            }else if modelList?.count == 2{
                image1.displayImageWithURL(url: modelList![0].img_url)
                headImage1.displayHeadImageWithURL(url: modelList![0].publisher?.avatar_url)
                desc1.text = modelList![0].title
                writer1.text = modelList![0].publisher?.name
                lookCount1.text = intToString(number: modelList![0].hits)
                commentCount1.text =  intToString(number: modelList![0].comments)
                sourceLabel1.text = modelList![0].source
                
                
                image2.displayImageWithURL(url: modelList![1].img_url)
                headImage2.displayHeadImageWithURL(url: modelList![1].publisher?.avatar_url)
                desc2.text = modelList![1].title
                writer2.text = modelList![1].publisher?.name
                lookCount2.text = intToString(number: modelList![1].hits)
                commentCount2.text = intToString(number: modelList![1].comments)
                sourceLabe2.text = modelList![1].source
                
            }else if modelList!.count >= 3{
                image1.displayImageWithURL(url: modelList![0].img_url)
                headImage1.displayHeadImageWithURL(url: modelList![0].publisher?.avatar_url)
                desc1.text = modelList![0].title
                writer1.text = modelList![0].publisher?.name
                lookCount1.text = intToString(number: modelList![0].hits)
                commentCount1.text =  intToString(number: modelList![0].comments)
                sourceLabel1.text = modelList![0].source
                
                
                image2.displayImageWithURL(url: modelList![1].img_url)
                headImage2.displayHeadImageWithURL(url: modelList![1].publisher?.avatar_url)
                desc2.text = modelList![1].title
                writer2.text = modelList![1].publisher?.name
                lookCount2.text = intToString(number: modelList![1].hits)
                commentCount2.text = intToString(number: modelList![1].comments)
                sourceLabe2.text = modelList![1].source
                
                image3.displayImageWithURL(url: modelList![2].img_url)
                headImage3.displayHeadImageWithURL(url: modelList![2].publisher?.avatar_url)
                desc3.text = modelList![2].title
                writer3.text = modelList![2].publisher?.name
                lookCount3.text = intToString(number: modelList![2].hits)
                commentCount3.text = intToString(number: modelList![2].comments)
                sourceLabel3.text = modelList![2].source
            }else{
                return
            }
        }
    }
}
