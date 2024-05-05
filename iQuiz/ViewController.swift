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
        let questions: [Question]
    }

    struct Question {
        var question: String
        var answer: String
        var multipleChoice: [String]
    }

    let quizzes: [Quiz] = [
        Quiz(
            title: "Marvel",
            imageName: "marvel",
            detail: "A quiz about the Marvel Universe.",
            questions: [
                Question(
                    question: "Who plays Iron Man?",
                    answer: "Robert Downey Jr.",
                    multipleChoice: ["Robert Downey Jr.", "Seal", "Akon"]
                ),
                Question(
                    question: "Who plays Antman?",
                    answer: "Paul Rudd",
                    multipleChoice: ["Ja Rule", "Paul Rudd", "Cher"]
                )
            ]
        ),
        Quiz(
            title: "Science",
            imageName: "science",
            detail: "A quiz about science.",
            questions: [
                Question(
                    question: "What animal can fly?",
                    answer: "Birds",
                    multipleChoice: ["Birds", "Whales", "Dogs"]
                ),
                Question(
                    question: "How many moons does earth have?",
                    answer: "1",
                    multipleChoice: ["1", "5", "10"]
                )
            ]
        ),
        Quiz(
            title: "Math",
            imageName: "math",
            detail: "A quiz about math.",
            questions: [
                Question(
                    question: "What's 2 + 2?",
                    answer: "4",
                    multipleChoice: ["4", "1", "-8"]
                ),
                Question(
                    question: "What's 1 + 1?",
                    answer: "2",
                    multipleChoice: ["2", "3", "4"]
                )
            ]
        )
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
    
    //pass selected data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestion", let destinationVC = segue.destination as? QuestionViewController {
            if let indexPath = table.indexPathForSelectedRow {
                // Pass the selected quiz to the destination view controller
                destinationVC.quiz = quizzes[indexPath.row]
            }
        }
    }
    
    @IBAction func showAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
}

