import Foundation

<<<<<<< Updated upstream
public extension Date {
    public init(day: Int, month: Int, year: Int) {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        self = calendar.date(from: dateComponents) ?? Date()
    }
}
=======
>>>>>>> Stashed changes
