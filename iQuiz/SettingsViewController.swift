//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Michaelangelo Labrador on 5/8/24.
//

import UIKit

class SettingsViewController: UIViewController {
    let quiz = QuizViewModel.shared
    let userDefaults = UserDefaults.standard
    var url: String? = nil
    var onDismiss: (() -> Void)?
    @IBOutlet weak var settings: UIButton!
   
    @IBOutlet weak var urlLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if quiz.usingDefault {
            urlLabel.text = "Using Default Data of Test Data for Science Quiz"
        } else {
            urlLabel.text = userDefaults.string(forKey: "url")
        }
        // Get the shared URL cache
        let urlCache = URLCache.shared

        // Remove all cached responses
        urlCache.removeAllCachedResponses()
        urlCache.memoryCapacity = 0
        urlCache.diskCapacity = 0
       

    // Do any additional setup after loading the view.
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "Success!", message: "JSON file downloaded to Documents directory.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func failedAlert() {
        let alert = UIAlertController(title: "Failed", message: "JSON file failed to download", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func noURLAlert() {
        let alert = UIAlertController(title: "Invalid URL", message: "Enter valid URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func noConnectionAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Connect to Internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveToDirectory(_ jsonData: Data) throws {
        let fileManager = FileManager.default
     
            let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let newFile = docURL.appendingPathComponent("test11.json")
            try jsonData.write(to: newFile, options: .atomic)
       
    }
    
    func responseAlert() {
        let alert = UIAlertController(title: "Incorrect URL", message: "Re-enter correct URL.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateURL(_ url: String) {
        DispatchQueue.global().async {
            NSLog("Inside global().async")
            
            let testURL = URL(string: url)
            let task = URLSession.shared.dataTask(with: testURL!) { [self] data, response, error in
                if let error = error as NSError? {
                    NSLog("Error for URL Session! \(error)")
                        if error.domain == NSURLErrorDomain {
                            switch error.code {
                            case NSURLErrorNotConnectedToInternet:
                                DispatchQueue.main.async {
                                    self.noConnectionAlert()
                                }
                            case NSURLErrorUnsupportedURL, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                                DispatchQueue.main.async {
                                    self.noURLAlert()
                                }
                            default:
                                break
                            }
                        }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    NSLog("Error for htttpResponse! \(String(describing: response))")
                    DispatchQueue.main.async {
                        NSLog("Inside main.async")
                        self.responseAlert()
                       
                    }
                    return
                }

                
                do {
                    try saveToDirectory(data!)
                    NSLog("saveToDirectory Success")
                    let fileManager = FileManager.default
                    let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
                    let fileURLs = try fileManager.contentsOfDirectory(at: docURL!, includingPropertiesForKeys: nil, options: [])
                    NSLog("\(fileURLs)")
                    DispatchQueue.main.async {
                        NSLog("Inside main.async")
                        self.successAlert()
                        self.quiz.setDefault()
                        self.urlLabel.text = self.userDefaults.string(forKey: "url")
                       
                    }
                }
                catch {
                    NSLog("Error for the do/catch!")
                    DispatchQueue.main.async {
                        NSLog("Inside catch sync")
                        self.failedAlert()
                       
                    }
                }
                
                NSLog("After main.async")
            }
            task.resume()
            NSLog("Task resumed")
        }
    }
        
        

    
    
    
    @IBAction func checkUrl(_ sender: Any) {
        let url = userDefaults.string(forKey: "url")
        if url!.isEmpty {
           noURLAlert()
        } else {
            let url = userDefaults.string(forKey: "url")
            validateURL(url!)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
        self.quiz.setDownloadedData()
        print(quiz.quizzes)
    }
    
    @IBAction func switchToSettings(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(settingsUrl) else {
                    return
                }
                
                UIApplication.shared.open(settingsUrl)
            }
   
}



