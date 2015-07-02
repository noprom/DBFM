
//
//  ViewController.swift
//  DBFM
//
//  Created by noprom on 15/7/2.
//  Copyright (c) 2015年 noprom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 歌曲封面
    @IBOutlet weak var iv: EkoImage!
    //背景
    @IBOutlet weak var bg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 旋转
        iv.onRotation()
        
        //设置背景模糊
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        bg.addSubview(blurView)

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

