import Foundation
import WorkDomain

enum DemoWork {
    struct Item: Identifiable {
        let id: Int
        let completed: Bool
    }

    static func items(now: Date = .now, calendar: Calendar = .current) -> [Item] {
        let policy = TodayEligibility(now: now, calendar: calendar)
        return (1...100).compactMap { id in
            let completed = id <= 95
            let progress: WorkProgress = completed ? .completed(at: now) : .unfinished
            guard policy.evaluate(progress) == .eligible else { return nil }
            return Item(id: id, completed: completed)
        }
    }
}
