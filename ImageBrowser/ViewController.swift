//
//  ViewController.swift
//  ImageBrowser
//
//  Created by 范鸿麟 on 15/10/14.
//  Copyright © 2015年 范鸿麟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var SCALE_MAX:CGFloat = 3
    var SCALE_MIN:CGFloat = 1
    
    var imageView:UIImageView!
    
    var lastScale:CGFloat = 1
    //    var lastPoint:CGPoint = CGPoint()
    
    var imageName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.userInteractionEnabled = true
        
        imageName = "5.jpg"//之后这个值应该从别的controller中传过来
        
        let image = UIImage(named: imageName)!
        imageView = UIImageView(image: image)
        //        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        initImageView()
        
        self.view.addSubview(imageView)
    }
    
    @IBAction func onPinch(sender: UIPinchGestureRecognizer) {
        lastScale *= sender.scale
        
        //禁止过大过小
        if lastScale > SCALE_MAX {
            lastScale = SCALE_MAX
        }else if lastScale < SCALE_MIN {
            lastScale = SCALE_MIN
        }
        
        self.imageView.transform = CGAffineTransformScale(self.view.transform, lastScale,lastScale)
        sender.scale = 1
        
        //平移后的位置
        var centerX = imageView.center.x
        var centerY = imageView.center.y
        boundCenter(&centerX, centerY: &centerY)
        imageView.center = CGPoint(x:centerX,y:centerY)
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let translate = sender.translationInView(self.view)
        
        //平移后的位置
        var centerX = imageView.center.x + translate.x
        var centerY = imageView.center.y + translate.y
        boundCenter(&centerX, centerY: &centerY)
        imageView.center = CGPoint(x:centerX,y:centerY)
        
        sender.setTranslation(CGPointZero, inView: self.view)
    }
    
    func initImageView(){
        let image = imageView.image!
        
        //初始化imageView的大小
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let mainWidth = self.view.frame.width
        let mainHeight = self.view.frame.height
        
        var destX:CGFloat
        var destY:CGFloat
        var destWidth:CGFloat
        var destHeight:CGFloat
        
        if imageWidth * mainHeight > imageHeight * mainWidth {
            destWidth = mainWidth
            destHeight = imageHeight * mainWidth / imageWidth
            destX = 0
            destY = (mainHeight - destHeight)/2
        }else{
            destWidth = imageWidth * mainHeight / imageHeight
            destHeight = mainHeight
            destX = (mainWidth - destWidth)/2
            destY = 0
        }
        
        imageView.frame = CGRect(x: destX, y: destY, width: destWidth, height: destHeight)
    }
    
    // 限制iamgeView中心的位置
    //当图片大于屏幕时,平移图片时防止平移过头
    func boundCenter(inout centerX:CGFloat,inout centerY:CGFloat){
        let mainFrame = self.view.frame
        let imageFrame = imageView.frame
        
        if imageFrame.width < mainFrame.width {
            centerX = mainFrame.width / 2
        }else{
            let xMin = mainFrame.width - imageFrame.size.width / 2
            let xMax = imageFrame.size.width / 2
            if centerX > xMax {
                centerX = xMax
            }else if centerX < xMin {
                centerX = xMin
            }
        }
        
        if imageFrame.height < mainFrame.height {
            centerY = mainFrame.height / 2
        }else{
            let yMin = mainFrame.height - imageFrame.size.height / 2
            let yMax = imageFrame.size.height / 2
            if centerY > yMax {
                centerY = yMax
            }else if centerY < yMin {
                centerY = yMin
            }
        }
    }
}

