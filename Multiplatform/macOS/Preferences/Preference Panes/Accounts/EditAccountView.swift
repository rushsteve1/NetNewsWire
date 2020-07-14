//
//  EditAccountView.swift
//  Multiplatform macOS
//
//  Created by Stuart Breckenridge on 14/7/20.
//  Copyright © 2020 Ranchero Software. All rights reserved.
//

import SwiftUI
import Account
import Combine

struct EditAccountView: View {
    
	@ObservedObject var viewModel: AccountsPreferencesModel
	
	var body: some View {
        
		ZStack {
			RoundedRectangle(cornerRadius: 8, style: .circular)
				.foregroundColor(Color.secondary.opacity(0.1))
			
			VStack {
				HStack {
					Spacer()
					Button("Account Information", action: {})
					Spacer()
				}.padding(4)
				
				if viewModel.account != nil {
					Form(content: {
						HStack(alignment: .top) {
							Text("Type: ")
								.frame(width: 50)
							VStack(alignment: .leading) {
								Text(viewModel.account!.defaultName)
								Toggle("Active", isOn: $viewModel.accountIsActive)
							}
						}
						
						HStack(alignment: .top) {
							Text("Name: ")
								.frame(width: 50)
							VStack(alignment: .leading) {
								TextField(viewModel.account!.name ?? "", text: $viewModel.accountName)
									.textFieldStyle(RoundedBorderTextFieldStyle())
								Text("The name appears in the sidebar. It can be anything you want. You can even use emoji. 🎸")
									.foregroundColor(.secondary)
							}
						}
						Spacer()
						if viewModel.account?.type != .onMyMac {
							HStack {
								Spacer()
								Button("Credentials", action: {
									
								})
								Spacer()
							}
						}
						
						
						
					}).padding()
				}
				
				Spacer()
			}
		}
    }
	
	
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
		EditAccountView(viewModel: AccountsPreferencesModel())
    }
}
