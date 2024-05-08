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
    var quizViewModel = QuizViewModel.shared
    
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
        if quizViewModel.getUserAnswer() == quizViewModel.getCorrectAnswerNum() {
            quizViewModel.addScore()
            correctLabel.isHidden = false

        } else {
            incorrectLabel.isHidden = false

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        correctLabel.isHidden = true
        incorrectLabel.isHidden = true
        answerLabel.text = quizViewModel.getCorrectAnswerText()
        isCorrect()
        quizViewModel.nextQuestion()
        
    }
    

    @IBAction func switchViews(_ sender: Any) {
        secondViewController = instantiate(id: "question") as? QuestionViewController
        
        if let secondVC = secondViewController {
            UIView.transition(with: self.view, duration: 0.4, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
                self.switchViewController(to: secondVC)
            }, completion: nil)
        }
    }
}
