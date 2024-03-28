//
//  AudioPlayer.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 10.02.24.
//

import AVFoundation

/// All sounds needed for the app
enum Sound: String, CaseIterable {
    case success
    case error
    case click
    case floppy
    case keyboard
    case pinDelete
    case pinPress
    case completed
}


/// Handles audio playback
class AudioPlayer {
    
    public static var sharedInstance = AudioPlayer()
    private init() {
        
        setAudioLevel()
        
        // prepare audio
        for sound in Sound.allCases {
            playSound(sound: sound, prepare: true)
        }
    }
    
    /// Array to keep players in cache
    private var players: [URL: AVAudioPlayer] = [:]
    private var duplicatePlayers: [AVAudioPlayer] = []
    
    /// Responsible to schedule audio files
    fileprivate let soundSchedulingQueue = DispatchQueue(label: "soundSchedulingQueue", qos: .userInitiated)
    
    
    /// Plays the specified sound, may overlap.
    func playSound(sound: Sound, prepare: Bool = false) {
        
        soundSchedulingQueue.asyncAfter(deadline: .now()) { [self] in
            
            let soundURL = getSoundFileURL(soundFileName: sound.rawValue)
            
            // Player exists
            if let player = players[soundURL] {
                
                // Check idle player
                if !player.isPlaying {
                    
                    if(!prepare) {
                        player.play()
                    }
                    else {
                        player.prepareToPlay()
                    }
                    
                }
                else {
                    // Create new player
                    do {
                        let duplicatePlayer = try AVAudioPlayer(contentsOf: soundURL)
                        duplicatePlayers.append(duplicatePlayer)
                        
                        if(!prepare) {
                            duplicatePlayer.play()
                        }
                        else {
                            player.prepareToPlay()
                        }
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            else {
                // Create initial
                do {
                    let player = try AVAudioPlayer(contentsOf: soundURL)
                    players[soundURL] = player
                    
                    if(!prepare) {
                        player.play()
                    }
                    else {
                        player.prepareToPlay()
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    /// Returns the sound URL for mp3 files
    private func getSoundFileURL(soundFileName: String) -> URL {
        
        let path = Bundle.main.path(forResource: soundFileName, ofType: "mp3")!
        let soundURL = URL(fileURLWithPath: path)
        
        return soundURL
    }
    
    
    /// Sets the audio level to playback
    private func setAudioLevel() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
}
