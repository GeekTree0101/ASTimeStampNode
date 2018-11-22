import AsyncDisplayKit

public class ASTimeStampNode: ASTextNode {
    
    public typealias ASTimeStampAttribute = [NSAttributedStringKey: Any]
    
    public enum TimeDirection {
        
        case increase
        case decrease
    }
    
    public enum TimeFormat {
        
        case hourMinSec
        case minSec
        case custom(String)
        
        var formatAttribute: String {
            
            switch self {
            case .hourMinSec: return "HH:mm:ss"
            case .minSec: return "mm:ss"
            case .custom(let format):
                return format
            }
        }
    }
    
    public enum TimeScale {
        
        case sec(Double)
        case min(Double)
        case hour(Double)
        
        var scale: TimeInterval {
            
            switch self {
            case .sec(let value):
                return value
            case .min(let value):
                return value * 60
            case .hour(let value):
                return value * 60 * 60
            }
        }
    }
    
    private var currentTimeInterval: TimeInterval
    private var format: TimeFormat
    private var direction: TimeDirection
    private var timeStampAttribute: ASTimeStampAttribute = [:]
    private var timer: Timer?
    private var unitTimeIntervalDiff: TimeScale = .sec(1)
    private var isBeginZero: Bool = false
    
    /**
     Initialized by start zero-time
     
     - important: it will begin at zero
     
     - Parameters:
     - format: TimeFormat sec/min/hour
     - flowDirection: increase or decrease
     - attributes: TimeStamp Attribute for AttributedString
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    convenience public init (_ format: TimeFormat,
                             flowDirection: TimeDirection,
                             attributes: ASTimeStampAttribute? = nil) {
        
        self.init(startAt: 0.0,
                  format: format,
                  flowDirection: flowDirection,
                  attributes: attributes)
    }
    
    /**
     Initialized by start date
     
     - important: it will begin at target date
     
     - Parameters:
     - startAt: begin date
     - format: TimeFormat sec/min/hour
     - flowDirection: increase or decrease
     - attributes: TimeStamp Attribute for AttributedString
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    convenience public init(startAt: Date,
                            format: TimeFormat,
                            flowDirection: TimeDirection,
                            attributes: ASTimeStampAttribute? = nil) {
        
        self.init(startAt: startAt.timeIntervalSince1970,
                  format: format,
                  flowDirection: flowDirection,
                  attributes: attributes)
    }
    
    /**
     Initialized by start timeInterval
     
     - important: It will begin at target timeInterval.
     if timeInterval is zero than it will start from z
     
     - Parameters:
     - startAt: begin TimeInterval
     - format: TimeFormat sec/min/hour
     - flowDirection: increase or decrease
     - attributes: TimeStamp Attribute for AttributedString
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    public init(startAt: TimeInterval,
                format: TimeFormat,
                flowDirection: TimeDirection,
                attributes: ASTimeStampAttribute? = nil) {
        
        self.currentTimeInterval = startAt
        self.isBeginZero = startAt == 0.0
        self.format = format
        self.direction = flowDirection
        super.init()
    }
    
    /**
     Update ASTimeStamp Attribute Style
     
     - Parameters:
     - attributes: TimeStamp Attribute for AttributedString
     - aniamted: transition or not after update attribute
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    public func updateAttributes(_ attributes: ASTimeStampAttribute,
                                 animated: Bool) {
        
        self.timeStampAttribute = attributes
        if let text = self.attributedText?.string, !text.isEmpty {
            self.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        
        if animated {
            self.transitionLayout(withAnimation: true,
                                  shouldMeasureAsync: true,
                                  measurementCompletion: nil)
        } else if self.isNodeLoaded {
            self.setNeedsLayout()
        } else {
            self.layoutIfNeeded()
            self.invalidateCalculatedLayout()
        }
    }
    
    /**
     Update ASTimeStamp unit time interval diff value
     
     - Parameters:
     - scale: TimeScale sec/min/hour
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    public func updateUnitTimeIntervalDiff(_ scale: TimeScale) {
        
        self.unitTimeIntervalDiff = scale
    }
    
    /**
     ASTimeStamp Timer Begin
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    public func start() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(listenTimerIntervalOperation),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    /**
     ASTimeStamp Timer Pause
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    public func stop() {
        
        guard let timer = self.timer, timer.isValid else { return }
        timer.invalidate()
    }
    
    
    /**
     ASTimeStamp Timer Toggle
     
     - returns: Void (Noting)
     
     - Author: Geektree0101
     */
    public func toggle() {
        
        if let timer = self.timer, timer.isValid {
            self.stop()
        } else {
            self.start()
        }
    }
    
    private func timeIntervalToString() -> String? {
        
        var timeInterval = self.currentTimeInterval
        if self.isBeginZero {
            timeInterval -= TimeScale.hour(9).scale
        }
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.format.formatAttribute
        return dateFormatter.string(from: date)
    }
    
    @objc private func listenTimerIntervalOperation() {
        
        switch direction {
        case .increase:
            self.currentTimeInterval += self.unitTimeIntervalDiff.scale
        case .decrease:
            self.currentTimeInterval -= self.unitTimeIntervalDiff.scale
        }
        
        guard let timestamp = timeIntervalToString() else { return }
        self.attributedText = NSAttributedString(string: timestamp,
                                                 attributes: self.timeStampAttribute)
    }
}
