//
//  ViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 4/29/24.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var quizViewModel = QuizViewModel.shared
    

    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizViewModel.resetQuiz()
        table.dataSource = self
        table.delegate = self
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quizViewModel.quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuizTableViewCell
        
        cell.title.text = quizViewModel.quizzes[indexPath.row].title
        cell.quizIcon.image = UIImage(named: quizViewModel.quizzes[indexPath.row].title)
//        cell.quizIcon.image = UIImage(named: quizzes[indexPath.row].imageName)
        cell.quizDescription.text = quizViewModel.quizzes[indexPath.row].desc
        
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
        if segue.identifier == "showQuestion" {
            if let indexPath = table.indexPathForSelectedRow {
                quizViewModel.resetQuiz()
                quizViewModel.setQuiz(indexPath.row)
                
            }
        }
    }

    
//    @IBAction func showAlert(_ sender: Any) {
//        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//        NSLog("The \"OK\" alert occured.")
//        }))
//        self.present(alert, animated: true, completion: nil)
//
//    }
    
}

