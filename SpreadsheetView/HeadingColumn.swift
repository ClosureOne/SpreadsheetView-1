//
//  HeadingColumn.swift
//  SpreadsheetView
//
//  Created by ByteSlinger on 2017-08-10.
//  Copyright © 2017 ByteSlinger. All rights reserved.
//

import UIKit

let HEADING_COLUMN_ID = "HeadingColumn"

class HeadingColumn: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var spreadsheetView: SpreadsheetView!

    let reuseIdentifier = HEADING_COLUMN_ID
    
    private var isScrolling = false             // semaphore to prevent infinite scroll loops
    
    override func awakeFromNib() {
        //print("HeadingColumn.awakeFromNib()")
        
        super.awakeFromNib()
        
        // so we don't have to bother setting them in the storyboard
        self.dataSource = self
        self.delegate = self
        
        self.isScrollEnabled = false        // allow TableView to handle scrolling
        self.allowsMultipleSelection = true
        
        // turn off all bouncing so scrolling/syncing works properly
        self.bounces = false
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
    }
    
    // sync the heading row with the passed contentOffset
    func scrollTo(_ offset: CGPoint) {
        if (self.isScrolling == false) {
            self.isScrolling = true
            
            if (offset.y != self.contentOffset.y) {
                self.contentOffset.y = offset.y
            }
            
            self.reloadData()
            
            self.isScrolling = false
        }
    }
    
    // scroll the CollectionView to the passed item (row)
    func scrollToCell(_ item: Int) {
        let indexPath = IndexPath(item: item, section: 0)
        
        self.scrollToItem(at: indexPath, at: .top, animated: false)
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.spreadsheetView.numDataRows()
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let tableCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TableCell
        
        return tableCell
    }
    
    // setup the cell accordingly
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let tableCell = cell as! TableCell
        let row = collectionView.tag
        let col = indexPath.row
        
        let value = self.spreadsheetView.getRowHeading(row: indexPath.row)
        
        tableCell.setup(row: row, col: col, value: value,  heading: true, selected: false, adjustWidth: false)
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.spreadsheetView.setRowSelected(row: indexPath.row, selected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.spreadsheetView.setRowSelected(row: indexPath.row, selected: false)
    }
}
