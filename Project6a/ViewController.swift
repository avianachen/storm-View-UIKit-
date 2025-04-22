//
//  ViewController.swift
//  Project2
//
//  Created by cxq on 2025/4/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    //保存我们游戏中使用的所有国家，同时我们将创建另一个属性来保存玩家的当前分数
    var countries = [String]()
    var correctAnswer = 0
    var score = 0 {
        didSet{
            updateScoreLabel()
        }
    }
    var questionNum = 0
    var message: String?
    private let scoreLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scoreLabel.text = "分数：\(score)"
        scoreLabel.textColor = .blue
        scoreLabel.font = UIFont.systemFont(ofSize: 12)
        scoreLabel.sizeToFit()//根据内容调整标签大小
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scoreLabel)
        //我们可以通过将按钮的图层设置为 1 来解决这个问题，这样按钮周围就会画一条单点黑线.我们的边框在非视网膜设备上是 1 像素，在视网膜设备上是 2 像素，在视网膜高清设备上是 3 像素。由于自动将点乘以像素，这个边框在所有设备上的视觉厚度看起来都差不多。
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        //改变边框颜色浅灰色
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion()
    }
    
    func askQuestion(action:UIAlertAction! = nil){
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        //生成一个介于 0 到 2 之间的随机数（含 0 和 2）
        correctAnswer = Int.random(in: 0...2)
        title = "国家：\(countries[correctAnswer].uppercased())"
    }

    //这个方法需要做三件事：
    //检查答案是否正确。
    //调高或调低玩家的分数。
    //显示一条消息告诉他们他们的新分数是多少。
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        questionNum += 1
        print(questionNum)
        if sender.tag == correctAnswer{
            title = "Correct"
            score += 1
            message = "Right!Add one point.Your score is \(score)."
        }else{
            title = "Wrong"
            score -= 1
            message = "Wrong! That’s the flag of France,minus one point.Your score is \(score)."
        }
        if questionNum < 10{
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac,animated: true)
        }
        if questionNum == 10{
            let ac = UIAlertController(title: "Game over", message: "Game over,your final score is \(score).", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Restart Game", style: .default){_ in
                self.questionNum = 0
                self.score = 0
                self.askQuestion()
            })
            present(ac,animated: true)
        }
    }
    
    @objc func showScore(){
        let alertController = UIAlertController(title: "你的分数", message: "你的分数是\(score)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default))
        present(alertController,animated: true)
    }
    
    func updateScoreLabel(){
        scoreLabel.text = "分数：\(score)"
        scoreLabel.sizeToFit()//根据内容调整标签大小
    }
}

