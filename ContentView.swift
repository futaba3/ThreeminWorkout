import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var viewDidLoad = false
    @EnvironmentObject var timerController: TimerModel
    @State var contentTimer: Timer?
    @State var contentTimerCount = 180
    @State var popupText = ""
    @State private var workoutContentText = "10seconds later,\n stomp on the spot for 20 seconds."
    @State var workoutContentTextArray: [String] = ["10seconds later,\n stomp on the spot for 20 seconds.", "Stomp on the spot for 20 seconds!!", "10seconds later,\n move your arms up and down.", "Move your arms up and down!", "10seconds later,\n high knees run in place.", "High knees run in place!!", "10seconds later,\n raise your arms and squat in place.", "Raise your arms and squat in place!!", "10seconds later,\n raise your arms and stretch", "Raise your arms and stretch!!", "10seconds later,\n shake your iPhone a lot!", "Shake your iPhone a lot!!"]
    @State var shakeCount = 0
    @State var imageName = "stomp"
    
    var body: some View {
        ZStack {
            Image("backGroundImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack {
                Text("Let's work out for 3 minutes!")
                    .preferredColorScheme(.light)
                    .font(.title)
                    .padding(.top, 40.0)
                Text(timerController.intToStringCount())
                    .font(.system(size: 100, weight: .bold, design: .default))
                Spacer()
            }
            .overlay {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text(popupText)
                .foregroundColor(.orange)
                .font(.system(size: 200, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .center)
                .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                    self.shakeCount += 1
                    print(shakeCount)
                }
            VStack {
                Spacer()
                Text(workoutContentText)
                    .font(.title)
                    .padding(.bottom, 50.0)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            print("onAppear")
            if viewDidLoad == false {
                // 3
                viewDidLoad = true
                // 4
                // Perform any viewDidLoad logic here.
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
                } catch {
                    print("error")
                }
                if timerController.timer == nil {
                    timerController.startTimer(1.0)
                    speak(workoutContentText)
                }else{
                    timerController.resetTimer()
                }
                print("viewDidLoad")
                
                contentTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    self
                        .contentTimerCount -= 1
                    switch contentTimerCount {
                    case 173, 143, 113, 83, 53, 23:
                        popupText = "3"
                        speak(popupText)
                        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                        feedbackGenerator.impactOccurred()
                    case 172, 142, 112, 82, 52, 22:
                        popupText = "2"
                        speak(popupText)
                        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                        feedbackGenerator.impactOccurred()
                    case 171, 141, 111, 81, 51, 21:
                        popupText = "1"
                        speak(popupText)
                        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                        feedbackGenerator.impactOccurred()
                    case 180, 148, 118, 88, 58, 28:
                        speak(workoutContentText)
                    case 170, 140, 110, 80, 50, 20:
                        speak("go")
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    case 150, 120, 90, 60, 30:
                        speak("finish")
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        //                    case (151...180) where contentTimerCount % 2 == 0:
                        //                        imageName = "stomp1"
                        //                    case 151...180:
                        //                        imageName = "stomp2"
                    case 171...180:
                        imageName = "stomp"
                        workoutContentText = workoutContentTextArray[0]
                    case 151...170:
                        imageName = "stomp"
                        popupText = "GO"
                        workoutContentText = workoutContentTextArray[1]
                    case 141...150:
                        imageName = "moveArm"
                        popupText = ""
                        workoutContentText = workoutContentTextArray[2]
                    case 121...140:
                        imageName = "moveArm"
                        popupText = "GO"
                        workoutContentText = workoutContentTextArray[3]
                    case 111...120:
                        imageName = "highKnees"
                        popupText = ""
                        workoutContentText = workoutContentTextArray[4]
                    case 90...110:
                        imageName = "highKnees"
                        popupText = "GO"
                        workoutContentText = workoutContentTextArray[5]
                    case 81...90:
                        imageName = "squat"
                        popupText = ""
                        workoutContentText = workoutContentTextArray[6]
                    case 60...80:
                        imageName = "squat"
                        popupText = "GO"
                        workoutContentText = workoutContentTextArray[7]
                    case 51...60:
                        imageName = "stretch"
                        popupText = ""
                        workoutContentText = workoutContentTextArray[8]
                    case 30...50:
                        imageName = "stretch"
                        popupText = "GO"
                        workoutContentText = workoutContentTextArray[9]
                    case 21...30:
                        popupText = ""
                        workoutContentText = workoutContentTextArray[10]
                    case 21:
                        shakeCount = 0
                    case 0:
                        workoutContentText = "Let's eat noodles!!"
                        speak(workoutContentText)
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    case 0...20:
                        imageName = ""
                        popupText = String(shakeCount)
                        workoutContentText = workoutContentTextArray[11]
                    default:
                        break
                    }
                    
                }
            }
        }
    }
    
    let synthesizer = AVSpeechSynthesizer()
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
}

extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("DeviceDidShakeNotification")
}
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}
