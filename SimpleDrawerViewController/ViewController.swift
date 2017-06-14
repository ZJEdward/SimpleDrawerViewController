//
//  ViewController.swift
//  test
//
//  Created by Edward on 2017/6/14.
//  Copyright © 2017年 钟进. All rights reserved.
//

import UIKit

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    var isStatusHidden: Bool = false
    
    lazy var leftVc : SecondViewController = {
        let vc = SecondViewController()
        vc.view.backgroundColor = UIColor.purple
        vc.view.frame = CGRect(x: -width, y: 0, width: width, height: height)
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "111"
        
        
        //弹出侧边栏按钮
        let frame: CGRect = CGRect(x: 100, y: 100, width: 100, height: 40)
        let btn = UIButton(frame: frame)
        view.addSubview(btn)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(ViewController.clicked), for: .touchUpInside)
        
        
        //添加自控制器
        view.addSubview(leftVc.view)
        addChildViewController(leftVc)
        
        //添加手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)));
        leftVc.view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture));
        leftVc.view.addGestureRecognizer(tap)
        
    }
    
    func panGesture(pan: UIPanGestureRecognizer) -> () {
        
        let transPan = pan.translation(in: view)
        let offSetX = transPan.x
        
        leftVc.view.frame.origin.x = offSetX
        
        if pan.state == .ended { //拖拽手势离开屏幕
            
            if -offSetX > width*0.3 { //判断手势移动到的位置
                
                isStatusHidden = false
                UIView.animate(withDuration: TimeInterval(0.25)) {
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.leftVc.view.frame.origin.x = -width
                }
                
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.leftVc.view.frame.origin.x = 0
                }
            }
        }
        
    }
    
    //点击手势
    func tapGesture() -> () {
        
        isStatusHidden = false
        UIView.animate(withDuration: TimeInterval(0.25)) {
            self.setNeedsStatusBarAppearanceUpdate()
            self.leftVc.view.frame = CGRect(x: -width, y: 0, width: width, height: height)
        }
        
        
    }
    
    
    //按钮事件
    func clicked() -> () {
        
        isStatusHidden = true
        
        UIView.animate(withDuration: 0.25) {
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.leftVc.view.frame = CGRect(x: 0, y: 0, width: width-100, height: height)
        }
    }
    
    
    //重写父类方法
    override var prefersStatusBarHidden: Bool {
        return isStatusHidden
    }
    
    //状态栏收回动画
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return .slide
    }
    
}

