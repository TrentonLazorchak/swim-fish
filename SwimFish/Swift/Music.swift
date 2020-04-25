//
//  Music.swift
//  SwimFish
//
//  Created by Trenton Lazorchak on 9/27/19.
//  Copyright © 2019 Trenton Lazorchak. All rights reserved.
//

import UIKit
import AVFoundation
var player : AVAudioPlayer?

class MusicPlayer {
    
    
    // associates the music player with the theme music
    func prepareMusic() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        guard let path = Bundle.main.path(forResource: "theme", ofType: "m4a") else {
            return
        }
        let fileURL = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
        } catch let ex {
            print(ex.localizedDescription)
        }
        player?.numberOfLoops = -1
        player?.prepareToPlay()
    }
    
    func playMusic() {
        prepareMusic()
        player?.volume = 0.7
        player?.play()
    }
    
    func pauseMusic() {
        player?.pause()
    }
    
    func resumeMusic() {
        player?.play()
    }
}
