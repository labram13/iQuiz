//
//  ViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 4/29/24.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    
 
//    struct Quiz {
//        let title: String
//        let imageName: String
//        let detail: String
//        let questions: [Question]
//    }
//
//    struct Question {
//        var question: String
//        var answer: String
//        var answers: [String]
//    }
//
//    let quizzes: [Quiz] = [
//        Quiz(
//            title: "Marvel",
//            imageName: "marvel",
//            detail: "A quiz about the Marvel Universe.",
//            questions: [
//                Question(
//                    question: "Who plays Iron Man?",
//                    answer: "Robert Downey Jr.",
//                    answers: ["Robert Downey Jr.", "Seal", "Akon"]
//                ),
//                Question(
//                    question: "Who plays Antman?",
//                    answer: "Paul Rudd",
//                    answers: ["Ja Rule", "Paul Rudd", "Cher"]
//                )
//            ]
//        ),
//        Quiz(
//            title: "Science",
//            imageName: "science",
//            detail: "A quiz about science.",
//            questions: [
//                Question(
//                    question: "What animal can fly?",
//                    answer: "Birds",
//                    answers: ["Birds", "Whales", "Dogs"]
//                ),
//                Question(
//                    question: "How many moons does earth have?",
//                    answer: "1",
//                    answers: ["1", "5", "10"]
//                )
//            ]
//        ),
//        Quiz(
//            title: "Math",
//            imageName: "math",
//            detail: "A quiz about math.",
//            questions: [
//                Question(
//                    question: "What's 2 + 2?",
//                    answer: "4",
//                    answers: ["4", "1", "-8"]
//                ),
//                Question(
//                    question: "What's 1 + 1?",
//                    answer: "2",
//                    answers: ["2", "3", "4"]
//                )
//            ]
//        )
//    ]
    
    struct Quiz: Codable {
        let title: String
        let desc: String
        let questions: [Question]
    }

    struct Question: Codable {
        let text: String
        let answer: String
        let answers: [String]
    }
    
    var quizzes: [Quiz] = []

    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        fetchData()
    }
    
    func fetchData() {
            let urlString = "http://tednewardsandbox.site44.com/questions.json" // Consider changing to HTTPS if possible
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let error = error {
                    print("Failed to fetch data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.quizzes = try decoder.decode([Quiz].self, from: data)
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
//                    print("Parsed quiz topics: \(self.quizzes)")
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }
            
            task.resume()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuizTableViewCell
        
        cell.title.text = quizzes[indexPath.row].title
        cell.quizIcon.image = UIImage(named: quizzes[indexPath.row].title)
//        cell.quizIcon.image = UIImage(named: quizzes[indexPath.row].imageName)
        cell.quizDescription.text = quizzes[indexPath.row].desc
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
                // Return a smaller height if the device is in landscape mode
                return 110
            } else {
                // Return a larger height if the device is in portrait mode
                return 150.0
            }
        
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

