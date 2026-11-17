import Foundation

public enum GridZoomDirection: Sendable { case larger, smaller }

public enum GridDensity {
    public static let levels = [8, 6, 4, 2, 1]

    public static func isAtMaximum(columns: Int, width: Double, maxCellWidth: Double, spacing: Double = 4) -> Bool {
        guard columns > 0, width > 0, maxCellWidth > 0 else { return false }
        let cell = (width - spacing * Double(columns - 1)) / Double(columns)
        return columns == 1 || cell >= maxCellWidth
    }

    public static func next(current: Int, direction: GridZoomDirection, width: Double, maxCellWidth: Double) -> Int {
        guard let index = levels.firstIndex(of: current) else { return levels[0] }
        switch direction {
        case .smaller: return levels[max(0, index - 1)]
        case .larger:
            if isAtMaximum(columns: current, width: width, maxCellWidth: maxCellWidth) { return current }
            return levels[min(levels.count - 1, index + 1)]
        }
    }
}
