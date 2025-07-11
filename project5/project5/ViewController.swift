//
//  ViewController.swift
//  project5
//
//  Created by cxq on 2025/4/18.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var useWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            
            
            if let startWords = try? String(contentsOf:startWordsURL,encoding: .utf8){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty{
            allWords = ["silkworm"]
            
        }
        
        startGame()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "start", style: .plain, target: self, action: #selector(startGame))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = useWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){ [weak self,weak ac]action in
            guard let answer = ac?.textFields?[0].text else
            {return}
            self?.submit(answer)
            
        }
        
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func submit(_ answer:String){
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    useWords.insert(lowerAnswer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                }else{
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up,you know!"
                }
            }else{
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        }else{
            guard let title = title?.lowercased() else{
                return
            }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell taht word from \(title)"
        }
        showErrorMessage(errorTitle:errorTitle,errorMessage:errorMessage)
    }
    
    func isOriginal(word:String) ->Bool{
        return !useWords.contains(word)
    }
    
    func isPossible(word:String) -> Bool{
        guard var tempWord = title?.lowercased() else {return false}
        if word == tempWord{
            return false
        }else{
            for letter in word{
                if let position = tempWord.firstIndex(of: letter){
                    tempWord.remove(at: position)
                }else{
                    return false
                }
            }
            return true
        }
    }
    
    func isReal(word:String)->Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound && word.utf16.count > 2
    }
    
    func showErrorMessage(errorTitle:String,errorMessage:String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac,animated: true)
    }
    
    @objc func startGame(){
        title = allWords.randomElement()
        useWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

}

