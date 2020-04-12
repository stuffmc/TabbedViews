//
//  ContentView.swift
//  TabbedViews
//
//  Created by StuFF mc on 10.04.20.
//  Copyright © 2020 Manuel @StuFFmc Carrasco Molina. All rights reserved.
//

import SwiftUI

extension View {
    func onHover2(perform action: @escaping (Bool) -> Void) -> some View {
        return self.overlay(HoverRecognizer(action: action))
    }
}

public struct HoverRecognizer: UIViewRepresentable {

    var action: (Bool) -> Void

    public func makeUIView(context: Context) -> UIView {
        return HoverView(action)
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
    }

    private class HoverView: UIView {
        var action: (Bool) -> Void

        init(_ action: @escaping (Bool) -> Void) {
            self.action = action
            super.init(frame: CGRect.zero)

            self.addGestureRecognizer(UIHoverGestureRecognizer(
                target: self,
                action: #selector(hovering(_:))))
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc
        func hovering(_ recognizer: UIHoverGestureRecognizer) {
            switch recognizer.state {
                case .began, .changed:
                    action(true)
                case .ended:
                    action(false)
                default:
                    break
            }
        }
    }
}

struct ContentView: View {
    @State var tabs = [Date()]
    @State var currentTabIndex = 0
    @State var hoveredTabIndex = -1
    
    let formatter = DateFormatter()
    
    init() {
        formatter.timeStyle = .medium
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    ForEach((0..<self.tabs.count), id: \.self) { index in
                        Button(action: {
                            self.currentTabIndex = index
                        }) {
                            HStack {
                                Button(action: {
                                    self.tabs.remove(at: index)
                                }) {
                                    Image(systemName: "xmark")
                                }
                                .padding(5)
                                .background(Color.gray)
                                .mask(RoundedRectangle(cornerRadius: 2))
                                .hoverEffect(.highlight)
                                .opacity(self.hoveredTabIndex == index ? 1 : 0)
                                .animation(.default)
                                Text(self.formatter.string(from: self.tabs[index]))
                            }
                            .frame(width: (geo.size.width - 20) / CGFloat(self.tabs.count), height: 30)
                        }
                        .onHover2 {
                            self.hoveredTabIndex = $0 ? index : -1
                        }
                        .padding(0)
                        .background(index == self.currentTabIndex ? Color.gray : Color.black)
                        .foregroundColor(.primary)
                        .border(Color.gray.opacity(0.7), width: 1)
                    }
                    AddNewTabButton {
                        self.tabs.append(Date())
                    }
                    Spacer()
                }
                .frame(height: 20)
                DateView(date: self.tabs[self.currentTabIndex])
                Spacer()
            }
        }
    }
}


struct AddNewTabButton: View {
    var action: () -> ()
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(systemName: "plus")
        }
        .frame(width: 20)
    }
}

struct DateView: View {
    let date: Date
    
    var body: some View {
        Text("\(date)")
            .foregroundColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 200))
            .background(Color(UIColor.systemBackground))
            .environment(\.colorScheme, .dark)
        
    }
}
