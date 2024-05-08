//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 5/4/24.
//

import UIKit



class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //data
    var quizViewModel = QuizViewModel.shared
    
    //controllers
    private var currentChildViewController: UIViewController?
    private var secondViewController: AnswerViewController?
    private var thirdViewController: FinishViewController?
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
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
        
        self.title = quizViewModel.getTitle()
        questionLabel.text = quizViewModel.getQuestion()
        table.dataSource = self
        table.delegate = self
        submitButton.isEnabled = false
        if QuizViewModel.shared.quizzes.isEmpty {
               QuizViewModel.shared.loadQuizzes {
                   self.setupView()
               }
           } else {
               setupView()
           }
        }
    private func setupView() {
        guard let currQuiz = QuizViewModel.shared.currQuiz else {
            print("Quiz data is not available.")
            return
        }

        table.dataSource = self
        table.delegate = self
        submitButton.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizViewModel.getNumAnswers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        cell.textLabel?.text = quizViewModel.getAnswers()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        quizViewModel.setAnswer(indexPath.row + 1)
        submitButton.isEnabled = true

    }
    
    
    
    @IBAction func switchViews(_ sender: Any) {
        if (quizViewModel.getCurrQuestion() < quizViewModel.getNumQuestions()) {
            secondViewController = instantiate(id: "answer") as? AnswerViewController
//            secondViewController!.quiz = self.quiz
//            secondViewController!.currScore = self.currScore
//            secondViewController!.currQuestion = self.currQuestion
//            secondViewController!.userAnswer = self.userAnswer
            
            if let secondVC = secondViewController {
                UIView.transition(with: self.view, duration: 0.4, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
                    self.switchViewController(to: secondVC)
                }, completion: nil)
            }
        } else {
            thirdViewController = instantiate(id: "finish") as? FinishViewController
//            thirdViewController!.quiz = self.quiz
//            thirdViewController!.currScore = self.currScore
//            thirdViewController!.currQuestion = self.currQuestion
//            thirdViewController!.userAnswer = self.userAnswer
            if let secondVC = thirdViewController {
                UIView.transition(with: self.view, duration: 0.4, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
                    self.switchViewController(to: secondVC)
                }, completion: nil)
            }
        }

    }
  

}
