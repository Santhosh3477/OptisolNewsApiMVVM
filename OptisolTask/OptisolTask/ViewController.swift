//
//  ViewController.swift
//  OptisolTask
//
//  Created by Santhosh on 12/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // News View model instance
    var newsViewModel = NewsViewModel()
    
    // News content listing table view
    @IBOutlet var newsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        // Load the first page initially
        newsViewModel.loadRequest(pageNumber: 0) { (result, error) in
            DispatchQueue.main.async {
                self.newsListTableView.reloadData()
            }
        }
    }
}

// MARK: Tableview datasource and delegate methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.newsListArray.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell") as! CustomTableViewCell
        if (newsViewModel.newsListArray.count > indexPath.row) {
            cell.configure(with: newsViewModel.newsList(at: indexPath.row))
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(sender:)))
            let tapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
            cell.contentView.tag = indexPath.row
            cell.contentView.addGestureRecognizer(longPressRecognizer)
            cell.contentView.addGestureRecognizer(tapPressRecognizer)
        } else {
            cell.configure(with: .none)
                newsViewModel.loadRequest(pageNumber: indexPath.row + 1) { (result, error) in
                DispatchQueue.main.async {
                    self.newsListTableView.reloadData()
                }
            }
        }
        return cell

    }
    
    
}

// MARK: Cell gesture methods
extension ViewController {
    
    // Long press gesture method to copy the pressed image to clipboard
    @objc func cellLongPressed(sender : UILongPressGestureRecognizer) {
        let indexPath: NSIndexPath = NSIndexPath(row: sender.view!.tag, section: 0)
        let cell = newsListTableView.cellForRow(at: indexPath as IndexPath) as? CustomTableViewCell
        // Copy image to clipboard
        UIPasteboard.general.image = cell?.previewImage.image
        let alert = UIAlertController(title: "Alert", message: "Image copied to clipboard", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Tap press gesture method to preview the pressed image in next controller
    @objc func cellTapped(sender : UITapGestureRecognizer) {
        let indexPath: NSIndexPath = NSIndexPath(row: sender.view!.tag, section: 0)
        let cell = newsListTableView.cellForRow(at: indexPath as IndexPath) as? CustomTableViewCell
        let vc : PreviewViewController = self.storyboard!.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        vc.image = cell?.previewImage.image
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}
