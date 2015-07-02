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
    override func viewDidLoad() {
        super.viewDidLoad()
        // 旋转
        iv.onRotation()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

