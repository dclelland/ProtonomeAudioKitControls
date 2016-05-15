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
        return ratio.clamp(min: 0.0, max: 1.0).lerp(min: minimum, max: maximum)
    }
    
    func ratio(forValue value: Float) -> Float {
        return value.ilerp(min: minimum, max: maximum).clamp(min: 0.0, max: 1.0)
    }
    
}

struct LogarithmicParameterScale: ParameterScale {
    
    var minimum: Float
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return pow(ratio.clamp(min: 0.0, max: 1.0), Float(M_E)).lerp(min: minimum, max: maximum)
    }
    
    func ratio(forValue value: Float) -> Float {
        return pow(value.ilerp(min: minimum, max: maximum), 1.0 / Float(M_E)).clamp(min: 0.0, max: 1.0)
    }
    
}

struct IntegerParameterScale: ParameterScale {
    
    var minimum: Float
    var maximum: Float
    
    func value(forRatio ratio: Float) -> Float {
        return round(ratio.clamp(min: 0.0, max: 1.0).lerp(min: minimum, max: maximum))
    }
    
    func ratio(forValue value: Float) -> Float {
        return round(value).ilerp(min: minimum, max: maximum).clamp(min: 0.0, max: 1.0)
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
        if (values.indices.contains(index)) {
            return values[index]
        } else {
            return 0.0
        }
    }
    
    // MARK: Value to index to ratio
    
    private func index(forValue value: Float) -> Int {
        return values.indexOf(value) ?? 0
    }
    
    private func ratio(forIndex index: Int) -> Float {
        return Float(index) / Float(values.count - 1)
    }
    
}
