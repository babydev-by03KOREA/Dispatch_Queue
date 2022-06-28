
import UIKit

// dispatch queue - thread (동시성 프로그래밍) 효율성 극대화!
// 노동자 = Thread / 일 = Task
// 분산처리 queue A.K.A 대기행렬!
class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var finishLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.timerLabel.text = Date().timeIntervalSince1970.description
        }
    }

    @IBAction func action1(_ sender: Any) {
//      레이블의 값의 변화
//      finishLabel.text = "The End"
//      실행 하려는곳에 클로저 작성
        simpleClosure {
//          UILabel.text must be used from main thread only
            self.finishLabel.text = "Closure The End"
        }
    }
    
    func simpleClosure(completion: @escaping () -> Void) {
        
        DispatchQueue.global().async {
//      DispatchQueue - 큐에 보내다
//      global dispatch queue에 비동기로 task를 보낸다.
//      { Task - 작업의 한 단위  }
        for index in 0..<10 {
            Thread.sleep(forTimeInterval: 0.2)
//          Main Thread가 0.2초씩 중단된다. -> 콘솔에 0~10 찍히고 출력
            print(index)
        }
        
            DispatchQueue.main.async {
//              main Thread에서 작동하게 해주세요.
                completion()
            }
        }
    }
    @IBAction func action2(_ sender: Any) {
        
        let dispatchGroup = DispatchGroup()
//      작업할 Threads - 전혀 상관없는 작업자 3개 생성
        let queue1 = DispatchQueue(label: "queue1")
        let queue2 = DispatchQueue(label: "queue2")
        let queue3 = DispatchQueue(label: "queue3")
        
        queue1.async(group: dispatchGroup, qos: .background) {
//      DispatchQueue.global().async - 작업자를 하나 더 만들면, 안에 있는     내용은 무시하고 다음 로직을 실행시킨다. / 수동관리
            dispatchGroup.enter()
            DispatchQueue.global().async {
                for index in 0..<10 {
                    Thread.sleep(forTimeInterval: 0.2)
        //  Main Thread가 0.2초씩 중단된다. -> 콘솔에 0~10 찍히고 출력
                    print(index)
                }
                dispatchGroup.leave()
//              작업이 끝남을 통지
//            }
        }
        
            queue2.async(group: dispatchGroup, qos: .userInteractive) {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                for index in 10..<20 {
                    Thread.sleep(forTimeInterval: 0.2)
        //          Main Thread가 0.2초씩 중단된다. -> 콘솔에 0~10 찍히고 출력
                    print(index)
                }
            }
            dispatchGroup.leave()
        }
        
        queue3.async(group: dispatchGroup) {
            dispatchGroup.enter()
            DispatchQueue.global().async {
//  원래의 작업이 진행되고 있던 메인 스레드에서 global dispatch queue로 task를 보낸 후, 해당 작업이 끝나기를 기다리지 않고 이어서 할 일을 한다!
                for index in 20..<30 {
                    Thread.sleep(forTimeInterval: 0.2)
        //          Main Thread가 0.2초씩 중단된다. -> 콘솔에 0~10 찍히고 출력
                    print(index)
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
//      DispatchQueue -> Main Thread에서 작동되도록 함.
            print("End Main Thread")
        }

    }
    }
    
    @IBAction func action3(_ sender: Any) {
            
    //        DispatchQueue.main.sync {
    //      DispatchQueue: 동시성 프로그래밍을 돕기위해 제공하는 Queue
    //      global: DispatchQueue의 종류
    //      sync: 동기(꼭 필요) / async: 비동기(AJAX)
    //            print("main sync")
    //        }
            
    //      Thread 생성
            let queue1 = DispatchQueue(label: "queue1")
            let queue2 = DispatchQueue(label: "queue2")
            
    //      sync - 락이걸려버림 / 내 Thread가 작업이 끝날때까지 아무것도 사용불가.
    //     다른작업을 막아서까지 꼭 해야만 하는 작업이라면 sync를 사용 할 수 있다.
            queue1.sync {
                for index in 10..<20 {
                    Thread.sleep(forTimeInterval: 0.2)
            //      Main Thread가 0.2초씩 중단된다. -> 콘솔에 0~10 찍히고 출력
                    print(index)
                }
            }
    //      queue1으로 변경 -> Deadlock 발생
    //            queue1.sync {
    //                for index in 20..<30 {
    //                    Thread.sleep(forTimeInterval: 0.2)
    //                    print(index)
    //                }
    //            }
            
            queue2.sync {
                for index in 30..<40 {
                    Thread.sleep(forTimeInterval: 0.2)
                //  Main Thread가 0.2초씩 중단된다. -> 콘솔에 0~10 찍히고 출력
                    print(index)
                }
            }
        }
}
