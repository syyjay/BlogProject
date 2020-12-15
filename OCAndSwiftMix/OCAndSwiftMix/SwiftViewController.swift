//
//  SwiftViewController.swift
//  OCAndSwiftMix
//
//  Created by nathan on 2020/12/14.
//

import UIKit

class SwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let ocVC:ViewController = ViewController.init()
        ocVC.swiftUseOC()
        // Do any additional setup after loading the view.
    }
    

   @objc func ocUserSwift()  {
        print("ocUserSwift")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
