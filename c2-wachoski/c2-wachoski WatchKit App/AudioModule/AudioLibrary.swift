import AVFoundation

enum SongLibrary : String, CaseIterable {
    case test = "click-synth.mp3"
    case test2 = "click-double.mp3"
}

enum IntroWithLoopLibrary: CaseIterable {
    case test
    
    var info : (intro: String, loop: String) {
        switch self {
        case .test:
            return ("click-synth.mp3", "click-double.mp3")
        }
    }
}

enum SoundEffectLibrary : String, CaseIterable {
    case alert_1 = "alert_1.wav"
    case alert_2 = "alert_2.wav"
    case confirmation_1 = "confirmation_1.wav"
    case confirmation_2 = "confirmation_2.wav"
    case confirmation_3 = "confirmation_3.wav"
    case fertilizer = "fertilizer.wav"
    case growing_1 = "growing_1.wav"
    case growing_2 = "growing_2.wav"
    case growing_3 = "growing_3.wav"
    case planting = "planting.wav"
    case sun_1 = "sun_1.wav"
    case sun_2 = "sun_2.wav"
    case sun_3 = "sun_3.wav"
    case water = "water.wav"
}
