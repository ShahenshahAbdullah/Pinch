//
//  ContentView.swift
//  Pinch
//
//  Created by Murad on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTY
    
    @State private var isAnimating : Bool = false
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset : CGSize = .zero
    @State private var isDrawerOPen   : Bool = true
    
    let pages: [Page] = pageData
    @State private var pageIndex: Int = 1
    // MARK: - FUNCTION
    func resetImageState () {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    // MARK: - CONTENT
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color(.clear)
                // MARK: PAGE IMAGE
                Image (currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12,x: 2,y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imageScale)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                // MARK: - 1. TAP GESTURE
                    .onTapGesture (count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }else {
                            resetImageState()
                        }
                    })
                // MARK: - 2. DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value .translation
                                }
                            }
                            .onEnded { _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
                // MARK: 3.MAGNIFICATION
                    .gesture (
                    MagnificationGesture()
                        .onChanged {
                            value in withAnimation(.linear(duration: 1)) {
                                if imageScale >= 1 && imageScale <= 5 {
                                    imageScale = value
                                } else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        }
                        .onEnded {
                            _ in
                            if imageScale > 5 {
                                imageScale = 5
                            }else if imageScale <= 1 {
                                resetImageState()
                            }
                        }
                    )
                
                
            }// ZSTACK
            .navigationTitle("pinch & zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration:1)) {
                    isAnimating = true
                }
            })
            // MARK: INFOPANEL
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top,30)
                , alignment: .top )
            // MARK: CONTROLS
            .overlay(
                
                HStack {
                    // SCALE DOWN
                    
                    Button{
                        // some action
                        
                        withAnimation(.spring()){
                            if imageScale > 1 {
                                imageScale -= 1
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                        }
                    }label: {
                        ControllImageView(icon: "minus.magnifyingglass")
                    }
                    // RESET
                    
                    Button{
                        // some action
                        
                        resetImageState()
                        
                    }label: {
                        ControllImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                    }
                    // SCALE UP
                    
                    Button{
                        // some action
                        withAnimation(.spring()) {
                            if imageScale < 5 {
                                imageScale += 1
                                if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        }
                        
                    }label: {
                        ControllImageView(icon: "plus.magnifyingglass")
                    }
                    
                }// CONTROLS
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                
                .padding(.bottom,30)
                ,alignment: .bottom
            )
            // MARK: DRAWER
            .overlay (
                HStack (spacing : 12) {
                    // MARK: DRAWER HANDLE
                    Image(systemName: isDrawerOPen ?  "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture (perform: {
                            withAnimation(.easeOut) {
                                isDrawerOPen.toggle()
                            }
                        })
                    
                    
                    // MARK: THUMBNAILS
                    ForEach(pages) { item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOPen ? 1 : 0 )
                            .animation(.easeOut(duration: 0.5), value: isDrawerOPen)
                            .onTapGesture (perform:  {
                                isAnimating = true
                                pageIndex = item.id
                            })
                    }
                    
                    Spacer()
                }// DRAWER
                    .padding(EdgeInsets(top: 5, leading: 1, bottom: 5, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 250)
                    .padding(.top,UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOPen ? 20 : 220)
                ,alignment: .topTrailing
                
            )
            
            
        }// NAVIGATION
        .navigationViewStyle(.stack)
        
    }
}


// MARK: PREVIEW

#Preview {
    ContentView()
}
