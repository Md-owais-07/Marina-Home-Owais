//
//  MyDataSource.swift
//  Marina Home
//
//  Created by santhosh t on 23/06/23.
//

import Foundation
import UBottomSheet
import UIKit

class MyDataSource: UBottomSheetCoordinatorDataSource {
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let screenWidth = UIScreen.main.bounds.width
    
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
        return [screenWidth+statusBarHeight-7,statusBarHeight+40]//.map{$0*availableHeight}
    }
    
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
        return screenWidth+statusBarHeight-7 //availableHeight*0.6
    }

//    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
//        return [(UIScreen.main.bounds.width+statusBarHeight)+7,statusBarHeight]//.map{$0*availableHeight}
//    }
//    
//    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
//        return (UIScreen.main.bounds.width+statusBarHeight)+7 //availableHeight*0.6
//    }
    
    
    
}
