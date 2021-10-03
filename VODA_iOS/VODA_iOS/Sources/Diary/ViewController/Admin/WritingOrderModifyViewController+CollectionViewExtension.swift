//
//  WritingOrderModifyViewController+CollectionViewExtension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/21.
//

import Foundation
import UIKit

extension WritingOrderModifyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let writingOrderModifyCell = collectionView.dequeueReusableCell(withReuseIdentifier: writingOrderModifyCellIdentifier, for: indexPath) as? WritingOrderModifyCell {
            writingOrderModifyCell.nameLabel.text = participants[indexPath.row]
            return writingOrderModifyCell
        }
        return UICollectionViewCell()
    }
}

extension WritingOrderModifyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = participants.remove(at: sourceIndexPath.item)
        participants.insert(item, at: destinationIndexPath.item)
    }
}

extension WritingOrderModifyViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = participants[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
}

extension WritingOrderModifyViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        coordinator.items.forEach { dropItem in
            guard let sourceIndexPath = dropItem.sourceIndexPath else { return }
            self.reorderItems(coordinator: coordinator, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath, dropItem: dropItem, collectionView: collectionView)
        }
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, dropItem: UICollectionViewDropItem, collectionView: UICollectionView) {
        collectionView.performBatchUpdates({
            participants.remove(at: sourceIndexPath.item)
                
            if let itemLocalObject = dropItem.dragItem.localObject as? String {
                participants.insert(itemLocalObject, at: destinationIndexPath.item)
            }
                
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
        }, completion: { _ in
            coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
        })
    }
}

extension WritingOrderModifyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: DeviceInfo.screenHeight / 22.5, left: collectionView.frame.width / 23.4, bottom: DeviceInfo.screenHeight / 22.5, right: collectionView.frame.width / 23.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height / 10.2
            
        return CGSize(width: width, height: height)
    }
}
