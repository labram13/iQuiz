//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 5/7/24.
//

import UIKit

class FinishViewController: UIViewController {
    private var currentChildViewController: UIViewController?
    private var secondViewController: QuestionViewController?
    var quiz: ViewController.Quiz?
    var currScore: Int = 0
    var currQuestion: Int = 0
    var userAnswer: Int = 0

    @IBOutlet weak var performanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    func checkPerformance() {
        let percent = Double(currScore) / Double(quiz!.questions.count)
        if percent == 1.0 {
            performanceLabel.text = "Perfect!"
        } else if percent < 1.0 && percent > 0.5 {
            performanceLabel.text = "Almost!"
        } else if percent < 0.5 && percent > 0.0 {
            performanceLabel.text = "Poor"
        } else {
            performanceLabel.text = "Bruh"
        }
    }
    
    func isCorrect() {
        let answerNum = Int(quiz!.questions[currQuestion].answer)! - 1
        answerLabel.text = quiz!.questions[currQuestion].answers[answerNum]
        if userAnswer == Int(quiz!.questions[currQuestion].answer) {
            currScore += 1
        }
    }
    
    func setScore() {
        scoreLabel.text = "You scored \(currScore)/\(quiz!.questions.count)"
    }
    
    func resetQuiz() {
        currScore = 0
        currQuestion = 0
    }
    
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
        isCorrect()
        checkPerformance()
        setScore()
        resetQuiz()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchViews(_ sender: Any) {
        secondViewController = instantiate(id: "question") as? QuestionViewController
        secondViewController!.quiz = self.quiz
        secondViewController!.currScore = self.currScore
        secondViewController!.currQuestion = self.currQuestion
        
        if let secondVC = secondViewController {
            UIView.transition(with: self.view, duration: 0.4, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
                self.switchViewController(to: secondVC)
            }, completion: nil)
        }
    }

}
