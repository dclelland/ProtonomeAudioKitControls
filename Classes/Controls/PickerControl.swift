//
//  PickerControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

@IBDesignable public class PickerControl: ParameterControl {
    
    // MARK: - Properties
    
    @IBInspectable public var columns: UInt = 0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var rows: UInt = 0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Overrideables
    
    override func ratio(forLocation location: CGPoint) -> Float {
        return 0.0
    }
    
    override func path(forRatio ratio: Float) -> UIBezierPath {
        return UIBezierPath()
    }
    
}
