
//
//  ViewController.swift
//  DBFM
//
//  Created by noprom on 15/7/2.
//  Copyright (c) 2015年 noprom. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate,HttpProtocol{

    //EkoImage组件，歌曲封面
    @IBOutlet weak var iv: EkoImage!
    //歌曲列表
    @IBOutlet weak var tv: UITableView!
    //背景
    @IBOutlet weak var bg: UIImageView!
    
    // 网络操作类的实例
    var eHttp:HttpController = HttpController()
    
    // 定义一个变量来接收频道歌曲的数据
    var tableData:[JSON] = []
    // 定义一个变量来接收频道的数据
    var channelData:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iv.onRotation()
        //设置背景模糊
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        bg.addSubview(blurView)
        
        //设置tbaleView的数据源和代理
        tv.dataSource = self
        tv.delegate = self
        
        // 为网络操作类设置代理
        eHttp.delegate = self
        // 获取频道的数据
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        // 获取频道为0的歌曲的数据
        eHttp.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
    }
    //设置tableview的数据行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    //配置tableView的单元格 cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("douban") as! UITableViewCell
        // 获取每一行的数据
        let rowData:JSON = tableData[indexPath.row]
        println("rowData = \(rowData)")
        // cell的标题
        
        cell.textLabel?.text = rowData["title"].string
        cell.detailTextLabel?.text = rowData["artist"].string
        //设置缩略图
        cell.imageView?.image = UIImage(named: "thumb")
        
        // 封面的网址
        let url = rowData["picture"].string
        Alamofire.manager.request(Method.GET, url!).response { (_, _, data, error) -> Void in
            // 填充给UIImage
            let img = UIImage(data: data! as! NSData)
            // 设置封面
            cell.imageView?.image = img
        }
        
        return cell
    }
    
    // 接收到数据后的回调方法
    func didReceiveResults(result: AnyObject) {
        let json = JSON(result)
        // 判断是否是频道的数据
        if let channels = json["channels"].array{
            self.channelData = channels
        }else if let song = json["song"].array{
            self.tableData = song
            // 刷新tableview的数据
            self.tv.reloadData()
        }
        println("channelData = \(channelData)")
         println("tableData = \(tableData)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

