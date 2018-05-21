
import AVFoundation
import Foundation

public class StateMachine {
    private(set) var state: PlayerState
    private var config: BitmovinAnalyticsConfig
    private var initialTimestamp: Int
    private(set) var enterTimestamp: Int?
    var potentialSeekStart: Int = 0
    var potentialSeekVideoTimeStart: CMTime?
    var firstReadyTimestamp: Int?
    private(set) var videoTimeStart: CMTime?
    private(set) var videoTimeEnd: CMTime?
    private(set) var impressionId: String
    weak var delegate: StateMachineDelegate?
    weak private var heartbeatTimer: Timer?

    var startupTime: Int {
        guard let firstReadyTimestamp = firstReadyTimestamp else {
            return 0
        }
        return firstReadyTimestamp - initialTimestamp
    }

    init(config: BitmovinAnalyticsConfig) {
        self.config = config
        state = .setup
        initialTimestamp = Date().timeIntervalSince1970Millis
        impressionId = NSUUID().uuidString
    }

    deinit {
        heartbeatTimer?.invalidate()
    }

    public func reset() {
        impressionId = NSUUID().uuidString
        initialTimestamp = Date().timeIntervalSince1970Millis
        firstReadyTimestamp = nil
        disableHeartbeat()
        state = .setup
    }

    public func transitionState(destinationState: PlayerState, time: CMTime?) {
        if state == destinationState {
            return
        } else if state == .buffering && destinationState == .qualitychange {
            return
        } else {
            let timestamp = Date().timeIntervalSince1970Millis
            videoTimeEnd = time
            state.onExit(stateMachine: self, timestamp: timestamp, destinationState: destinationState)
            state = destinationState
            enterTimestamp = timestamp
            videoTimeStart = videoTimeEnd
            state.onEntry(stateMachine: self, timestamp: timestamp, destinationState: destinationState)
        }
    }

    public func confirmSeek() {
        enterTimestamp = potentialSeekStart
        videoTimeStart = potentialSeekVideoTimeStart
        potentialSeekStart = 0
        potentialSeekVideoTimeStart = kCMTimeZero
    }

    func enableHeartbeat() {
        let interval = Double(config.heartbeatInterval) / 1000.0
        heartbeatTimer?.invalidate()
        heartbeatTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(StateMachine.onHeartbeat), userInfo: nil, repeats: true)
    }

    func disableHeartbeat() {
        heartbeatTimer?.invalidate()
    }

    @objc func onHeartbeat() {
        guard let enterTime = enterTimestamp else {
            return
        }
        let timestamp = Date().timeIntervalSince1970Millis
        delegate?.stateMachine(self, didHeartbeatWithDuration: timestamp - enterTime)
        enterTimestamp = timestamp
    }
}
