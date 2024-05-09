
import Foundation

class QuizViewModel {
    
    static let shared = QuizViewModel()
    
    var quizzes: [Quiz] = []
    var currQuestion: Int = 0
    var currScore: Int = 0
    var userAnswer: Int = 0
    var currQuiz: Quiz!
    var fileManager: FileManager!
    var usingDefault = true

    init() {
        fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let file = docs!.appendingPathComponent("downloadedData.json")
        guard fileManager.fileExists(atPath: file.path) else {
            self.quizzes = defaultQuiz
            return
        }
        if fileManager.fileExists(atPath: file.path) {
            do {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                self.quizzes = try decoder.decode([Quiz].self, from: data)
                usingDefault = false
                
                
            } catch {
                NSLog("file doesn't exist")
                
            }
            
        }
    }
    func setDownloadedData() {
        fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let file = docs!.appendingPathComponent("downloadedData.json")
        guard fileManager.fileExists(atPath: file.path) else {
            self.quizzes = defaultQuiz
               return
           }
        if fileManager.fileExists(atPath: file.path) {
            do {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                self.quizzes = try decoder.decode([Quiz].self, from: data)
                usingDefault = false
                
                
            } catch {
                NSLog("file doesn't exist")
                
            }
        }
    }
   
    
    func setDefault() {
        self.usingDefault = false
    }
    
    func resetQuiz() {
        currQuestion = 0
        currScore = 0
        userAnswer = 0
    }
    
    func getCurrQuestion() -> Int {
        return currQuestion + 1
    }
    func getScore() -> Int {
        return currScore
    }
    
    func nextQuestion() {
        self.currQuestion += 1
    }
    
    func addScore() {
        self.currScore += 1
    }
    func setAnswer(_ answer: Int) {
        self.userAnswer = answer
        
    }
    func setQuiz(_ quiz: Int) {
        
        self.currQuiz = quizzes[quiz]
    }
    
    func getQuestion() -> String {
        return currQuiz!.questions[currQuestion].text
    }
    
    func getTitle() -> String {
        return currQuiz!.title
    }
    
    func getNumAnswers() -> Int{
        return currQuiz!.questions[currQuestion].answers.count
    }
    
    func getNumQuestions() -> Int {
        return currQuiz!.questions.count
    }
    
    func getAnswers() -> [String] {
        return currQuiz!.questions[currQuestion].answers
    }
    func getCorrectAnswerText() -> String {
        let answer = Int(currQuiz!.questions[currQuestion].answer)! - 1
        return currQuiz!.questions[currQuestion].answers[answer]
    }
    func getCorrectAnswerNum() -> Int {
        return Int(currQuiz!.questions[currQuestion].answer)!
    }
    func getUserAnswer() -> Int {
        return userAnswer
    }
    func printQuiz() {
        print(currQuiz!)
    }
}


let defaultQuiz = [
    Quiz(
        title: "Science!",
        desc: "Because SCIENCE!",
        questions: [
            Question(
                text: "What is fire?",
                answer: "1",
                answers: [
                    "One of the four classical elements",
                    "A magical reaction given to us by God",
                    "A band that hasn't yet been discovered",
                    "Fire! Fire! Fire! heh-heh"
                ]
            )
        ]
    )
]
