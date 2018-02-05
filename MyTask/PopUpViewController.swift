//
//  PopUpViewController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/02/04.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTapClose(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
