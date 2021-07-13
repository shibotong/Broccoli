//
//  CongratulationView.swift
//  Broccoli
//
//  Created by Shibo Tong on 13/7/21.
//

import SwiftUI

struct CongratulationView: View {
    var success: Bool
    
    var message: String
    @State var animation = false
    @Binding var present: Bool
    private var color: Color {
        if success {
            return Color.green
        } else {
            return Color.red
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .trim(from: 0, to: animation ? 1 : 0)
                    .stroke(color.opacity(1), lineWidth: 10)
                    .frame(width: 100, height: 100)
                    .animation(.linear(duration: 0.5))

                Circle()
                    .trim(from: 0, to: animation ? 1 : 0)
                    .stroke(color.opacity(0.5), lineWidth: 10)
                    .frame(width: 120, height: 120)
                    .animation(.linear(duration: 0.8))
                Circle()
                    .trim(from: 0, to: animation ? 1 : 0)
                    .stroke(color.opacity(0.2), lineWidth: 10)
                    .frame(width: 140, height: 140)
                    .animation(.linear(duration: 1))
                Image(systemName: success ? "checkmark" : "xmark").foregroundColor(color).font(.system(size: 50, weight: .bold, design: .rounded))
            }
            
            Text(success ? "Congratulation!" : "Ooops!").font(.system(size: 30, weight: .heavy, design: .rounded))
            Text(message)
            Button(action: { self.present.toggle() }) {
                Text("Dismiss")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(color))
            }
        }
        .padding()
        .onAppear() {
            self.animation.toggle()
        }
        
    }
}

struct CongratulationView_Previews: PreviewProvider {
    @State static var present = false
    static var previews: some View {
        CongratulationView(success: false, message: "You have already registered our beta testing", present: $present)
    }
}
