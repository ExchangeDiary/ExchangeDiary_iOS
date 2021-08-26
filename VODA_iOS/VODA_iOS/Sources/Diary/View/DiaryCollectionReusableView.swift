//
//  DiaryCollectionReusableView.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/15.
//

import UIKit

class DiaryCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var diaryTagView: UIView!
    @IBOutlet weak var diaryTagLabel: UILabel!
    @IBOutlet weak var diaryTitleLabel: UILabel!
    @IBOutlet weak var diaryTurnLabel: UILabel!
    @IBOutlet weak var diaryTurnDescriptionLabel: UILabel!
    @IBOutlet weak var diaryTurnView: UIView!
    @IBOutlet weak var diaryTurnDescriptionView: UIView!
    
    @IBOutlet weak var participantsCollectionView: UICollectionView!
    @IBOutlet weak var sectionView: UIView!
    
    var windowHeight = UIScreen.main.bounds.size.height
    var windowWidth = UIScreen.main.bounds.size.width
    private let participantCollectionViewCellIdentifier = "storyParticipantsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.participantsCollectionView.delegate = self
        self.participantsCollectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.diaryTagView.makeCircleView()
        self.diaryTurnView.makeCircleView()
        self.diaryTurnDescriptionView.makeCircleView()
        self.diaryTurnView.layer.borderWidth = 1
        self.diaryTurnDescriptionView.layer.borderWidth = 1
        self.diaryTurnView.layer.borderColor = UIColor.CustomColor.vodaMainBlue.cgColor
        self.diaryTurnDescriptionView.layer.borderColor = UIColor.CustomColor.vodaMainBlue.cgColor
        
        self.sectionView.makeTopSectionRound(16)
        self.sectionView.addShadow(width: 0, height: -4, radius: 8, opacity: 0.05)
    }
}

extension DiaryCollectionReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let participantCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: participantCollectionViewCellIdentifier, for: indexPath) as? StoryParticipantsCollectionViewCell {
                return participantCollectionViewCell
        }
        return UICollectionViewCell()
    }
}

extension DiaryCollectionReusableView: UICollectionViewDelegate {
    
}

extension DiaryCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: windowWidth / 12.5, bottom: 0, right: windowWidth / 12.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return windowWidth / 37.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 6.69
        let height = width
            
        return CGSize(width: width, height: height)
    }
}
