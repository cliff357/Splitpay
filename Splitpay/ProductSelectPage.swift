//
//  ContentView.swift
//  Splitpay
//
//  Created by Cliff Chan on 2/7/2023.
//

import SwiftUI

struct ProductSelectPage: View {
    @State private var users: [User] = []
    @State private var selectedProducts: [Product] = []
    
    var totalPrice: Double {
        return selectedProducts.reduce(0.0) { $0 + $1.price }
    }
    
    var body: some View {
        VStack {
            // 頁面頂部：新增 User 的按鈕
            Button(action: {
                addUser()
            }) {
                Text("新增 User")
                    .foregroundColor(.blue)
                    .padding()
            }
            
            // 頁面中間：Product 列表
            List(selectedProducts, id: \.productId) { product in
                ProductRowView(product: product)
            }
            
            // 頁面底部：確認按鈕
            Button(action: {
                createOrder()
            }) {
                Text("確認")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // 顯示總價格
            Text("總價錢：\(totalPrice) 元")
                .padding()
        }
    }
    
    private func addUser() {
        let newUser = User(userId: users.count + 1, name: "User \(users.count + 1)", orders: [])
        users.append(newUser)
    }
    
    private func createOrder() {
        // 創建一張新訂單
        let order = Order(orderId: generateOrderID(), products: selectedProducts)
        
        // 將訂單分配給每個用戶
        for i in 0..<users.count {
            users[i].orders.append(order)
        }
        
        // 清空選擇的產品列表
        selectedProducts = []
    }
    
    private func generateOrderID() -> Int {
        // 實作生成訂單ID的邏輯
        // 這裡可以使用你選擇的生成方式，例如自增計數器、隨機數等
        // 返回一個唯一的訂單ID
        return Int.random(in: 1000...9999)
    }
}

struct ProductRowView: View {
    @State private var quantity: Int = 0
    let product: Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("價錢：\(product.price) 元")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Stepper(value: $quantity, in: 0...10) {
                Text("數量：\(quantity)")
            }
        }
        .padding()
    }
}

#Preview {
    ProductSelectPage()
}
