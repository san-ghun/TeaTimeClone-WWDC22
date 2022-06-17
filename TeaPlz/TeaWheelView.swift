//
//  TeaWheelView.swift
//  TeaPlz
//
//  Created by Sanghun Park on 17.06.22.
//

import SwiftUI

struct TeaWheelView<Data, ID>: View where Data: RandomAccessCollection, ID: Hashable {
    
    let data: Data
    let idKeypath: KeyPath<Data.Element, ID>
    let action: ((Data.Element) -> Void)?
    
    @State var startingRotation: Double = 0
    @State var translation: Double = 0
    
    let colors: [Color] = [.blue, .green, .yellow, .orange, .red, .purple, .indigo, .teal]
    
    init(_ data: Data, action: ((Data.Element) -> Void)? = nil) where Data.Element: Identifiable, ID == Data.Element.ID {
        self.data = data
        self.idKeypath = \.id
        self.action = action
    }
    
    init(_ data: Data, id: KeyPath<Data.Element, ID>, action: ((Data.Element) -> Void)? = nil) {
        self.data = data
        self.idKeypath = id
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color.gray)
                    .shadow(color: Color.black.opacity(0.3), radius: geometry.size.height, x: 0, y: 0)
                
                ForEach(enumeratedData, id:enumeratedDataIDKeyPath) { (index, item) in
                    let color = colors[index % colors.count]
                    let includeOverlap = !(index == data.count - 1)
                    
                    TeaWheelSlice(size: sliceSize, color: color, includeOverlap: includeOverlap) {
                        Text("\(index + 1)")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .rotationEffect(sliceSize * Double(index))
                }
                .rotationEffect(.degrees(startingRotation) + .degrees(translation / geometry.size.height * 180))
                
                TeaWheelPointer()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.3), radius: geometry.size.height / 50, x: 0, y: 0)
                    .frame(width: geometry.size.width / 12, height: geometry.size.height / 6, alignment: .center)
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        startingRotation = startingRotation.truncatingRemainder(dividingBy: 360)
                        translation = value.translation.height
                    })
                    .onEnded({ value in
                        let velocity = abs(value.predictedEndTranslation.height - value.translation.height) / 400
                        let angularTranslation = (value.predictedEndTranslation.height / geometry.size.height) * CGFloat(180)
                        let desiredEndRotation = startingRotation + angularTranslation * (1 + velocity)
                        let nearestStop = round(desiredEndRotation / sliceSize.degrees) * sliceSize.degrees
                        let sliceIndex = (data.count - Int(round(desiredEndRotation.truncatingRemainder(dividingBy: 360) / sliceSize.degrees))) % data.count
                        
                        _ = sliceIndex
                        
                        let (animation, duration) = animation(for: velocity)
                        
                        withAnimation(animation) {
                            startingRotation = nearestStop
                            translation = 0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            let index = data.index(data.startIndex, offsetBy: sliceIndex)
                            action?(data[index])
                        }
                    })
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private typealias EnumerationElement = EnumeratedSequence<Data>.Element
    
    private var enumeratedData: [EnumerationElement] {
        return Array(data.enumerated())
    }
    
    private var enumeratedDataIDKeyPath: KeyPath<EnumerationElement, ID> {
        return (\EnumerationElement.element).appending(path: idKeypath)
    }
    
    private var sliceSize: Angle {
        return .degrees(360 / Double(data.count))
    }
    
    private func animation(for velocity: Double) -> (Animation, Double) {
        let duration = max(velocity, 0.2)
        return (Animation.easeOut(duration: duration), duration)
    }
    
}

fileprivate struct TeaWheelSlice<Label>: View where Label: View {
    
    let label: () -> Label
    let size: Angle
    let color: Color
    let includeOverlap: Bool
    
    init(size: Angle, color: Color, includeOverlap: Bool = true, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.size = size
        self.color = color
        self.includeOverlap = includeOverlap
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            TeaWheelSliceShape(sliceSize: size, includeOverlap: includeOverlap)
                .fill(color)
            
            label()
                .offset(x: 0, y: 12)
        }
    }
    
}

fileprivate struct TeaWheelSliceShape: Shape {
    
    let sliceSize: Angle
    let includeOverlap: Bool
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.height / 2, startAngle: .degrees(-90) - (sliceSize / 2), endAngle: .degrees(-90) + (sliceSize / 2) + (includeOverlap ? (sliceSize / 4) : .degrees(0)), clockwise: false)
        }
    }
}

fileprivate struct TeaWheelPointer: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.width / 2, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.midX, y: 0))
        }
    }
}

struct TeaWheelView_Previews: PreviewProvider {
    static let items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    static var previews: some View {
        TeaWheelView(items, id: \.self) {
            print($0)
        }
            .padding()
    }
}

