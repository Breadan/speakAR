//
//  SongLoader.swift
//  Clean SpeakAR Code
//
//  Created by Brendan Yang on 1/21/21.
//

import Foundation

func loadSongList() -> [String:Song] {
    let FM = FileManager.default
    var songList = Dictionary<String,Song>()
    if let resourcesPath = try? FM.contentsOfDirectory(atPath: Bundle.main.bundlePath) {
        for songURL in resourcesPath where songURL.hasSuffix("mp3") {
            print("DEBUG: Found song resource \(songURL)")
            songList[songURL] = Song(URL: songURL)
        }
        return songList
    } else {
        print("DEBUG: Resource path not found!")
        return [:]
    }
}



func initializeSongs(of songURLs: [String] = [], from songList: Dictionary<String,Song>, all allSongs: Bool = true) -> Void {
    print("DEBUG: Requested a total of \(allSongs ? songList.count : songURLs.count) songs")
    for song in songList.values where songURLs.contains(song.songURL) || allSongs {
        print("DEBUG: Requesting song resource from \(song.songURL)...")
        song.requestSong(songURL: song.songURL)
    }
}


func deinitializeSongs(of songURLs: [String] = [], from songList: Dictionary<String,Song>, all allSongs: Bool = true) -> Void {
    print("DEBUG: Deinitializing a total of \(allSongs ? songList.count : songURLs.count) songs")
    for song in songList.values where songURLs.contains(song.songURL) || allSongs {
        print("DEBUG: Deinitializing song resource from \(song.songURL)...")
        song.songResource = nil
    }
}


func getLoadedSongs(from songs: [String:Song]) -> [Song] {
    var tempLoadedSongs = [Song]()
    for song in songs.values where song.songResource != nil {
        tempLoadedSongs.append(song)
    }
    return tempLoadedSongs
}

func getLoadedSongURLs(from songs: [String:Song]) -> [String] {
    var tempLoadedSongURLs = [String]()
    for song in songs.values where song.songResource != nil {
        tempLoadedSongURLs.append(song.songURL)
    }
    return tempLoadedSongURLs
}


