//
//  ActivityIndicator.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit
extension AppUIViewController {
    
   func showActivityIndicator(uiView: UIView) {
      if self.indicatorActiveCount == 0 {
         DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            if self.loadingView == nil {
               self.loadingView = UIView(frame: UIScreen.main.bounds)
               self.loadingView.backgroundColor = UIColor.clear
               
                self.tabBarController?.view.addSubview(self.loadingView)
               let transparentView = UIView(frame: self.loadingView.bounds)
               transparentView.backgroundColor = UIColor(white: 0, alpha: 0.01)
               self.loadingView.addSubview(transparentView)
               let rectangleView = UIView(frame: CGRect(x: (self.loadingView.bounds.size.width / 2) - 50.0, y: (self.loadingView.bounds.size.height / 2) - 50.0, width: 100.0, height: 100.0))
               rectangleView.layer.cornerRadius = 10
               rectangleView.backgroundColor = UIColor.clear
               self.loadingView.addSubview(rectangleView)
               let indicator = UIActivityIndicatorView(frame: CGRect(x: (rectangleView.frame.size.width / 2) - 25.0, y: (rectangleView.frame.size.height / 2) - 25.0, width: 50.0, height: 50.0))
               indicator.color = AppColors.shared.Color_black_000000
               indicator.transform = CGAffineTransform(scaleX: 1, y: 1)
               rectangleView.addSubview(indicator)
               indicator.startAnimating()
            }
         }
      }
      self.indicatorActiveCount += 1
   }

   func hideActivityIndicator(uiView: UIView) {
      if indicatorActiveCount > 0 {
         if indicatorActiveCount == 1 {
            DispatchQueue.main.async {
               self.view.isUserInteractionEnabled = true
               if self.loadingView != nil {
                  self.loadingView.removeFromSuperview()
                  self.loadingView = nil
               }
            }
         }
         indicatorActiveCount -= 1
      }
   }
}

