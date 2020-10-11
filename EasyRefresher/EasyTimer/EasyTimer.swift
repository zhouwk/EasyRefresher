//
//  EasyTimer.swift
//  EasyTimer
//
//  Created by 周伟克 on 2020/10/5.
//

import Foundation
typealias EasyTimerTask = () -> ()

class EasyTimer {
    
    private let timer: Timer
    private let target: EasyTimerTarget
    
    private init(timer: Timer, target: EasyTimerTarget) {
        self.timer = timer
        self.target = target
    }

    static func set(fireDate date: Date = Date(),
                    interval ti: TimeInterval,
                    repeats rep: Bool = true,
                    task t: @escaping EasyTimerTask) -> EasyTimer {
        let target =  EasyTimerTarget(t)
        let timer = Timer(fireAt: date,
                          interval: ti,
                          target: target,
                          selector: #selector(target.execute),
                          userInfo: nil,
                          repeats: rep)
        RunLoop.current.add(timer, forMode: .common)
        return EasyTimer(timer: timer, target: target)
    }
    
    
    deinit {
        timer.invalidate()
    }
    
    func pause() {
        timer.fireDate = .distantFuture
    }
    
    func resume() {
        timer.fireDate = .init()
    }
}

class EasyTimerTarget {
    var task: EasyTimerTask
    init(_ task: @escaping EasyTimerTask) {
        self.task = task
    }
    
    @objc func execute() {
        task()
    }
}
