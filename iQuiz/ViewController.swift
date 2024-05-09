//
//  ViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 4/29/24.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var quizViewModel: QuizViewModel!
    var refreshTimer: Timer?
    var userDefaults = UserDefaults.standard

    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        clearDocumentsFolder()
        quizViewModel = QuizViewModel.shared
        quizViewModel.resetQuiz()
        table.dataSource = self
        table.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged )
        table.refreshControl = refreshControl
    }
    
    func clearDocumentsFolder() {
            let fileManager = FileManager.default
            do {
                let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let docsPath = documentsURL.path
                let fileNames = try fileManager.contentsOfDirectory(atPath: docsPath)
                for fileName in fileNames {
                    let filePath = (docsPath as NSString).appendingPathComponent(fileName)
                    try fileManager.removeItem(atPath: filePath)
                    print("Deleted file:", filePath)
                }
            } catch {
                print("Could not clear documents folder: \(error)")
            }
        }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        
        let seconds = Double(userDefaults.string(forKey: "refresh")!)
        print(seconds!)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds!) {
            self.table.reloadData()
                refreshControl.endRefreshing()
            }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quizViewModel.quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuizTableViewCell
        
        cell.title.text = quizViewModel.quizzes[indexPath.row].title
        cell.quizIcon.image = UIImage(named: quizViewModel.quizzes[indexPath.row].title)
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
//        if segue.identifier == "settingSegue", // Replace with your actual segue identifier
//              let settingsVC = segue.destination as? SettingsViewController {
//               settingsVC.onDismiss = { [weak self] in
//                   self?.table.reloadData()
//               }
//            print("reloading")
//           }
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

