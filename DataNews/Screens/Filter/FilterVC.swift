//
//  FilterVC.swift
//  DataNews
//
//  Created by Yaroslav on 1/5/21.
//

import UIKit

protocol FilterVCDelegate: class {
    func reloadContent()
}

class FilterVC: UIViewController {
    
    //MARK: - Constants
    
    private let rightBarButtonTitle = "Done"
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    private var viewModel: FilterViewModel?
    weak var delegate: FilterVCDelegate?
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRightButtonToNavigationBar()
        viewModel?.retriveFilterOptions()
    }
    
    //MARK: - Private methods
    
    private func addRightButtonToNavigationBar() {
        let button1 = UIBarButtonItem(title: rightBarButtonTitle, style: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @objc private func doneButtonPressed() {
        self.delegate?.reloadContent()
        dismiss(animated: true)
    }

    
    //MARK: - Public methods
    
    func setup(viewModel: FilterViewModel) {
        self.viewModel = viewModel
    }
}

//MARK: - UITableViewDataSource

extension FilterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numbersOfRows())!
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")

        cell.textLabel?.text = viewModel!.textForCell(at: indexPath.row)
        
        if ((viewModel!.checkIfCellSelected(by: indexPath.row))) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension FilterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            viewModel?.saveFilterOption(by: indexPath.row)
        }
        
        self.tableView.reloadData()
    }
}
