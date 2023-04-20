//
//  PlaySound.swift
//  SwiftUIGame
//
//  Created by Nileshkumar M. Prajapati on 2023/04/20.
//

import AVFoundation
var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    guard let path = Bundle.main.path(forResource: sound, ofType: type) else { return }
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: path))
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    } catch {
        print("Play sound failure due to \(error.localizedDescription)")
    }
}
