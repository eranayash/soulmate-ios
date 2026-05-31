import Foundation
import Combine

enum TokenEconomyEvent: Equatable {
    case chunkStarted(index: Int)
    case chunkCompleted(index: Int)
    case insufficientTokens
    case sessionEnded(reason: String)
}

@MainActor
final class TokenEconomyService: ObservableObject {
    static let shared = TokenEconomyService()

    @Published private(set) var remainingSeconds: TimeInterval = .chunkDuration
    @Published private(set) var currentChunkIndex: Int = 0
    @Published private(set) var isRunning = false
    @Published private(set) var isInGracePeriod = false
    @Published private(set) var graceRemaining: TimeInterval = .gracePeriod

    var onEvent: ((TokenEconomyEvent) -> Void)?

    private var timer: Timer?
    private var tickDate: Date?

    private init() {}

    func start(sessionID: String, initialChunksAvailable: Int) {
        stop()
        currentChunkIndex = 0
        remainingSeconds = .chunkDuration
        isInGracePeriod = false
        graceRemaining = .gracePeriod
        isRunning = initialChunksAvailable > 0

        guard initialChunksAvailable > 0 else {
            onEvent?(.insufficientTokens)
            return
        }

        onEvent?(.chunkStarted(index: 0))
        startTimer()
    }

    func pause() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        guard !isRunning, !isInGracePeriod else { return }
        isRunning = true
        startTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        tickDate = nil
        isRunning = false
        isInGracePeriod = false
    }

    func handleChunkPaid(success: Bool) {
        if success {
            currentChunkIndex += 1
            remainingSeconds = .chunkDuration
            isInGracePeriod = false
            graceRemaining = .gracePeriod
            onEvent?(.chunkCompleted(index: currentChunkIndex))
            onEvent?(.chunkStarted(index: currentChunkIndex))
            if !isRunning {
                isRunning = true
                startTimer()
            }
        } else {
            beginGracePeriod()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        tickDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func tick() {
        if isInGracePeriod {
            graceRemaining = max(0, graceRemaining - 1)
            if graceRemaining <= 0 {
                stop()
                onEvent?(.sessionEnded(reason: "Out of tokens"))
            }
            return
        }

        remainingSeconds = max(0, remainingSeconds - 1)
        if remainingSeconds <= 0 {
            timer?.invalidate()
            timer = nil
            isRunning = false
            onEvent?(.chunkCompleted(index: currentChunkIndex))
        }
    }

    private func beginGracePeriod() {
        isInGracePeriod = true
        isRunning = true
        timer?.invalidate()
        startTimer()
        onEvent?(.insufficientTokens)
    }
}
