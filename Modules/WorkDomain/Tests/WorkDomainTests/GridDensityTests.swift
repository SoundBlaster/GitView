import Testing
@testable import WorkDomain

struct GridDensityTests {
    @Test func zoomUsesDiscreteLevelsAndClamps() {
        #expect(GridDensity.next(current: 8, direction: .larger, width: 390, maxCellWidth: 320) == 6)
        #expect(GridDensity.next(current: 6, direction: .smaller, width: 390, maxCellWidth: 320) == 8)
        #expect(GridDensity.next(current: 8, direction: .smaller, width: 390, maxCellWidth: 320) == 8)
    }
    @Test func maximumDependsOnWidthAndMaximumCellSize() {
        #expect(GridDensity.next(current: 2, direction: .larger, width: 390, maxCellWidth: 320) == 1)
        #expect(GridDensity.isAtMaximum(columns: 1, width: 390, maxCellWidth: 320))
        #expect(!GridDensity.isAtMaximum(columns: 2, width: 390, maxCellWidth: 320))
        #expect(GridDensity.isAtMaximum(columns: 2, width: 700, maxCellWidth: 320))
    }
}
