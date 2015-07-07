//
//  ChannelController.swift
//  DBFM
//
//  Created by noprom on 15/7/2.
//  Copyright (c) 2015年 noprom. All rights reserved.
//

import UIKit

class ChannelController: UIViewController ,UITableViewDelegate{
    
    // 频道列表
    @IBOutlet weak var tv: UITableView!
    
    // 申明代理
    var delegate:ChannelProtocol?
    
    // 频道列表的数据
    var channelData:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.8
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
    
    // 选中了某个item
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 获取行数据
        let rowData:JSON = self.channelData[indexPath.row] as JSON
        // 获取选中的行的频道id
        let channelId:String = rowData["channel_id"].stringValue
        // 将频道id返回给主界面
        delegate?.onChangeChannel(channelId)
        // 关闭当前界面
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 设置cell的动画效果
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // 设置cell的动画显示为3d缩放，xy方向的缩放效果，初始值为0.1，结束值为1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

}

protocol ChannelProtocol{
    // 回调方法，将频道id传回代理
    func onChangeChannel(channelId:String)
}