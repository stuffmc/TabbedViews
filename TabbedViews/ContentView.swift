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

class TabObject: ObservableObject {
    @Published var tabs = [Date()]
    @Published var currentTabIndex = 0
    
    func remove(at index: Int? = nil) {
        if tabs.count > 1 {
            tabs.remove(at: index == nil ? currentTabIndex : index!)
        }
    }
    
    func append() {
        tabs.append(Date())
    }
}

struct ContentView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var tabObject: TabObject
    var tabs: [Date] {
        tabObject.tabs
    }
    var currentTabIndex: Int {
        tabObject.currentTabIndex
    }
    @State private var hoveredTabIndex = -1
    @State private var hoveringCloseButton = false
    
    let formatter = DateFormatter()
    
    init() {
        formatter.timeStyle = .medium
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 0.5)
                ForEach((0..<self.tabs.count), id: \.self) { index in
                    Button(action: {
                        self.tabObject.currentTabIndex = index
                    }) {
                        HStack() {
                            Button(action: {
                                self.tabObject.remove(at: index)
                            }) {
                                Image(systemName: "xmark")
                            }
//                            .onHover2 {
//                                print($0)
//                                self.hoveringCloseButton = true // $0
//                            }
                            .padding(5)
                            /// See comments about colors in `tabColor`
//                                    .background(self.hoveringCloseButton ? Color(white: self.colorScheme == .dark ? 0.14 : 0.53) : self.tabColor(index == self.currentTabIndex))
                            .background(Color(white: self.colorScheme == .dark ? 0.14 : 0.53))
                            .mask(RoundedRectangle(cornerRadius: 3))
                            .padding(.leading, 5)
                            .hoverEffect(.highlight)
//                                    .opacity(self.hoveredTabIndex == index ? 1 : 0)
                            .opacity(self.tabs.count > 1 ? 1 : 0)
                            .animation(.default)
                            Group {
                                Spacer()
                                Text(self.formatter.string(from: self.tabs[index]))
                                Spacer()
                            }
                            .onHover2 {
                                self.hoveredTabIndex = $0 ? index : -1
//                                print(self.hoveredTabIndex)
//                                self.hoveringCloseButton = false
                            }
                        }
                        .frame(height: 30)
                        .padding(0)
                    }
                    .background(self.tabColor(index == self.currentTabIndex))
                    .foregroundColor(.primary)
                    .border(Color.gray.opacity(0.7), width: 1)
                }
                AddNewTabButton {
                    self.tabObject.append()
                }
                .padding(5)
                .padding(.trailing, 5)
            }
            .animation(.easeIn)
            if tabs.count > currentTabIndex {
                DateView(date: self.tabs[currentTabIndex])
            }
            Spacer()
        }
    }
    
    func tabColor(_ isCurrentTabIndex: Bool) -> Color {
        /// Yes, those colors are hard coded to reflect the Safari colors. Tell me if you find a better way.
        /// One of them is `labelColor` and another one `gridColor` but I don't know a way to refer them and anyways there's no grid or label here.
        Color(white: isCurrentTabIndex ? (colorScheme == .dark ? 0.16 : 0.81) : (colorScheme == .dark ? 0.09 : 0.74))
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
        .foregroundColor(.primary)
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
    let w = 1024
    let h = 100
    
    static var previews: some View {
        Group {
            ContentView()
                .previewLayout(.fixed(width: 520, height: 100))
                .environment(\.colorScheme, .light)

//            ContentView()
//                .previewLayout(.fixed(width: 1024, height: 100))
//                .environment(\.colorScheme, .dark)
        }
    }
}
