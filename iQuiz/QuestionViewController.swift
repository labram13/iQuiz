//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 5/4/24.
//

import UIKit



class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //data
    var quiz: ViewController.Quiz!
    var currQuestion: Int = 0
    var currScore: Int = 0
    var userAnswer: Int = 0
    
    //controllers
    private var currentChildViewController: UIViewController?
    private var secondViewController: AnswerViewController?
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    private func switchViewController(to newViewController: UIViewController) {
        // Remove the old child view controller if it exists
        if let existingChild = currentChildViewController {
            existingChild.willMove(toParent: nil)
            existingChild.view.removeFromSuperview()
            existingChild.removeFromParent()
        }

        // Add the new child view controller
        addChild(newViewController)
        newViewController.view.frame = view.bounds  // Ensure it fills the entire parent view
        view.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
        
        // Update the current child reference
        currentChildViewController = newViewController
    }


    private func instantiate<T: UIViewController>(id: String) -> T? {
        return storyboard?.instantiateViewController(withIdentifier: id) as? T
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = quiz.title
        questionLabel.text = quiz.questions[currQuestion].text
        scoreLabel.text = "Score: \(currScore)"
        table.dataSource = self
        table.delegate = self
        submitButton.isEnabled = false
        
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.questions[currQuestion].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        cell.textLabel?.text = quiz.questions[currQuestion].answers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userAnswer = indexPath.row + 1
        submitButton.isEnabled = true

    }
    
    
    
    @IBAction func switchViews(_ sender: Any) {
        
        secondViewController = instantiate(id: "answer") as? AnswerViewController
        secondViewController!.quiz = self.quiz
        secondViewController!.currScore = self.currScore
        secondViewController!.currQuestion = self.currQuestion
        secondViewController!.userAnswer = self.userAnswer

        if let secondVC = secondViewController {
            UIView.transition(with: self.view, duration: 0.4, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
                self.switchViewController(to: secondVC)
            }, completion: nil)
        }

    }
    
    
    
    
   

    
    
    
  

}
