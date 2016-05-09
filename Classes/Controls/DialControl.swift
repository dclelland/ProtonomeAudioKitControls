//
//  DialControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import Degrad
import Lerp
import SnapKit

@IBDesignable public class DialControl: AudioKitControl {
    
    // MARK: - Constants
    
    private let dialRadius: Float = 0.375
    
    private let minimumAngle: Float = 45°
    private let maximumAngle: Float = 315°
    
    private let minimumDeadZone: Float = 2°
    private let maximumDeadZone: Float = 358°
    
    // MARK: - Properties
    
    @IBInspectable public var title: String? { didSet { titleLabel.text = titleText } }
    
    @IBInspectable public var value: Float = 0.0 {
        didSet {
            valueLabel.text = valueText
            setNeedsDisplay()
            sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    @IBInspectable public var valueMinimum: Float = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable public var valueMaximum: Float = 1.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable public var valueSuffix: String? { didSet { valueLabel.text = valueText } }
    @IBInspectable public var valuePrecision: Int = 0 { didSet { valueLabel.text = valueText } }
    
    @IBInspectable public var scaleLogarithmic: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable public var scaleStep: Bool = false { didSet { setNeedsDisplay() } }
    
    @IBInspectable public var textColor: UIColor = UIColor.blackColor() { didSet { configureLabels() } }
    @IBInspectable public var textHeight: CGFloat = 16.0 { didSet { setNeedsUpdateConstraints() } }

    @IBInspectable public var fontName: String? { didSet { configureLabels() } }
    @IBInspectable public var fontSize: CGFloat = 12.0 { didSet { configureLabels() } }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        return label
    }()
    
    public lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        return label
    }()
    
    // MARK: - Overrides
    
    override public var selected: Bool { didSet { setNeedsDisplay() } }
    
    override public var highlighted: Bool { didSet { setNeedsDisplay() } }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        titleLabel.snp_updateConstraints { make in
            make.height.equalTo(self.textHeight)
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
        }
        
        valueLabel.snp_updateConstraints { make in
            make.top.equalTo(self.snp_topMargin)
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.bottom.equalTo(titleLabel.snp_top)
        }
    }

    override public func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, backgroundPathColor.CGColor)
        CGContextAddPath(context, backgroundPath.CGPath)
        CGContextFillPath(context)
        
        CGContextSetFillColorWithColor(context, foregroundPathColor.CGColor)
        CGContextAddPath(context, foregroundPath.CGPath)
        CGContextFillPath(context)
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        titleLabel.textColor = textColor
        valueLabel.textColor = textColor
        
        if let fontName = fontName {
            let font = UIFont(name: fontName, size: fontSize)
            titleLabel.font = font
            valueLabel.font = font
        } else {
            let font = UIFont.systemFontOfSize(fontSize)
            titleLabel.font = font
            valueLabel.font = font
        }
    }
    
    // MARK: - Touches
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = touches.first
        selected = true
        
        if let location = touch?.locationInView(self) {
            percentage = percentageForLocation(location)
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touch?.locationInView(self) {
            percentage = percentageForLocation(location)
        }
        
        super.touchesMoved(touches, withEvent: event)
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touch = nil
        selected = false
        
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = nil
        selected = false
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    // MARK: - Private getters (text)
    
    private var titleText: String? {
        return title
    }
    
    private var valueText: String? {
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.positiveSuffix = valueSuffix ?? ""
        numberFormatter.negativeSuffix = valueSuffix ?? ""
        numberFormatter.minimumFractionDigits = valuePrecision
        numberFormatter.maximumFractionDigits = valuePrecision
        
        /* Needs check for negative zero values */
        
        return numberFormatter.stringFromNumber(value == -0 ? 0 : value)
    }
    
    // MARK: - Private getters (values)
    
    private var touch: UITouch?
    
    private var percentage: Float {
        set {
            switch scale {
            case .Linear:
                value = newValue.lerp(min: valueMinimum, max: valueMaximum)
            case .LinearStep:
                value = round(newValue.lerp(min: valueMinimum, max: valueMaximum))
            case .Logarithmic:
                value = pow(newValue, Float(M_E)).lerp(min: valueMinimum, max: valueMaximum)
            case .LogarithmicStep:
                value = round(pow(newValue, Float(M_E)).lerp(min: valueMinimum, max: valueMaximum))
            }
        }
        get {
            switch scale {
            case .Linear:
                return value.ilerp(min: valueMinimum, max: valueMaximum)
            case .LinearStep:
                return round(value).ilerp(min: valueMinimum, max: valueMaximum)
            case .Logarithmic:
                return pow(value.ilerp(min: valueMinimum, max: valueMaximum), 1.0 / Float(M_E))
            case .LogarithmicStep:
                return pow(round(value).ilerp(min: valueMinimum, max: valueMaximum), 1.0 / Float(M_E))
            }
        }
    }
    
    private func percentageForLocation(location: CGPoint) -> Float {
        let center = valueLabel.center
        let radius = dialRadius * Float(min(valueLabel.frame.height, valueLabel.frame.width))
        
        let distance = Float(hypot(location.y - center.y, location.x - center.x))
        let angle = Float(atan2(location.y - center.y, location.x - center.x))
        
        guard radius < distance else {
            return percentage
        }
        
        let scaledAngle = fmod(angle + 270°, 360°)
        
        guard (minimumDeadZone...maximumDeadZone).contains(scaledAngle) else {
            return percentage
        }
        
        return scaledAngle.ilerp(min: minimumAngle, max: maximumAngle).clamp(min: 0.0, max: 1.0)
    }
    
    private enum Scale {
        case Linear
        case LinearStep
        case Logarithmic
        case LogarithmicStep
    }
    
    private var scale: Scale {
        switch (scaleLogarithmic, scaleStep) {
        case (false, false):
            return .Linear
        case (false, true):
            return .LinearStep
        case (true, false):
            return .Logarithmic
        case (true, true):
            return .LogarithmicStep
        }
    }
    
    // MARK: - Private getters (drawing)
    
    private var hue: CGFloat {
        return CGFloat(lerp(percentage, min: 215.0, max: 0.0) / 360.0)
    }
    
    private var backgroundPathColor: UIColor {
        if (highlighted || selected) {
            return UIColor.protonome_mediumColor(withHue: hue)
        } else {
            return UIColor.protonome_darkColor(withHue: hue)
        }
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: hue)
    }
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
    }
    
    private var foregroundPath: UIBezierPath {
        let center = valueLabel.center
        
        let radius = CGFloat(dialRadius) * min(valueLabel.frame.height, valueLabel.frame.width)
        let angle = CGFloat(percentage.lerp(min: minimumAngle, max: maximumAngle) + 90°)
        
        let pointerA = pol2rec(r: radius * 0.75, θ: angle - 45°)
        let pointerB = pol2rec(r: radius * 1.25, θ: angle)
        let pointerC = pol2rec(r: radius * 0.75, θ: angle + 45°)
        
        return UIBezierPath.makePath { make in
            make.oval(at: center, radius: radius)
            make.move(x: center.x + pointerA.x, y: center.y + pointerA.y)
            make.line(x: center.x + pointerB.x, y: center.y + pointerB.y)
            make.line(x: center.x + pointerC.x, y: center.y + pointerC.y)
            make.close()
        }
    }
    
}
