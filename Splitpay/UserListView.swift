//
//  UserListView.swift
//  Splitpay
//
//  Created by Cliff Chan on 2/7/2023.
//

import SwiftUI

//
//struct UserListView: View {
//    @Binding var selectedUserIndex: Int
//    @Binding var users: [User]
//    
//    var body: some View {
//        VStack {
//            Picker("選擇用戶", selection: $selectedUserIndex) {
//                ForEach(users.indices, id: \.self) { index in
//                    Text(users[index].name)
//                        .tag(index)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            
//            Text("當前用戶: \(users[selectedUserIndex].name)")
//                .font(.headline)
//        }
//    }
//}
//
//struct AddUserView: View {
//    @Binding var isAddingUser: Bool
//    @Binding var users: [User]
//    @State private var newUserName = ""
//    
//    var body: some View {
//        VStack {
//            Text("新增用戶")
//                .font(.headline)
//            
//            TextField("輸入用戶名稱", text: $newUserName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button("確定") {
//                addUser()
//            }
//            .padding()
//        }
//    }
//    
//    private func addUser() {
//        if !newUserName.isEmpty {
//            let newUser = User(id: UUID(), name: newUserName, selectedProducts: [], orders: [])
//            users.append(newUser)
//            isAddingUser = false
//        }
//    }
//}
