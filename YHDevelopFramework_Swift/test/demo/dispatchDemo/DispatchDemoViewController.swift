//
//  DispatchDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/22.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class DispatchDemoViewController: BaseViewController {

    
    @IBOutlet weak var label: UILabel!
    private var count = 0
    private let timer = YHDispatchTimer()
    private let group = YHDispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        exampleTimer()
        exampleGroup()
    }
    
    private func exampleTimer() -> Void {
    
        timer.timerIncident(1, isMainThread: true, task: { [weak self] in
            self?.count += 1
            self?.label.text = String.init(describing: (self?.count)!)
        })
        dispatch_after(20, execute: {
            self.timer.cancelTimer {
                self.label.text = "☺"
            }
        })
    }
    
    private func exampleGroup() -> Void {
    
        group.doTask {
            sleep(1)
            log.debug("1")
        }
        .doTask {
            sleep(5)
            log.debug("2")
        }
        group.doTask {
            sleep(7)
            log.debug("3")
        }
        group.finallyTask {
            log.debug("☺☺☺")
        }
    }
}
