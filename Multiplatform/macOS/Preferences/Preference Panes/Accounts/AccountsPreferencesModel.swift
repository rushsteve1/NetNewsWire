//
//  AccountsPreferencesModel.swift
//  Multiplatform macOS
//
//  Created by Stuart Breckenridge on 13/7/20.
//  Copyright © 2020 Ranchero Software. All rights reserved.
//

import Foundation
import Account
import Combine

class AccountsPreferencesModel: ObservableObject {
	
	// Configured Accounts
	@Published var sortedAccounts: [Account] = []
	@Published var selectedConfiguredAccountID: String? = AccountManager.shared.defaultAccount.accountID {
		didSet {
			if let accountID = selectedConfiguredAccountID {
				account = sortedAccounts.first(where: { $0.accountID == accountID })
				accountIsActive = account?.isActive ?? false
				accountName = account?.name ?? ""
			}
		}
	}
	@Published var showAddAccountView: Bool = false
	
	// Edit Account
	public private(set) var account: Account?
	@Published var accountIsActive: Bool = false {
		didSet {
			account?.isActive = accountIsActive
		}
	}
	@Published var accountName: String = "" {
		didSet {
			account?.name = accountName
		}
	}
	
	var selectedAccountIsDefault: Bool {
		guard let selected = selectedConfiguredAccountID else {
			return true
		}
		if selected == AccountManager.shared.defaultAccount.accountID {
			return true
		}
		return false
	}
	
	// Subscriptions
	var notificationSubscriptions = Set<AnyCancellable>()
	
	init() {
		sortedAccounts = AccountManager.shared.sortedAccounts
		
		NotificationCenter.default.publisher(for: .UserDidAddAccount).sink(receiveValue: {  _ in
			self.sortedAccounts = AccountManager.shared.sortedAccounts
		}).store(in: &notificationSubscriptions)
		
		NotificationCenter.default.publisher(for: .UserDidDeleteAccount).sink(receiveValue: { _ in
			self.selectedConfiguredAccountID = nil
			self.sortedAccounts = AccountManager.shared.sortedAccounts
			self.selectedConfiguredAccountID = AccountManager.shared.defaultAccount.accountID
		}).store(in: &notificationSubscriptions)
		
		NotificationCenter.default.publisher(for: .AccountStateDidChange).sink(receiveValue: { notification in
			guard let account = notification.object as? Account else {
				return
			}
			if account.accountID == self.account?.accountID {
				self.account = account
				self.accountIsActive = account.isActive
				self.accountName = account.name ?? ""
			}
		}).store(in: &notificationSubscriptions)
	}
	
}
