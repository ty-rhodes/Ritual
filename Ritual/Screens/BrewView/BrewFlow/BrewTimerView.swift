//
//  BrewTimerView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 5/23/23.
//

import SwiftUI

struct BrewTimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipe, ascending: false)], animation: .default)
    private var recipes: FetchedResults<Recipe>
    
    @StateObject private var recipeViewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
    @StateObject private var timerViewModel  = BrewTimerViewModel()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let totalSeconds: TimeInterval      = 180
    private let animationDuration: TimeInterval = 180
    
    @State private var hapticFeedbackEnabled = true
    
    private var timerFormatted: String {
        let formatter                    = DateComponentsFormatter()
        formatter.allowedUnits           = [.minute, .second]
        formatter.unitsStyle             = .positional
        formatter.zeroFormattingBehavior = .dropLeading
        
        return formatter.string(from: timerViewModel.timeRemaining) ?? ""
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.brewBackground
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    Spacer()
                    // MARK: - Timer Header
                    Text("Let's Brew")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(Theme.entryAndRecipesBackground)
                        .frame(width: 340, height: 60, alignment: .leading)
                        .minimumScaleFactor(0.6)
                    // MARK: - Timer
                    brewTimer
                    // MARK: - Timer Buttons
                    HStack {
                        resetTimerButton
                        startTimerButton
                    }
                   Spacer()
                        .padding(.vertical, DeviceTypes.isiPhoneSE ? 44 : 22)
                }
                .onReceive(timer) { _ in
                    if timerViewModel.isTimerRunning {
                        if timerViewModel.timeRemaining > 0 {
                            timerViewModel.timeRemaining -= 1
                        } else {
                            timerViewModel.isTimerRunning = false
                            // Set navigation state to true
                            timerViewModel.navigateToSaveAndWrite = true
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: HomeView()) {
                        Symbols.dismiss
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbarBackground(Theme.brewBackground, for: .navigationBar)
            .background(
                NavigationLink(destination: SaveAndWriteView(),
                               isActive: $timerViewModel.navigateToSaveAndWrite,
                               label: { EmptyView() }
                              )
            )
        }
    }
}

struct BrewTimerView_Previews: PreviewProvider {
    static var previews: some View {
        BrewTimerView()
    }
}

//MARK: - Extensions
private extension BrewTimerView {
    var brewTimer: some View {
        ZStack {
            Text(timerFormatted)
                .font(.system(size: 100, weight: .light))
                .padding(.top, 10)
            
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.4)
                .foregroundColor(Theme.entryAndRecipesBackground)
            Circle()
                .trim(from: 0, to: CGFloat(timerViewModel.timeRemaining / totalSeconds))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .foregroundColor(.orange)
                .rotationEffect(Angle(degrees: -90))
                .onChange(of: timerViewModel.timeRemaining) { _ in
                    withAnimation(.linear(duration: animationDuration)) {
                        // No explicit animation code needed
                    }
                }
        }
        .frame(width: 308, height: 308)
        .foregroundColor(.white)
    }
    
    var resetTimerButton: some View {
        Button(action: {
            if hapticFeedbackEnabled {
                Haptics.lightImpact()
            }
            timerViewModel.resetTimer()
            timerViewModel.Time?.invalidate()
        }) {
            Text("Reset Timer")
        }
        .frame(width: 140, height: 20)
        .font(.system(size: 16, weight: .semibold))
        .padding()
        .background(.clear)
        .overlay( RoundedRectangle(cornerRadius: 30)
            .stroke(lineWidth: 1).foregroundColor(.white))
        .foregroundColor(.white)
        .controlSize(.large)
    }
    
    var startTimerButton: some View {
        Button(action: {
            if hapticFeedbackEnabled {
                Haptics.lightImpact()
            }
            timerViewModel.isTimerRunning.toggle()
        }) {
            Text(timerViewModel.isTimerRunning ? "Stop Timer" : "Start Timer")
                .frame(width: 140, height: 20)
                .font(.system(size: 16, weight: .semibold))
                .padding()
                .background(Theme.entryAndRecipesBackground)
                .foregroundColor(.black)
                .cornerRadius(30)
                .controlSize(.large)
        }
    }
}
