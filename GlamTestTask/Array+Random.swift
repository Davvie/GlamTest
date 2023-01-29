import Foundation

extension Array {
    func randomElement() -> Element? {
        guard !isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<count)
        return self[randomIndex]
    }
}
