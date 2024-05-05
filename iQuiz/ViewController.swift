//
//  ViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 4/29/24.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    
 
    struct Quiz {
        let title: String
        let imageName: String
        let detail: String
        
    }
    
    let quizzes: [Quiz] = [
        Quiz(title: "Marvel", imageName: "marvel", detail: "A quiz about the Marvel Universe.") ,
        Quiz(title: "Math", imageName: "math", detail: "A Quiz about mathematics."),
        Quiz(title: "Science", imageName: "science", detail: "A Quiz about science."),
    
    ]
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
 
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuizTableViewCell
        
        cell.title.text = quizzes[indexPath.row].title
        cell.quizIcon.image = UIImage(named: quizzes[indexPath.row].imageName)
//        cell.quizIcon.image = UIImage(named: quizzes[indexPath.row].imageName)
        cell.quizDescription.text = quizzes[indexPath.row].detail
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        
    }
    
 
   

    @IBAction func showAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
}

