//
//  AudioKitControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp
import SnapKit

@IBDesignable public class AudioKitControl: UIControl {
    
    // MARK: - Inspectable properties
    
    // MARK: Title
    
    @IBInspectable public var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    // MARK: Font
    
    var font: UIFont = UIFont.systemFontOfSize(12.0) {
        didSet {
            titleLabel.font = font
        }
    }
    
    @IBInspectable public var fontName: String {
        set {
            font = UIFont(name: newValue, size: fontSize) ?? UIFont.systemFontOfSize(fontSize)
        }
        get {
            return font.fontName
        }
    }
    
    @IBInspectable public var fontSize: CGFloat {
        set {
            font = UIFont(name: fontName, size: newValue) ?? UIFont.systemFontOfSize(newValue)
        }
        get {
            return font.pointSize
        }
    }
    
    // MARK: Color
    
    @IBInspectable public var textColor: UIColor {
        set {
            titleLabel.textColor = newValue
        }
        get {
            return titleLabel.textColor
        }
    }
    
    // MARK: Value
    
    @IBInspectable public var value: Double = 0.0 {
        didSet {
//            valueLabel.text = valueText
            setNeedsDisplay()
            sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    @IBInspectable public var valueMin: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var valueMax: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var valueSteps: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Scale
    
    enum Scale {
        case Linear(min: Double, max: Double)
        case LinearStep(min: Double, max: Double)
        case Logarithmic(min: Double, max: Double)
        case LogarithmicStep(min: Double, max: Double)
        
        /// Note that this is non transitive when values contains non unique elements
        case Step(steps: [Double])
        
        func value(forPercentage percentage: Double) -> Double {
            switch self {
            case .Linear(let min, let max):
                return percentage.lerp(min: min, max: max)
            case .LinearStep(let min, let max):
                return round(percentage.lerp(min: min, max: max))
            case .Logarithmic(let min, let max):
                return pow(percentage, Double(M_E)).lerp(min: min, max: max)
            case .LogarithmicStep(let min, let max):
                return round(pow(percentage, Double(M_E)).lerp(min: min, max: max))
            case .Step(let steps):
                let index = Int(round(percentage * Double(steps.count)))
                switch index {
                case (.min)..<0:
                    return steps.first!
                case 0..<steps.count:
                    return steps[index]
                case steps.count...(.max):
                    return steps.last!
                }
            }
        }
        
        func percentage(forValue value: Double) -> Double {
            switch self {
            case .Linear(let min, let max):
                return value.ilerp(min: min, max: max)
            case .LinearStep(let min, let max):
                return round(value).ilerp(min: min, max: max)
            case .Logarithmic(let min, let max):
                return pow(value.ilerp(min: min, max: max), 1.0 / Double(M_E))
            case .LogarithmicStep(let min, let max):
                return pow(round(value).ilerp(min: min, max: max), 1.0 / Double(M_E))
            case .Step(let steps):
                if let index = steps.indexOf(value) {
                    return Double(index)
                } else {
                    return 0.0
                }
            }
        }
    }
    
    // This should be the other way around, the scale should be a value that retains state...
    
    var scale: Scale {
        switch (scaleLogarithmic, scaleStep, scaleSteps) {
        case (false, false, nil):
            return .Linear(min: valueMin, max: valueMax)
        case (false, true, nil):
            return .LinearStep(min: valueMin, max: valueMax)
        case (true, false, nil):
            return .Logarithmic(min: valueMin, max: valueMax)
        case (true, true, nil):
            return .LogarithmicStep(min: valueMin, max: valueMax)
        case (_, _, let steps):
            return .Step(steps: steps!)
        }
    }
    
    @IBInspectable public var scaleLogarithmic: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var scaleStep: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var scaleSteps: [Double]? {
        return nil
    }
    
    // MARK: Corner radius
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Views
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        return label
    }()
    
    // MARK: - Overrides
    
    override public var selected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var highlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setNeedsUpdateConstraints()
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        addSubview(titleLabel)
        titleLabel.snp_updateConstraints { make in
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
    }
    
    // MARK: - Scale
    
    // MARK - Overrides
    
    public override func drawRect(rect: CGRect) {
        let backgroundPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        backgroundPath.fill()
        backgroundPath.addClip()
    }

}

// MARK: - Private getters

private extension AudioKitControl {
    
}
