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
        return value(forIndex: index(forRatio: ratio))
    }
    
    func ratio(forValue value: Float) -> Float {
        return ratio(forIndex: index(forValue: value))
    }
    
    // MARK: Ratio to index to value
    
    private func index(forRatio ratio: Float) -> Int {
        return Int(round(ratio * Float(values.count - 1)))
    }
    
    private func value(forIndex index: Int) -> Float {
        return values[index]
    }
    
    // MARK: Value to index to ratio
    
    private func index(forValue value: Float) -> Int {
        return values.indexOf(value)!
    }
    
    private func ratio(forIndex index: Int) -> Float {
        return Float(index) / Float(values.count - 1)
    }
    
}
