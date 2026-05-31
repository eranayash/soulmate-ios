import XCTest
@testable import SoulMateApp

@MainActor
final class TokenEconomyServiceTests: XCTestCase {
    func testChunkDurationConstant() {
        XCTAssertEqual(TimeInterval.chunkDuration, 360)
        XCTAssertEqual(TimeInterval.gracePeriod, 30)
    }

    func testStartRequiresTokens() {
        let service = TokenEconomyService.shared
        var events: [TokenEconomyEvent] = []
        service.onEvent = { events.append($0) }

        service.start(sessionID: "test", initialChunksAvailable: 0)

        XCTAssertFalse(service.isRunning)
        XCTAssertEqual(events.last, .insufficientTokens)

        service.stop()
        service.onEvent = nil
    }

    func testCountdownDecrements() {
        let service = TokenEconomyService.shared
        service.start(sessionID: "test", initialChunksAvailable: 2)

        XCTAssertEqual(service.remainingSeconds, 360)
        XCTAssertTrue(service.isRunning)

        service.stop()
    }

    func testTimeFormatting() {
        XCTAssertEqual(TimeInterval(366).chunkFormatted, "6:06")
        XCTAssertEqual(TimeInterval(59).chunkFormatted, "0:59")
        XCTAssertEqual(TimeInterval(0).chunkFormatted, "0:00")
    }
}

@MainActor
final class SessionManagerTests: XCTestCase {
    func testSeekerWelcomeBalance() {
        let manager = SessionManager.shared
        manager.signOut()
        manager.signIn(role: .seeker)

        XCTAssertEqual(manager.currentUser?.tokenBalance, 3)
        XCTAssertTrue(manager.canStartChat())

        manager.signOut()
    }

    func testChargeChunk() {
        let manager = SessionManager.shared
        manager.signOut()
        manager.signIn(role: .seeker)

        let success = manager.chargeChunk(for: "session-1")
        XCTAssertTrue(success)
        XCTAssertEqual(manager.currentUser?.tokenBalance, 2)

        manager.signOut()
    }
}
