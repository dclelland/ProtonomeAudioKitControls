//
//  ParameterFormatter.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

protocol ParameterFormatter {
    
    func string(forValue value: Float) -> String
    
}

protocol ParameterFormatterConstructor: ParameterFormatter {
    
    func formatter(forValue value: Float) -> NSNumberFormatter
    
}

extension ParameterFormatterConstructor {
    
    func string(forValue value: Float) -> String {
        return formatter(forValue: value).stringFromNumber(NSNumber(float: value))!
    }
    
}

struct NumberParameterFormatter: ParameterFormatterConstructor {
    
    func formatter(forValue value: Float) -> NSNumberFormatter {
        switch fabs(value) {
        case 0.0..<0.01:
            return NSNumberFormatter(digits: 1)
        case 0.01..<1.0:
            return NSNumberFormatter(digits: 2)
        default:
            return NSNumberFormatter(digits: 1)
        }
    }
    
}

struct IntegerParameterFormatter: ParameterFormatterConstructor {
    
    func formatter(forValue value: Float) -> NSNumberFormatter {
        return NSNumberFormatter(digits: 0)
    }
    
}

struct PercentageParameterFormatter: ParameterFormatterConstructor {
    
    func formatter(forValue value: Float) -> NSNumberFormatter {
        return NSNumberFormatter(digits: 0, multiplier: 100.0, suffix: "%")
    }
    
}

struct DurationParameterFormatter: ParameterFormatterConstructor {
    
    func formatter(forValue value: Float) -> NSNumberFormatter {
        switch fabs(value) {
        case 0.0:
            return NSNumberFormatter(digits: 1, suffix: "s")
        case 0.0..<0.00001:
            return NSNumberFormatter(digits: 1, multiplier: 1000000.0, suffix: "µs")
        case 0.00001..<0.0001:
            return NSNumberFormatter(digits: 2, multiplier: 1000000.0, suffix: "µs", rounding: .SignificantDigits)
        case 0.0001..<0.1:
            return NSNumberFormatter(digits: 2, multiplier: 1000.0, suffix: "ms", rounding: .SignificantDigits)
        case 0.1..<10.0:
            return NSNumberFormatter(digits: 2, suffix: "s", rounding: .SignificantDigits)
        default:
            return NSNumberFormatter(digits: 0, suffix: "s")
        }
    }
    
}

struct AmplitudeParameterFormatter: ParameterFormatterConstructor {
    
    func formatter(forValue value: Float) -> NSNumberFormatter {
        switch fabs(value) {
        case 0.0..<10.0:
            return NSNumberFormatter(digits: 1, suffix: "dB")
        default:
            return NSNumberFormatter(digits: 0, suffix: "dB")
        }
    }
    
}

struct FrequencyParameterFormatter: ParameterFormatterConstructor {
    
    func formatter(forValue value: Float) -> NSNumberFormatter {
        switch (fabs(value)) {
        case 0.0..<1.0:
            return NSNumberFormatter(digits: 1, suffix: "Hz")
        case 1.0..<100.0:
            return NSNumberFormatter(digits: 2, suffix: "Hz", rounding: .SignificantDigits)
        case 100.0..<1000.0:
            return NSNumberFormatter(digits: 3, suffix: "Hz", rounding: .SignificantDigits)
        default:
            return NSNumberFormatter(digits: 2, multiplier: 0.001, suffix: "kHz", rounding: .SignificantDigits)
        }
    }
    
}

struct IntervalParameterFormatter: ParameterFormatterConstructor {
    
    func formatter(forValue value: Float) -> NSNumberFormatter {
        return NSNumberFormatter(digits: 1, suffix: "c")
    }
    
}

struct SteppedParameterFormatter: ParameterFormatter {
    
    var steps: [(String, Float)]
    
    func string(forValue value: Float) -> String {
        return "TEST"
    }

}

// MARK: - Private extensions

private extension NSNumberFormatter {
    
    enum Rounding {
        case FractionDigits
        case SignificantDigits
    }
    
    convenience init(digits: Int, multiplier: Float = 1, suffix: String? = nil, rounding: Rounding = .FractionDigits) {
        self.init()
        self.numberStyle = .DecimalStyle
        
        switch rounding {
        case .FractionDigits:
            self.usesSignificantDigits = false
            self.minimumFractionDigits = digits
            self.maximumFractionDigits = digits
            break
        case .SignificantDigits:
            self.usesSignificantDigits = true
            self.minimumSignificantDigits = digits
            self.maximumSignificantDigits = digits
            break
        }
        
        self.multiplier = multiplier
        
        self.positiveSuffix = suffix
        self.negativeSuffix = suffix
    }
    
}
