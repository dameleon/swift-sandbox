//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import RxSwift

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

func asyncTask() -> Observable<String> {
    let subject = PublishSubject<String>()

    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        subject.onNext("hoge")
    }
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        subject.onNext("fuga")
    }
    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
        subject.onCompleted()
    }
    return subject.asObservable()
}

func logger(_ value: Any) {
    print("\(value) at \(Date().timeIntervalSince1970)")
}

// main
let task = asyncTask()

let disposable = task.subscribe(
    onNext: { (value) in
        logger("task onNext: \(value)")
    },
    onCompleted: {
        logger("task onCompleted()")
    },
    onDisposed: {
        logger("task onDisposed()")
    })

Thread.sleep(forTimeInterval: 5)

disposable.dispose()