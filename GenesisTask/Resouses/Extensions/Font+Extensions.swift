//
//  Font+Extensions.swift
//  GenesisTask
//
//  Created by Artur Korol on 28.07.2025.
//

import SwiftUI

extension Font {
    static func kaiseiTokuminBold(size: CGFloat) -> Font {
        Font.custom("KaiseiTokumin-Bold", size: size)
    }

    static func kaiseiTokuminExtraBold(size: CGFloat) -> Font {
        Font.custom("KaiseiTokumin-ExtraBold", size: size)
    }

    static func kaiseiTokuminMedium(size: CGFloat) -> Font {
        Font.custom("KaiseiTokumin-Medium", size: size)
    }

    static func kaiseiTokuminRegular(size: CGFloat) -> Font {
        Font.custom("KaiseiTokumin-Regular", size: size)
    }

    static func poppinsLight(size: CGFloat) -> Font {
        Font.custom("Poppins-Light", size: size)
    }

    static func poppinsMedium(size: CGFloat) -> Font {
        Font.custom("Poppins-Medium", size: size)
    }
}
