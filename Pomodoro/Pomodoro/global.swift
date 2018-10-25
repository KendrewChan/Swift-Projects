//
//  global.swift
//  Pomodoro
//
//  Created by Kendrew Chan on 26/11/17.
//  Copyright © 2017 testtest. All rights reserved.
//

import UIKit

class global: UIViewController {

    var seconds: Int
    init(seconds:Int) {
        self.seconds = seconds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mainInstance = global(seconds: 0)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
