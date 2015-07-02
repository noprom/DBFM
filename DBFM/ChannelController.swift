//
//  ChannelController.swift
//  DBFM
//
//  Created by noprom on 15/7/2.
//  Copyright (c) 2015年 noprom. All rights reserved.
//

import UIKit

class ChannelController: UIViewController {
    
    // 频道列表
    @IBOutlet weak var tv: UITableView!
    
    // 申明代理
    var detegate:ChannelController?
    
    // 频道列表的数据
    var channelData:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // 配置数据源的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }
    
    // 配置cell的数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("channel") as! UITableViewCell
        // 获取行数据
        let rowData:JSON = self.channelData[indexPath.row] as JSON
        
        //设置cell的标题
        cell.textLabel?.text = rowData["name"].string
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

}

protocol ChannelProtocol{
    // 回调方法，将频道id传回代理
    func onChangeChannel(channelId:String)
}