
import Foundation

class QuizViewModel {
    
    static let shared = QuizViewModel()
    
    var quizzes: [Quiz] = []
    var currQuestion: Int = 0
    var currScore: Int = 0
    var userAnswer: Int = 0
    var currQuiz: Quiz!

    init() {
        loadQuizzes()
    }
    
    func resetQuiz() {
        currQuestion = 0
        currScore = 0
        userAnswer = 0
    }

    func loadQuizzes(completion: (() -> Void)? = nil) {
        Task {
            do {
                let data = try await FetchData.shared.fetchData(from: "https://tednewardsandbox.site44.com/questions.json")
                self.quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                print("Failed to fetch or decode quizzes: \(error)")
            }
        }
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
