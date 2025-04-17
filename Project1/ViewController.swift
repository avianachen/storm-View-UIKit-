//
//  ViewController.swift
//  Project1
//
//  Created by cxq on 2025/3/31.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        //在整个应用中使用大标题
        navigationController?.navigationBar.prefersLargeTitles = true
        let fm = FileManager.default
        //将路径设置为我们应用程序包的资源路径
        let path = Bundle.main.resourcePath!
        //用try！是没问题的，因为如果此代码失败，则意味着我们的应用无法读取自己的数据
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.hasPrefix("nssl"){
                //item包含要从我们的包中加载的图片都名称
                pictures.append(item)
            }
        }
        pictures.sort()
        //print(pictures)
    }
    
    override func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int) -> Int{
        return pictures.count
    }
    
    override func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }

    override func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath){
        //1.尝试加载“Detail”视图控制器并将其类型转换为DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            //2。成功！设置它的selectedImage属性
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            //现在把“Detail”视图推入到导航视图控制器上
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

