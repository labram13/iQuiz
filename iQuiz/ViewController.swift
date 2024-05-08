//
//  ViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 4/29/24.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var quizViewModel = QuizViewModel()
    
    var quizzes: [Quiz] = []

    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizzes = quizViewModel.quizzes
        table.dataSource = self
        table.delegate = self
        
        
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

