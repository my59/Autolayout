//
//  DemoVC10.swift
//  AutoLayout
//
//  Created by yuency on 16/10/2017.
//  Copyright © 2017 yuency. All rights reserved.
//

import UIKit
import Alamofire

private let ThreeFirstCell_ID = "ThreeFirstCell_ID"

class DemoVC10: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    ///表格
    lazy var tv: UITableView = {
        let tvView = UITableView(frame: self.view.bounds)
        tvView.separatorColor = UIColor.clear
        tvView.delegate = self
        tvView.dataSource = self
        tvView.backgroundColor = UIColor.brown
        tvView.register(ThreeFirstCell.self, forCellReuseIdentifier: ThreeFirstCell_ID)
        return tvView
    }()
    
    
    
    
    ///数据列表
    var listArry = Array<ThreeModel>()
    
    ///翻页
    var page = 0
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         本demo由SDAutoLayout库的使用者“李西亚”提供，感谢“李西亚”对本库的关注与支持！
         */
        
        /*
         本demo日夜间主题切换由SDAutoLayout库的使用者“LEE”提供，感谢“LEE”对本库的关注与支持！
         */
        
        //LEETheme 分为两种模式 , 默认设置模式 标识符设置模式 , 朋友圈demo展示的是默认设置模式的使用 , 微信聊天demo和Demo10 展示的是标识符模式的使用
        
        
        view.addSubview(tv)
        
        
        //这里请求一次数据
        loadData()
        
    }
    
    ///请求数据
    private func loadData() {
        
        let urlString = "http://c.m.163.com/nc/article/headline/T1348647853363/\(self.page)-20.html"
        print("接口地址 \(urlString)")
        
        Alamofire.request(urlString).responseJSON { (json) in
            
            
            
            switch json.result {
                
            case .success:  //网络请求成功,解析网络
                
                
                //MARK: -  这绝对是一个重大的姿势调整!!!!!!!!
                // 顶部结点是一个数组, 从顶部结点拆分这些数据, 遍历数组制造模型
                
                if let topDic = json.result.value as? [String: Any] {
                    
                    //首先获取这个顶部结点的 key
                    let keyName = Array(topDic.keys)[0];
                    
                    //然后获取这个数组
                    let array = topDic[keyName] as? [Any];
                    
                    //遍历数组,对模型赋值
                    for dic in array ?? [] {
                        guard let model = ThreeModel.yy_model(withJSON: dic) else {
                            continue
                        }
                        self.listArry.append(model)
                    }
                }
                
                
                self.tv.reloadData()
                
                
            case .failure(let error):  //网络请求失败, 解析本地文件
                
                print("网络请求失败,解析本地文件 + \(error)")
            }
            
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let model = listArry[indexPath.row]
        
        
        //        if model.hasHead == 1 {
        //
        //            return "ThreeFourthCell"
        //
        //        } else if (threeModel.imgType == 1) {
        //
        //
        //            return "ThreeThirdCell"
        //
        //
        //        } else if (threeModel.imgextra?.count != nil) {
        //
        //
        //            return "ThreeSecondCell"
        //
        //
        //        } else {
        //
        //
        //            return "ThreeFirstCell"
        //        }
        //
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ThreeFirstCell_ID, for: indexPath) as! ThreeFirstCell
        cell.threeModel = model
        
        
        
        
        
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        cell.sd_tableView = tableView
        cell.sd_indexPath = indexPath
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = listArry[indexPath.row]
        
        return tv.cellHeight(for: indexPath, model: model, keyPath: "threeModel", cellClass: ThreeFirstCell.self, contentViewWidth: UIScreen.main.bounds.width)
        
    }
    
    
    
    
}











//@objc private func rightBarButtonItemAction(sender: UIBarButtonItem) {
//
//
//}

//let rightBarButtonItem = UIBarButtonItem(title: "日间", style: .done, target: self, action: #selector(rightBarButtonItemAction(sender:)))
//
//self.navigationItem.rightBarButtonItem = rightBarButtonItem

