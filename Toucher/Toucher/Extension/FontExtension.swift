//
//  FontExtension.swift
//  Toucher
//
//  Created by hyunjun on 2023/08/31.
//

import Foundation
import SwiftUI

extension Font {
    static func customTitle() -> Font {
        return Font.system(size: 34, weight: .bold)
    }
    static func customDescriptionEmphasis() -> Font {
        return Font.system(size: 28, weight: .bold)
    }
    static func customDescription() -> Font {
        return Font.system(size: 28, weight: .regular)
    }
    static func customButtonText() -> Font {
        return Font.system(size: 24, weight: .bold)
    }
}
