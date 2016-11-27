//
//  ParameterScale.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import Foundation
import Lerp

/// A protocol which describes a two-way conversion between a ratio in range `0.0...`1.0` and useful values.
protocol ParameterScale {
    
    /// Converts a ratio in range `0.0...1.0` to a useful value.
    func value(for ratio: Double) -> Double
    
    /// Converts a value to a ratio in range `0.0...1.0`.
    func ratio(for value: Double) -> Double
    
}

/// A scale describing a linear conversion. Interpolates a ratio in range `0.0...1.0` to a value range `minimum...maximum`.
/// For example, if `minimum` is `2.0` and `maximum` is `4.0`, then a *ratio* of `0.5` will be converted to a *value* of `3.0`.
/// Ratios out of bounds are truncated.
struct LinearParameterScale: ParameterScale {
    
    /// The scale's minimum value.
    var minimum: Double
    
    /// The scale's maximum value.
    var maximum: Double
    
    func value(for ratio: Double) -> Double {
        return ratio.clamp(min: 0.0, max: 1.0).lerp(min: minimum, max: maximum)
    }
    
    func ratio(for value: Double) -> Double {
        return value.ilerp(min: minimum, max: maximum).clamp(min: 0.0, max: 1.0)
    }
    
}

/// A scale describing a logarithmic conversion. Interpolates a ratio in range `0.0...1.0` to a value range `minimum...maximum`, on a logarithmic scale, where the value never hits zero.
/// This results in a scale with a subtle gradient at the start, but a dramatic gradient near the end. This is most useful if you would like your control to cover multiple orders of magnitude.
/// Ratios out of bounds are truncated.
/// Minimum and maximum are expected to either both be positive or both be negative, and neither can be zero.
struct LogarithmicParameterScale: ParameterScale {
    
    /// The scale's minimum value.
    var minimum: Double
    
    /// The scale's maximum value.
    var maximum: Double
    
    func value(for ratio: Double) -> Double {
        return minimum * pow(maximum / minimum, ratio.clamp(min: 0.0, max: 1.0))
    }
    
    func ratio(for value: Double) -> Double {
        return log(value / minimum) / log(maximum / minimum)
    }
    
}

/// A scale describing a logarithmic conversion. Interpolates a ratio in range `0.0...1.0` to a value range `minimum...maximum`, taking the value to the power of `exponent` before the conversion.
/// This is useful if you would like to approximate a logarithmic conversion, but need to support zero values, or values both above and below zero.
/// Ratios out of bounds are truncated.
struct ExponentialParameterScale: ParameterScale {
    
    /// The scale's minimum value.
    var minimum: Double
    
    /// The scale's maximum value.
    var maximum: Double
    
    /// The scale's exponent.
    var exponent: Double
    
    func value(for ratio: Double) -> Double {
        return pow(ratio.clamp(min: 0.0, max: 1.0), exponent).lerp(min: minimum, max: maximum)
    }
    
    func ratio(for value: Double) -> Double {
        return pow(value.ilerp(min: minimum, max: maximum), 1.0 / exponent).clamp(min: 0.0, max: 1.0)
    }
    
}

/// A scale describing a linear conversion including a rounding process. Interpolates a ratio in range `0.0...1.0` to a value range `minimum...maximum`, rounding after conversion.
/// For example, if `minimum` is `2.0` and `maximum` is `4.0`, then a *ratio* of `0.6` will be first converted to a *value* of `3.2`, then *rounded* to `3.0`.
/// Ratios out of bounds are truncated.
struct IntegerParameterScale: ParameterScale {
    
    /// The scale's minimum value.
    var minimum: Double
    
    /// The scale's maximum value.
    var maximum: Double
    
    func value(for ratio: Double) -> Double {
        return round(ratio.clamp(min: 0.0, max: 1.0).lerp(min: minimum, max: maximum))
    }
    
    func ratio(for value: Double) -> Double {
        return round(value).ilerp(min: minimum, max: maximum).clamp(min: 0.0, max: 1.0)
    }

}

/// A scale describing a conversion via picking from a stepped sequence. A ratio in range `0.0...1.0` is first converted to an index in range `0..<values.count`, before being used to pick a value from `values`.
/// For example, if `values` is `[0.5, 1.0, 1.5, 2.0]`, then a ratio of `0.6` will first be converted to an unrounded index of `1.8`, before being rounded to the integer `2`, which will return the value `1.5`.
///
/// Invalid ratios or values will return zero, in the interest of type safety but at the disregard of sensible behaviour (we'd rather return `0.0` than crash in the event some process causes an invalid value to be sent here at run time).
///
/// Values must also be unique, in the interest of transitivity.
struct SteppedParameterScale: ParameterScale {
    
    /// The scale's list of value steps.
    var values: [Double]
    
    func value(for ratio: Double) -> Double {
        return value(forIndex: index(forRatio: ratio))
    }
    
    func ratio(for value: Double) -> Double {
        return ratio(forIndex: index(forValue: value))
    }
    
    // MARK: Ratio to index to value
    
    private func index(forRatio ratio: Double) -> Int {
        return Int(round(ratio * Double(values.count - 1)))
    }
    
    private func value(forIndex index: Int) -> Double {
        if (values.indices.contains(index)) {
            return values[index]
        } else {
            return 0.0
        }
    }
    
    // MARK: Value to index to ratio
    
    private func index(forValue value: Double) -> Int {
        return values.index(of: value) ?? 0
    }
    
    private func ratio(forIndex index: Int) -> Double {
        return Double(index) / Double(values.count - 1)
    }
    
}
