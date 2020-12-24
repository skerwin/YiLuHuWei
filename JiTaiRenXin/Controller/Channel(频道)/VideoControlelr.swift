//
//  VideoControlelr.swift
//  JiTaiRenXin
//
//  Created by zhaoyuanjing on 2020/08/28.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

class VideoControlelr: UIViewController {

      var player:ZFPlayerController!
      var containerView:UIImageView!
      var controlView:ZFPlayerControlView!
      var playBtn:UIButton!  //暂时不用
      
      
      var assetURLs = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configPlayer(){
        
        //"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4")!]
        controlView = ZFPlayerControlView.init()
        controlView.fastViewAnimated = true;
        controlView.autoHiddenTimeInterval = 5;
        controlView.autoFadeTimeInterval = 0.5;
        controlView.prepareShowLoading = true;
        controlView.prepareShowControlView = true;
        
        
        playBtn = UIButton.init(type: .custom)
        playBtn.setImage(UIImage.init(named: "new_allPlay_44x44_@2x"), for: .normal)
        playBtn.addTarget(self, action:(#selector(playClick)), for: .touchUpInside)
        
        
        containerView = UIImageView.init()
        containerView.setImageWithURLString("zhanweitu1", placeholder:ZFUtilities.image(with: UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), size: CGSize.init(width: 1, height: 1)))
        self.containerView.frame = CGRect.init(x: 0, y: navigationHeaderAndStatusbarHeight, width: screenWidth, height: screenWidth*9/16)
        
        let playerManager = ZFAVPlayerManager.init()
        self.player = ZFPlayerController.player(withPlayerManager: playerManager, containerView: containerView)
        self.player.controlView = self.controlView;
        /// 设置退到后台不播放
        
        self.player.pauseWhenAppResignActive = true;
        self.player.resumePlayRecord = false;
        
    }
    
    
    
    @objc func playClick(){
           self.player.playTheIndex(0)
           self.controlView.showTitle("视频详情", cover: UIImage.init(named: "zhanweitu2"), fullScreenMode: .automatic)
           // self.controlView.showTitle(VideoTitle, coverURLString: kVideoCover, fullScreenMode: .automatic)
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
