//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 5/4/24.
//

import UIKit

class AnswerViewController: UIViewController {
    private var currentChildViewController: UIViewController?
    private var secondViewController: QuestionViewController?
    var quiz: Quiz!
    var currScore: Int = 0
    var currQuestion: Int = 0
    var userAnswer: Int = 0
    
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
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
    
    func isCorrect() {
        let answerNum = Int(quiz!.questions[currQuestion].answer)! - 1
        answerLabel.text = quiz!.questions[currQuestion].answers[answerNum]
        if userAnswer == Int(quiz!.questions[currQuestion].answer) {
            correctLabel.isHidden = false
            currScore += 1
        } else {
            incorrectLabel.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        correctLabel.isHidden = true
        incorrectLabel.isHidden = true
        isCorrect()
        currQuestion += 1
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
