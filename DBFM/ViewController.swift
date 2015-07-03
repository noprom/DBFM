
//
//  ViewController.swift
//  DBFM
//
//  Created by noprom on 15/7/2.
//  Copyright (c) 2015年 noprom. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,HttpProtocol,ChannelProtocol {
    //EkoImage组件，歌曲封面
    @IBOutlet weak var iv: EkoImage!
    //歌曲列表
    @IBOutlet weak var tv: UITableView!
    //背景
    @IBOutlet weak var bg: UIImageView!
    
    //网络操作类的实例
    var eHttp:HttpController = HttpController()
    
    //定义一个变量，接收频道的歌曲数据
    var tableData:[JSON] = []
    
    //定义一个变量，接收频道的数据
    var channelData:[JSON] = []
    
    //定义一个图片缓存的字典
    var imageCache = Dictionary<String,UIImage>()
    
    // 媒体播放器的实例
    var audioPlayer:MPMoviePlayerController = MPMoviePlayerController()
    
    
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
        
        //为网络操作类设置代理
        eHttp.delegate = self
        //获取频道数据
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        //获取频道为0歌曲数据
        eHttp.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
        
        //让tableView背景透明
        tv.backgroundColor = UIColor.clearColor()
    }
    
    //设置tableview的数据行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    //配置tableView的单元格 cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("douban") as! UITableViewCell
        //让cell背景透明
        cell.backgroundColor = UIColor.clearColor()
        //获取cell的数据
        let rowData:JSON = tableData[indexPath.row]
        //设置cell的标题
        cell.textLabel?.text = rowData["title"].string
        cell.detailTextLabel?.text = rowData["artist"].string
        //设置缩略图
        cell.imageView?.image = UIImage(named: "thumb")
        //封面的网址
        let url = rowData["picture"].string
        
        onGetCacheImage(url!, imgView: cell.imageView!)
        
        return cell
    }
    
    //点击了哪一首歌曲
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        onSelectRow(indexPath.row)
    }
    
    //选中了哪一行
    func onSelectRow(index:Int){
        //构建一个indexPath
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        //选中的效果
        tv.selectRowAtIndexPath(indexPath!, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        //获取行数据
        var rowData:JSON = self.tableData[index] as JSON
        //获取该行图片的地址
        let imgUrl = rowData["picture"].string
        //设置封面以及背景
        onSetImage(imgUrl!)
        
        // 获取播放的音乐的地址
        var url:String = rowData["url"].string!
        // 播放音乐
        onSetAudio(url)
    }
    
    //设置歌曲的封面以及背景
    func onSetImage(url:String){
        onGetCacheImage(url, imgView: self.iv)
        onGetCacheImage(url, imgView: self.bg)
    }
    
    //图片缓存策略方法
    func onGetCacheImage(url:String,imgView:UIImageView){
        //通过图片地址去缓存中取图片
        let image = self.imageCache[url] as UIImage?
        
        if image == nil {
            //如果缓存中没有这张图片，就通过网络获取
            Alamofire.manager.request(Method.GET, url).response({ (_, _, data, error) -> Void in
                //将获取的图像数据赋予imgView
                let img = UIImage(data: data! as! NSData)
                imgView.image = img
                
                // 存储缓存
                self.imageCache[url] = img
            })
        }else{
            //如果缓存中有，就直接用
            imgView.image = image!
        }
    }
    
    // 接收到数据后的回调方法
    func didReceiveResults(results:AnyObject){
        //        println("获取到得数据：\(results)")
        let json = JSON(results)
        
        //判断是否是频道数据
        if let channels = json["channels"].array {
            self.channelData = channels
        }else if let song = json["song"].array {
            self.tableData = song
            //刷新tv的数据
            self.tv.reloadData()
            //设置第一首歌的图片以及背景
            onSelectRow(0)
        }
    }
    
    // 播放音乐的方法
    func onSetAudio(url:String){
        self.audioPlayer.stop()
        self.audioPlayer.contentURL = NSURL(string:url)
        self.audioPlayer.play()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //获取跳转目标
        var channelC:ChannelController = segue.destinationViewController as! ChannelController
        //设置代理
        channelC.delegate = self
        //传输频道列表数据
        channelC.channelData = self.channelData
    }
    
    //频道列表协议的回调方法
    func onChangeChannel(channel_id:String){
        //拼凑频道列表的歌曲数据网络地址
        //http://douban.fm/j/mine/playlist?type=n&channel= 频道id &from=mainsite
        let url:String = "http://douban.fm/j/mine/playlist?type=n&channel=\(channel_id)&from=mainsite"
        eHttp.onSearch(url)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

