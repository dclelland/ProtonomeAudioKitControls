//
//  AudioControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp
import SnapKit

@IBDesignable public class AudioControl: UIControl {
    
    // MARK: - Properties
    
    // MARK: Title
    
    @IBInspectable public var title: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: Value
    
    @IBInspectable public var value: Float = 0.0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
            sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    // MARK: Scale
    
    var scale: ParameterScale {
        guard let type = ScaleType(rawValue: scaleType) else {
            fatalError("Invalid scale type \"\(scaleType)\" in control with title \"\(title)\"")
        }
        
        switch type {
        case .Linear:
            return LinearParameterScale(minimum: scaleMin, maximum: scaleMax)
        case .Logarithmic:
            return LogarithmicParameterScale(minimum: scaleMin, maximum: scaleMax)
        case .Integer:
            return IntegerParameterScale(minimum: scaleMin, maximum: scaleMax)
        case .Stepped:
            return SteppedParameterScale(values: scaleValues)
        }
    }
    
    public enum ScaleType: String {
        case Linear = "linear"
        case Logarithmic = "logarithmic"
        case Integer = "integer"
        case Stepped = "stepped"
    }
    
    @IBInspectable public var scaleType: String = ScaleType.Linear.rawValue {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var scaleMin: Float = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var scaleMax: Float = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var scaleSteps: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var scaleValues: [Float] {
        return scaleSteps.characters.split(",").map { Float(String($0))! }
    }
    
    // MARK: Formatter
    
    var formatter: ParameterFormatter {
        guard let type = FormatterType(rawValue: formatterType) else {
            fatalError("Invalid formatter type \"\(formatterType)\" in control with title \"\(title)\"")
        }
        
        switch type {
        case .Number:
            return NumberParameterFormatter()
        case .Integer:
            return IntegerParameterFormatter()
        case .Percentage:
            return PercentageParameterFormatter()
        case .Duration:
            return DurationParameterFormatter()
        case .Amplitude:
            return AmplitudeParameterFormatter()
        case .Frequency:
            return FrequencyParameterFormatter()
        case .Interval:
            return IntervalParameterFormatter()
        case .Stepped:
            let steps = NSDictionary.init(objects: formatterValues, forKeys: scaleValues) as! [Float: String]
            return SteppedParameterFormatter(steps: steps)
        }
    }
    
    public enum FormatterType: String {
        case Number = "number"
        case Integer = "integer"
        case Percentage = "percentage"
        case Duration = "duration"
        case Amplitude = "amplitude"
        case Frequency = "frequency"
        case Interval = "interval"
        case Stepped = "stepped"
    }
    
    @IBInspectable public var formatterType: String = FormatterType.Number.rawValue {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var formatterSteps: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var formatterValues: [String] {
        return formatterSteps.characters.split(",").map { String($0) }
    }
    
    // MARK: Font
    
    var font: UIFont = UIFont.systemFontOfSize(12.0) {
        didSet {
            setNeedsLayout()
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
    
    // MARK: Corner radius
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
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
            setNeedsLayout()
        }
    }
    
    override public var highlighted: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setNeedsUpdateConstraints()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(didChangeValue), forControlEvents: .ValueChanged)
        addTarget(self, action: #selector(didTouchDown), forControlEvents: .TouchDown)
        addTarget(self, action: #selector(didTouchUp), forControlEvents: .TouchUpInside)
        addTarget(self, action: #selector(didTouchUp), forControlEvents: .TouchUpOutside)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.text = title
        titleLabel.font = font
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
    
    // MARK: - Actions
    
    public var onChangeValue: ((value: Float) -> Void)?
    
    internal func didChangeValue() {
        onChangeValue?(value: value)
    }
    
    public var onTouchDown: (Void -> Void)?
    
    internal func didTouchDown() {
        onTouchDown?()
    }
    
    public var onTouchUp: (Void -> Void)?
    
    internal func didTouchUp() {
        onTouchUp?()
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
            value = scale.value(forRatio: ratio(forLocation: location))
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touch?.locationInView(self) {
            value = scale.value(forRatio: ratio(forLocation: location))
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
    
    func ratio(forLocation location: CGPoint) -> Float {
        fatalError("Subclasses of ParameterControl must override ratio(forLocation:)")
    }
    
    func path(forRatio ratio: Float) -> UIBezierPath {
        fatalError("Subclasses of ParameterControl must override path(forRatio:)")
    }
    
    // MARK: - Private getters
    
    private var hue: CGFloat {
        return CGFloat(scale.ratio(forValue: value).lerp(min: 215.0, max: 0.0) / 360.0)
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
        return path(forRatio: scale.ratio(forValue: value))
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: hue)
    }

}
