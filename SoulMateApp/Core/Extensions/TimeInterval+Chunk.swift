import Foundation

extension TimeInterval {
    static let chunkDuration: TimeInterval = 360
    static let gracePeriod: TimeInterval = 30

    var chunkFormatted: String {
        let total = max(0, Int(self))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

extension Int {
    var tokenLabel: String {
        self == 1 ? "1 token" : "\(self) tokens"
    }
}
