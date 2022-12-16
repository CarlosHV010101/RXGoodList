//
//  AddTaskViewController.swift
//  GoodListView
//
//  Created by DGSA/iOS on 06/12/22.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private var taskSubject = PublishSubject<Task>()
 
    var taskObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBAction func save() {
        
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
                let title = taskTitleTextField.text else {
            return
        }
        
        let task = Task(title: title, priority: priority)
        
        taskSubject.onNext(task)
        
        self.dismiss(animated: true, completion: nil)
    }
     
}
