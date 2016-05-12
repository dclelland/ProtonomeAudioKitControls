//
//  ParameterScale.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation
import Lerp

protocol ParameterScale {
    
    func value(forRatio ratio: Float) -> Float
    
    func ratio(forValue value: Float) -> Float
    
}

struct LinearParameterScale: ParameterScale {
    
    var minimum: Float
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return ratio.lerp(min: minimum, max: maximum)
    }
    
    func ratio(forValue value: Float) -> Float {
        return value.ilerp(min: minimum, max: maximum)
    }
    
}

struct LogarithmicParameterScale: ParameterScale {
    
    var minimum: Float
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return pow(ratio, Float(M_E)).lerp(min: minimum, max: maximum)
    }
    
    func ratio(forValue value: Float) -> Float {
        return pow(value.ilerp(min: minimum, max: maximum), 1.0 / Float(M_E))
    }
    
}

struct IntegerParameterScale: ParameterScale {
    
    var minimum: Float
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return round(ratio.lerp(min: minimum, max: maximum))
    }
    
    func ratio(forValue value: Float) -> Float {
        return round(value).ilerp(min: minimum, max: maximum)
    }

}

struct SteppedParameterScale: ParameterScale {
    
    var steps: [Float]
    
    init(steps: [Float]) {
        self.steps = steps
    }
    
    init(string: String) {
        self.init(steps: [0.0, 1.0])
    }
    
    func value(forRatio ratio: Float) -> Float {
        let index = Int(round(ratio * Float(steps.count)))
        switch index {
        case (.min)..<0:
            return steps.first!
        case 0..<steps.count:
            return steps[index]
        case steps.count...(.max):
            return steps.last!
        }
    }
    
    func ratio(forValue value: Float) -> Float {
        if let index = steps.indexOf(value) {
            return Float(index)
        } else {
            return 0.0
        }
    }
    
}
