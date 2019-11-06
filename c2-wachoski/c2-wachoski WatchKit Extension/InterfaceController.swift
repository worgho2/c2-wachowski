import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    //crown variables
    var canResetZoom: Bool = false
    var crownAccumulator = 0.0
    var zoom : Int = 1
    var firstLoginDate = DateComponents()
    var Energy = EnergyBurned()
    var Stand = StandTime()
    var Exercise = ExerciseTime()
    var CurrentResources = Resources()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
        
        //Verifica se o app tem autorização para utilizar os dados do HealthKit
        if !HKHealthStore.isHealthDataAvailable(){
            return
        }
        //Chama a função que pede autorização.
        authorizeHealthKit()
        firstLoginDate = setFirstLoginDate()
        UpdateSumOfRingValues()
        
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        self.canResetZoom = false
        
        crownAccumulator += rotationalDelta
        
        if abs(crownAccumulator) > 0.05 {
            zoom = max(0, Int(sign(crownAccumulator)) + zoom)
            let scale : CGFloat = CGFloat(abs(zoom)) * 0.1 + 1
//            Desconmentar quando adicionar a scene
//            self.scene.scene?.camera?.xScale = scale
//            self.scene.scene?.camera?.yScale = scale
            
            crownAccumulator = 0
        }
        
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        self.canResetZoom = true
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            if self.canResetZoom {
//                Desconmentar quando adicionar a scene
//                self.scene.scene?.camera?.run(.scale(to: 1.0, duration: 0.3))
                self.crownAccumulator = 0
                self.zoom = 0
            }
        }
    }

//    @IBAction func botaoTeste() {
//        print("botão")
//    }
    
    //Autorização para o app utilizar os dados do dispositivo
    private func authorizeHealthKit() {
          HealthKitSetup.authorizeHealthKit { (authorized, error) in
            guard authorized else {
              let baseMessage = "HealthKit Authorization Failed"
              if let error = error {
                print("\(baseMessage). Reason: \(error.localizedDescription)")
              } else {
                print(baseMessage)
              }
              return
            }
            print("HealthKit Successfully Authorized.")
          }
        }
    
    
    //Retorna a data do último login em formato DateComponents para
    private func setFirstLoginDate() -> DateComponents{
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone(identifier: "UTC")!

        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        todayComponents.calendar = calendar
        
        return todayComponents
    }
    
    private func UpdateSumOfRingValues(){
        
        //Retorna, para cada recurso, a soma de todos os dados da Ring do usuário, desde
        //o ultimo login.
        Energy = HealthKitData.getMostRecentEnergySample(initialDate: firstLoginDate)
        Stand = HealthKitData.getMostRecentStandSample(initialDate: firstLoginDate)
        Exercise = HealthKitData.getMostRecentExerciseSample(initialDate: firstLoginDate)
        updateAccumulatedData()
    }
    
    private func updateAccumulatedData(){
        
        //Atualiza os recursos disponível para o usuário utilizar
        CurrentResources.energyBurned += Energy.currentValue - Energy.accumulated
        CurrentResources.standTime += Stand.currentValue - Stand.accumulated
        CurrentResources.exerciseTime += Exercise.currentValue - Exercise.accumulated
        
        //Registra a quantidade de recursos acumulado pelo usuário desde o primeiro login
        //para manter a lógica top que eu usei.
        Energy.accumulated = Energy.currentValue - Energy.accumulated
        Stand.accumulated = Stand.currentValue - Stand.accumulated
        Exercise.accumulated = Exercise.currentValue - Exercise.accumulated
    }
}
