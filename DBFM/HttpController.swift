//
//  HttpController.swift
//  DBFM
//
//  Created by noprom on 15/7/2.
//  Copyright (c) 2015年 noprom. All rights reserved.
//

import UIKit

class HttpController:NSObject{
    // 定义一个代理
    var delegate:HttpProtocol?
    
    /**
    接受网址，回调代理的方法传回数据
    
    :param: url <#url description#>
    */
    func onSearch(url:String){
        Alamofire.manager.request(Method.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            (_, _, data, error) -> Void in
            self.delegate?.didReceiveResults(data!)
        }
    }
}

// 定义一个协议
protocol HttpProtocol{
    // 定义一个方法，接受一个参数，类型是AnyObject
    func didReceiveResults(result:AnyObject)
}