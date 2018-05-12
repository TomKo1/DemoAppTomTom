//
//  TypePhraseViewController.swift
//  demoApp
//
//  Created by Tomasz Kot on 12.05.2018.
//  Copyright © 2018 Tomasz Kot. All rights reserved.
//

import UIKit
//todo: get rid of this view controller
class TypePhraseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var queryTextIn: UITextField!
    
    /**
     *   Overwritten for segue perform
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is CategorySelectViewController){
            let categorySelectSearchViewController = segue.destination as! CategorySelectViewController
            categorySelectSearchViewController.searchQuery = self.queryTextIn?.text
        }
        
    }
    
}
