//
//  DashBoardVC.swift
//  Sabjiwala
//
//  Created by Ritesh Jain on 12/06/18.
//  Copyright © 2018 OWeBest.com. All rights reserved.
//

import Foundation
import UIKit



class Config: NSObject,UIAlertViewDelegate {
    
    let API_URL = "https://itunes.apple.com/"
    
    
    let AppAlertTitle = "Demo Teat"
    let AppUserDefaults = UserDefaults.standard
    
    let debug_mode = 1
    let NO_IMAGE = "NoImage"
    
    let USER_NO_IMAGE = "NoImage"
    

    
    let AppWhiteColor = UIColor.white
    let AppClearColor = UIColor.clear
    
    func printData(_ dataValue : Any ){
        if debug_mode == 1 {
            print(dataValue)
        }
    }
    
    func AppGlobalFont(_ fontSize:CGFloat,isBold:Bool) -> UIFont {
        
        let fontName : String!
        fontName = (isBold) ? "Lato-Bold" : "Lato-Regular"
        
        return UIFont(name: fontName, size: fontSize)!
    }
    
    
}

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
extension UIViewController{
   func LoadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.gray
    loadingIndicator.color = UIColor(red: 168.0/255, green: 47.0/255, blue: 134.0/255, alpha: 1.0)
    loadingIndicator.startAnimating();

    ProgressDialog.alert.view.addSubview(loadingIndicator)
    present(ProgressDialog.alert, animated: true, completion: nil)
  }

  func LoadingStop(){
    ProgressDialog.alert.dismiss(animated: true, completion: nil)
  }
}




