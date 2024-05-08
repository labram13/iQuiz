import Foundation

class QuizViewModel {
    var quizzes: [Quiz] = []

    init() {
        Task {
            await loadQuizzes()
        }
    }

    func loadQuizzes() async {
        do {
            let data = try await FetchData.shared.fetchData(from: "https://tednewardsandbox.site44.com/questions.json")
            self.quizzes = try JSONDecoder().decode([Quiz].self, from: data)
        } catch {
            print("Failed to fetch or decode quizzes: \(error)")
        }
    }
}
