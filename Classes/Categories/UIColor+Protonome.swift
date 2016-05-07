//
//  UIColor+Protonome.swift
//  HOWL
//
//  Created by Daniel Clelland on 20/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp

// MARK: - Color scheme

public extension UIColor {
    
    // MARK: - Colors
    
    public static func protonome_darkColor(withHue hue: CGFloat, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0) -> UIColor {
        return UIColor(
            hue: hue,
            saturation: saturation.clamp(min: 0.0, max: 1.0).lerp(min: 0.0, max: 0.5),
            brightness: brightness.clamp(min: 0.0, max: 1.0).lerp(min: 0.2, max: 0.5),
            alpha: 1.0
        )
    }
    
    public static func protonome_mediumColor(withHue hue: CGFloat, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0) -> UIColor {
        return UIColor(
            hue: hue,
            saturation: saturation.clamp(min: 0.0, max: 1.0).lerp(min: 0.0, max: 0.625),
            brightness: brightness.clamp(min: 0.0, max: 1.0).lerp(min: 0.25, max: 0.75),
            alpha: 1.0
        )
    }
    
    public static func protonome_lightColor(withHue hue: CGFloat, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0) -> UIColor {
        return UIColor(
            hue: hue,
            saturation: saturation.clamp(min: 0.0, max: 1.0).lerp(min: 0.0, max: 0.75),
            brightness: brightness.clamp(min: 0.0, max: 1.0).lerp(min: 0.3, max: 1.0),
            alpha: 1.0
        )
    }
    
    // MARK: - Greyscale colors
    
    public static func protonome_blackColor() -> UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    public static func protonome_darkGreyColor() -> UIColor {
        return UIColor(white: 0.2, alpha: 1.0)
    }
    
    public static func protonome_mediumGreyColor() -> UIColor {
        return UIColor(white: 0.25, alpha: 1.0)
    }
    
    public static func protonome_lightGreyColor() -> UIColor {
        return UIColor(white: 0.3, alpha: 1.0)
    }
    
    public static func protonome_whiteColor() -> UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }

}
