//
//  UIDevice.swift
//  MessengerUI
//
//  Created by Mean Reaksmey on 4/18/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case landscape_5
        case landscape_6
        case unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        case 568:
            return .landscape_5
        case 667:
            return .landscape_6
        default:
            return .unknown
        }
    }
}
