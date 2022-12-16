//
//  TaskListViewController.swift
//  GoodListView
//
//  Created by DGSA/iOS on 06/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay(value: [Task]())
    private var filteredTasks = [Task]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        
        filterTask(by: priority)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navigationController = segue.destination as? UINavigationController, let addTaskViewController = navigationController.viewControllers.first as? AddTaskViewController else {
            fatalError("Controller not found")
        }
        
        addTaskViewController.taskObservable
            .subscribe { [unowned self] task in
            
                let priority = Priority(
                    rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1
                )
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                
                self.filterTask(by: priority)
            
            }
            .disposed(by: disposeBag)
    }
    
    private func filterTask(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority!  }
            }.subscribe { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
            }.disposed(by: disposeBag)
        }
        
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        
        return cell
    }
}
