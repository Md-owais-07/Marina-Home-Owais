//
//  AppColors.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit

final class AppColors {
    static let shared = AppColors()

    func getColor(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1) -> UIColor {
        return UIColor(red: R / 255, green: G / 255, blue: B / 255, alpha: A)
    }

    // MARK: - App Colors
    var Color_black_000000: UIColor {// black
        getColor(R: 0, G: 0, B: 0)
    }

    var Color_white_FFFFFF: UIColor {// white
        getColor(R: 255, G: 255, B: 255)
    }

    var Color_grey_F6F6F6: UIColor {// grey
        getColor(R: 246, G: 246, B: 246)
    }

    var Color_yellow_AB936B: UIColor {// yellow
        getColor(R: 171, G: 147, B: 107)
    }
    var Color_yellow_A89968: UIColor {// yellow
        getColor(R: 168, G: 153, B: 104)
    }
    var Color_red_FF0000: UIColor {// red
        getColor(R: 255, G: 0, B: 0)
       
       
    }
    var Color_gray_9A9A9A: UIColor {// red
        getColor(R: 154, G: 154, B: 154)
    }
    
    var Color_gray_CACACA: UIColor {// gray
        getColor(R: 202, G: 202, B: 202)
    }
    
    var Color_ash_CACACA: UIColor {// ash
        getColor(R: 229, G: 229, B: 229)
    }

    var Color_orange_EDA400: UIColor {// orange
        getColor(R: 237, G: 164, B: 0)
    }
    // MARK: START MHIOS-1169
    var Color_darkGray_8C8C8C: UIColor {// Dark Gray
        getColor(R: 140, G: 140, B: 140)
    }
    // MARK: END MHIOS-1169
}


