//
//  SwiftUI-Fonts.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/3/25.
//

import SwiftUI

extension Font {
    static func instrumentR(size: CGFloat) -> Font {
            return Font.custom("InstrumentSerif-Regular", size: size)
        }
    static func instrumentI(size: CGFloat) -> Font {
            return Font.custom("InstrumentSerif-Italic", size: size)
        }
    static func instrumentSan(size: CGFloat) -> Font {
            return Font.custom("InstrumentSans-Medium", size: size)
        }
        
}
