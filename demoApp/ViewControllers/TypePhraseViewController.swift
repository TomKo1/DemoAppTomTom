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
