//
//  ViewController.swift
//  rippertest
//
//  Created by Kevin Gray on 7/8/16.
//  Copyright © 2016 posse. All rights reserved.
//

import UIKit
import KitUI
import Ripper
import SnapKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(hex: 0xF4F4F4)
    // Do any additional setup after loading the view, typically from a nib.
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.reloadButton)
    configureConstraints()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.reloadButton.clipsToBounds = false
    self.reloadButton.layer.masksToBounds = false
    self.reloadButton.layer.shadowColor = UIColor(hex: 0x888888).CGColor
    self.reloadButton.layer.shadowOffset = CGSizeMake(0.0, -1.0)
    self.reloadButton.layer.shadowRadius = 2.0
    self.reloadButton.layer.shadowOpacity = 1.0
  }
  
  override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    self.collectionView.reloadData()
  }
  
  // MARK: - Layout
  private func configureConstraints() {
    self.collectionView.snp_makeConstraints { (make) in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().inset(15.0)
      make.trailing.equalToSuperview()
      make.bottom.equalTo(self.reloadButton.snp_top)
    }
    
    self.reloadButton.snp_makeConstraints { (make) in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(50.0)
    }
  }
  
  
  // MARK: - Lazy initialization
  lazy var flowLayout: UICollectionViewFlowLayout = {
    var layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Vertical
    layout.minimumInteritemSpacing = 0.0
    layout.minimumLineSpacing = 0.0
    layout.sectionInset = UIEdgeInsetsZero
    return layout
  }()
  
  lazy var collectionView: UICollectionView = {
    var view = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
    view.backgroundColor = UIColor(hex: 0xF4F4F4)
    view.registerClass(SquareImageCell.self, forCellWithReuseIdentifier: SquareImageCell.reuseIdentifier())
    view.dataSource = self
    view.delegate = self
    view.contentInset = UIEdgeInsetsMake(0.0, 0.0, 15.0, 0.0)
    return view
  }()
  
  lazy var reloadButton: Button = {
    var view = Button()
    view.setBackgroundColor(color: UIColor.whiteColor(), forState: .Normal)
    view.setBackgroundColor(color: UIColor(hex: 0xD8D8D8), forState: .Highlighted)
    view.setTitle(title: "RELOAD", forState: .Normal)
    view.addTarget(self, action: #selector(self.tappedReloadButton(_:)), forControlEvents: .TouchUpInside)
    return view
  }()
  
  // MARK: - CollectionView delegates / datasource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width = floor((self.collectionView.bounds.width)/2.0)
    return CGSizeMake(width, width)
  }
  
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SquareImageCell.reuseIdentifier(),
      forIndexPath: indexPath) as! SquareImageCell
    Ripper.downloader
      .load(url: data[indexPath.row])
      .into(cell.imageView)
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
  }
  
  // MARK: - Action
  func tappedReloadButton(button: Button) {
    self.collectionView.reloadData()
  }

  // MARK: - Data
  // Left this at the bottom because it's ugly
  let data = ["http://cdn.99percentinvisible.org/wp-content/uploads/powerpress/99invisible-logo-1400.jpg",
              "https://media2.wnyc.org/i/1400/1400/l/80/1/wn16_wnycstudios_DSM_hHUuWa0.PNG",
              "http://assets.espn.go.com/i/538/logos/538_HT_1400x1400.jpg",
              "http://loveandradio.org/images/Loveandradio14002.jpg",
              "https://media.npr.org/assets/img/2015/12/18/planetmoney_sq-c7d1c6f957f3b7f701f8e1d5546695cebd523720.jpg?s=1400",
              "http://i1.sndcdn.com/avatars-000073120599-46q7im-original.jpg",
              "https://media2.wnyc.org/i/1400/1400/l/80/1/Mystery_Logo.jpg",
              "http://cdn.strangers.prx.org/wp-content/uploads/powerpress/strangers_logo_final.1400.jpg",
              "http://cdn.radiodiaries.prx.org/wp-content/uploads/powerpress/RD-Logo-yello-stripe-square-1400.jpg",
              "http://cdn.mortified.prx.org/wp-content/uploads/mortified1400.png",
              "http://panoply-prod.s3.amazonaws.com/podcasts/f23b021e-a9a3-11e5-8768-bfc7a8ea314d/image/uploads_2F1460693390594-c4dnvmodm4nv270h-2d72543670f0daa2b6c5ee2a46d2051a_2Fstartup-red.png",
              "http://www.thisamericanlife.org/sites/all/themes/thislife/images/logo-square-1400.jpg",
              "https://media.npr.org/images/podcasts/2013/primary/hourly_news_summary-c464279737c989a5fbf3049bc229152af3c36b9d.png?s=1400",
              "http://cdn.themoth.prx.org/wp-content/uploads/powerpress/moth_podcast_1400x1400.jpg",
              "https://media2.wnyc.org/i/1400/1400/l/80/1/Radiolab-wnycstudios.jpg",
              "http://cdn.millennial.prx.org/wp-content/uploads/powerpress/millennial_1800.jpg",
              "http://cdn.fugitivewaves.prx.org/wp-content/uploads/powerpress/fugitivewaves-1400.jpg",
              "http://cdn.toe.prx.org/wp-content/uploads/powerpress/BWalker_TOE_Logo_iTunes_1400px.jpg",
              "http://cms.marketplace.org/sites/default/files/marketplace_250.png",
              "http://d279m997dpfwgl.cloudfront.net/wp/2016/06/tile-modernlove.png",
              "http://static.libsyn.com/p/assets/2/4/c/0/24c0aba0214bc51b/truth_logo_7.jpg",
              "http://cdn.heart.prx.org/wp-content/uploads/powerpress/the_heart_with_logo_1400px.jpg",
              "http://cdn.allusionist.prx.org/wp-content/uploads/powerpress/allusionist_1400px.jpg",
              "http://static.libsyn.com/p/assets/d/7/5/5/d755c607c07e7ec9/songexploder-logo.png",
              "http://panoply-prod.s3.amazonaws.com/podcasts/05f71746-a825-11e5-aeb5-a7a572df575e/image/avatars-000116177580-6q9skc-original.jpg",
              "http://static.libsyn.com/p/assets/4/7/0/5/470512fde2e9a15b/Memory_Palace_Logo_RGB.jpg",
              "https://media.simplecast.com/podcast/image/1419/1444090935-artwork.jpg",
              "http://panoply-prod.s3.amazonaws.com/podcasts/3b661998-8289-11e5-b42a-0b53e7b41064/image/TheMessageShowArt1400x1400.jpg",
              "https://media.simplecast.com/podcast/image/1684/1455140618-artwork.jpg",
              "http://cdn.earwolf.com/wp-content/uploads/2011/04/HDTGMFULL.jpg",
              "http://i1.sndcdn.com/avatars-000193031993-9798hl-original.jpg",
              "http://mysteriousuniverse.org/wp-content/uploads/2012/05/MU_1400.jpg",
              "http://podcasts.howstuffworks.com/hsw/podcasts/sysk/sysk-audio-1600.jpg",
              "http://assets.espn.go.com/i/espnradio/podcast/538_WTP_1400x1400.jpg",
              "http://relayfm.s3.amazonaws.com/uploads/broadcast/image/19/material_artwork.png",
              "http://static.libsyn.com/p/assets/e/b/7/5/eb75c7e68e2c85b1/logo-new_castle.png",
              "https://ichef.bbci.co.uk/images/ic/3000x3000/p02h1m9n.jpg",
              "http://jimharold.com/wp-content/uploads/powerpress/Campfire_3000_051616_BIGGER_TEXT.jpg",
              "http://i1.sndcdn.com/avatars-000147170852-pbbmwe-original.jpg",
              "http://i1.sndcdn.com/avatars-000173950401-cgni05-original.jpg",
              "http://panoply-prod.s3.amazonaws.com/podcasts/2489e36c-2e64-11e6-860b-47d20864df19/image/Det_Pod_MF_1400x1400-2.jpg",
              "http://podcasts.sbnation.com.s3.amazonaws.com/vergecast_art.jpg",
              "http://static.libsyn.com/p/assets/6/7/9/b/679b29b5e7ffb326/ALICELOGO-1400.jpg",
              "http://i1.sndcdn.com/avatars-000185844408-2qcju9-original.jpg",
              "http://brainiak.fm/wp-content/uploads/2016/02/Geek_Fit_Showart.png",
              "https://serialpodcast.org/sites/all/modules/custom/serial/img/serial-itunes-logo.png",
              "http://uhhyeahdude.com/images/UYD_CMY-640.png",
              "http://static.libsyn.com/p/assets/6/b/b/9/6bb9b7b978912d69/Criminal_iTunes_Logo_1400.jpg",
              "http://static.libsyn.com/p/assets/3/c/4/5/3c45b257669e76d7/nerdistlogo.jpg",
              "http://static.libsyn.com/p/assets/9/a/0/4/9a0410edb2668a67/lore-coverart2.jpg",
              "http://www.blogtalkradio.com/api/image/resize/1400x1400/aHR0cDovL2NkbjIuYnRyc3RhdGljLmNvbS9waWNzL2hvc3RwaWNzLzA3YTZlNTMwLWQ0NWItNDIwNy04OTRkLTA5NjRlNGYzMzU0Yl9hbWhfYm9va19jb3Zlcl9sYXJnZS5qcGc/07a6e530-d45b-4207-894d-0964e4f3354b_amh_book_cover_large.jpg",
              "http://panoply-prod.s3.amazonaws.com/podcasts/f521b120-2c30-11e6-b5f3-63ee984ee1a4/image/uploads_2F1467744818655-zt4no0n9of-27a30985cf4d98dce8a6bc6a0e6b3200_2F1-iTUNES-Show-icon_3000x3000.jpg",
              "http://static.libsyn.com/p/assets/c/7/8/c/c78c303f34f8a36f/realghoststorieslogonew.jpg",
              "http://static.libsyn.com/p/assets/d/5/3/b/d53b7d1fc184b1e3/nightvalelogo-web4.jpg",
              "http://static.libsyn.com/p/assets/e/7/3/7/e737e69f5c54319e/Optimized_iTunes_Cover.jpg",
              "http://www.dancarlin.com/graphics/DC_HH_iTunes.jpg",
              "http://www.thebritishhistorypodcast.com/logo.jpg",
              ]
}

