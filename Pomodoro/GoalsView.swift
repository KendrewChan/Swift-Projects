//
//  GoalsView.swift
//  Pomodoro
//
//  Created by Kendrew Chan on 20/10/17.
//  Copyright © 2017 testtest. All rights reserved.
//

import UIKit

class GoalsView: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var VCArr: [UIViewController] = {
        return [self.VCInstance(name:"FirstVC"),
                self.VCInstance(name:"SecondVC")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    
    //swiping backwards
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
                return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { //array starts from 0 to 1,2,3 ...
            return VCArr.last //to ensure loops between swiping function, to ensure page swiped to is the same as before
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        } //avoid crashes if array goes out of bounds
        
        return VCArr[previousIndex]
    }
   
    
    //swiping forward
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex >= 0 else { //array starts from 0 to 1,2,3 ...
            return VCArr.first //to ensure loops between swiping function, to ensure page swiped to is the same as before
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        } //avoid crashes if array goes out of bounds
        
        return VCArr[nextIndex]
    }
    
    /*
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }// The number of items reflected in the page indicator.
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArr.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }// The selected item reflected in the page indicator.
  */
    
}
