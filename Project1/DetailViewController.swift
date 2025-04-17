//
//  DetailViewController.swift
//  Project1
//
//  Created by cxq on 2025/4/1.
//

import UIKit

class DetailViewController: UIViewController {
//这个属性用来告诉XCode这行代码和Interfacce Builder之间存在联系
    @IBOutlet var imageView: UIImageView!
    //类型为可选字符串：因为当视图控制器首次创建时它不存在，我们将立即设置它，但它仍然从空开始
    var selectedImage:String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "第\(selectedPictureNumber)张图片，共\(totalPictures)张图片"
        //希望第一个页面的标题大一点，但详细屏幕看起来正常
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad = selectedImage{
            imageView.image = UIImage(named: imageToLoad)
        }
        // Do any additional setup after loading the view.
    }
    //参数为是否是动画
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
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
