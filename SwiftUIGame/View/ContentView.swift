//
//  ContentView.swift
//  SwiftUIGame
//
//  Created by Nileshkumar M. Prajapati on 2023/04/20.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var showingInfoView: Bool = false
    @State private var reels: [Int] = [0, 1, 2]
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betValue: Int = 10
    @State private var isGameOver: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModel: Bool = false

    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let haptic = UINotificationFeedbackGenerator()
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            //MARK: Background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            //MARK: Interface
            VStack(alignment: .center, spacing: 5) {
                
                //MARK: Header
                LogoView()
                Spacer()
                
                //MARK: Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                //MARK: Slot Machine
                
                VStack(alignment: .center, spacing: 0) {
                    //MARK: Reel#1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeInOut(duration: Double.random(in: 0.5...0.7)), value: animatingSymbol)
                            .onAppear {
                                self.animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        //MARK: Reel#2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeInOut(duration: Double.random(in: 0.7...0.9)), value: animatingSymbol)
                                .onAppear {
                                    self.animatingSymbol.toggle()
                                }
                        }
                        
                        Spacer()
                        
                        //MARK: Reel#3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeInOut(duration: Double.random(in: 0.9...1.1)), value: animatingSymbol)
                                .onAppear {
                                    self.animatingSymbol.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    //MARK: Spin Button
                    Button {
                        //1. Set Defaut State: NO animation
                        withAnimation {
                            self.animatingSymbol = false
                        }

                        //2. SPIN the REELS with changing the symbols
                        self.spinReels()
                        
                        //3. Trigger the animation after changing the symbols
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        
                        //4. Check Winning
                        self.checWinning()
                        
                        //5. Game Over
                        self.checkIfGameOver()
                    } label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                    
                } //Slot Machine
                .layoutPriority(2)
                
                Spacer()
                
                //MARK: Footer
                
                HStack {
                    //MARK: BET 20
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            self.activateBet20()
                        } label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(betValue == 20 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: betValue == 20 ? 0 : 20)
                            .opacity(betValue == 20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    Spacer()
                    
                    //MARK: BET 10
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: betValue == 10 ? 0 : -20)
                            .opacity(betValue == 10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button {
                            self.activateBet10()
                        } label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(betValue == 10 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                } //Footer
            }
            //MARK: Buttons
            .overlay(
                //Reset
                Button(action: {
                    //Game Resetting
                    self.resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                //Info
                Button(action: {
                    print("Info View")
                    self.showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $isGameOver.wrappedValue ? 5 : 0, opaque: false)
            
            //MARK: Popup
            if $isGameOver.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .edgesIgnoringSafeArea(.all)

                    PopupView(isGameOver: $isGameOver)
                }
            }
            
        } //ZStack
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

//MARK: - Private Functions

private extension ContentView {
    //1. SPIN the REELS
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptic.notificationOccurred(.success)
    }
    
    //2. Check the winning
    func checWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            //1. Player Wins
            addCoinsWhenPlayerWins()
            
            //2. Set New High Score
            guard coins > highScore else {
                playSound(sound: "win", type: "mp3")
                return
            }
            setNwwHighScore()
        } else {
            //1. Player loses
            deductCoinsWhenPlayerLoses()
        }
    }
    
    //3. Player Wins
    func addCoinsWhenPlayerWins() {
        coins += betValue * 10
    }
    
    //4. Set New High Score
    func setNwwHighScore() {
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    //5. Player loses
    func deductCoinsWhenPlayerLoses() {
        coins -= betValue
    }
    
    //6. Gamne Over
    func checkIfGameOver() {
        isGameOver = coins <= 0
        guard isGameOver else { return }
        coins = 100
        self.activateBet10()
        playSound(sound: "game-over", type: "mp3")
    }
    
    //7. Activate Bets
    func activateBet20() {
        betValue = 20
        playSound(sound: "casino-chips", type: "mp3")
        haptic.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betValue = 10
        playSound(sound: "casino-chips", type: "mp3")
        haptic.notificationOccurred(.success)
    }
    
    //8. Reset Game
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
