//
//  ParameterControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp
import SnapKit

@IBDesignable public class ParameterControl: UIControl {
    
    // MARK: - Properties
    
    // MARK: Title
    
    @IBInspectable public var title: String? {
        didSet {
            titleLabel.text = title
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
    
    // MARK: Value
    
    @IBInspectable public var value: Float = 0.0 {
        didSet {
            setNeedsDisplay()
            sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    @IBInspectable public var valueMin: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var valueMax: Float = 1.0 {
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
    
    var scale: AudioKitControlScale {
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
    
    private var scaleSteps: [Float]? {
        // TODO: this
        // separate valueSteps by whitespace and commas, convert to doubles, prune nils, return nil if empty array
        return nil
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
        label.textColor = UIColor.protonome_blackColor()
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
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        titleLabel.snp_updateConstraints { make in
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
    }
    
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, backgroundPathColor.CGColor)
        backgroundPath.fill()
        backgroundPath.addClip()
        
        CGContextSetFillColorWithColor(context, foregroundPathColor.CGColor)
        foregroundPath.fill()
    }
    
    // MARK: - Touches
    
    private var touch: UITouch? {
        didSet {
            selected = touch != nil
        }
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = touches.first
        
        if let location = touch?.locationInView(self) {
            value = scale.value(forPercentage: percentage(forLocation: location))
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touch?.locationInView(self) {
            value = scale.value(forPercentage: percentage(forLocation: location))
        }
        
        super.touchesMoved(touches, withEvent: event)
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touch = nil
        
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = nil
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    // MARK: - Overrideables
    
    func percentage(forLocation location: CGPoint) -> Float {
        return 0.0
    }
    
    func path(forPercentage percentage: Float) -> UIBezierPath {
        return UIBezierPath()
    }
    
    // MARK: Private getters
    
    private var hue: CGFloat {
        return CGFloat(scale.percentage(forValue: value).lerp(min: 215.0, max: 0.0) / 360.0)
    }
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
    
    private var backgroundPathColor: UIColor {
        if (highlighted || selected) {
            return UIColor.protonome_mediumColor(withHue: hue)
        } else {
            return UIColor.protonome_darkColor(withHue: hue)
        }
    }
    
    private var foregroundPath: UIBezierPath {
        return path(forPercentage: scale.percentage(forValue: value))
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: hue)
    }

}

// MARK: - Scale

public enum AudioKitControlScale {
    case Linear(min: Float, max: Float)
    case LinearStep(min: Float, max: Float)
    case Logarithmic(min: Float, max: Float)
    case LogarithmicStep(min: Float, max: Float)
    
    /// Note that this is non transitive when values contains non unique elements
    case Step(steps: [Float])
    
    public func value(forPercentage percentage: Float) -> Float {
        switch self {
        case .Linear(let min, let max):
            return percentage.lerp(min: min, max: max)
        case .LinearStep(let min, let max):
            return round(percentage.lerp(min: min, max: max))
        case .Logarithmic(let min, let max):
            return pow(percentage, Float(M_E)).lerp(min: min, max: max)
        case .LogarithmicStep(let min, let max):
            return round(pow(percentage, Float(M_E)).lerp(min: min, max: max))
        case .Step(let steps):
            let index = Int(round(percentage * Float(steps.count)))
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
    
    public func percentage(forValue value: Float) -> Float {
        switch self {
        case .Linear(let min, let max):
            return value.ilerp(min: min, max: max)
        case .LinearStep(let min, let max):
            return round(value).ilerp(min: min, max: max)
        case .Logarithmic(let min, let max):
            return pow(value.ilerp(min: min, max: max), 1.0 / Float(M_E))
        case .LogarithmicStep(let min, let max):
            return pow(round(value).ilerp(min: min, max: max), 1.0 / Float(M_E))
        case .Step(let steps):
            if let index = steps.indexOf(value) {
                return Float(index)
            } else {
                return 0.0
            }
        }
    }
}
