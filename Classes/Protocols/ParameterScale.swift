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
    
    var values: [Float]
    
    func value(forRatio ratio: Float) -> Float {
        let index = Int(round(ratio * Float(values.count)))
        switch index {
        case (.min)..<0:
            return values.first!
        case 0..<values.count:
            return values[index]
        default:
            return values.last!
        }
    }
    
    func ratio(forValue value: Float) -> Float {
        if let index = values.indexOf(value) {
            return Float(index)
        } else {
            return 0.0
        }
    }
    
}
