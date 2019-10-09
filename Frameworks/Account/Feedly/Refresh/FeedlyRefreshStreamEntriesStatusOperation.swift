//
//  FeedlyRefreshStreamEntriesStatusOperation.swift
//  Account
//
//  Created by Kiel Gillard on 25/9/19.
//  Copyright © 2019 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import os.log

/// Single responsibility is to update the read status of articles stored locally with the unread status of the entries in a Collection's stream from Feedly.
final class FeedlyRefreshStreamEntriesStatusOperation: FeedlyOperation {
	private let account: Account
	private let entryProvider: FeedlyEntryProviding
	private let log: OSLog
	let articleStatusCoordinator: FeedlyArticleStatusCoordinator
	
	init(account: Account, entryProvider: FeedlyEntryProviding, articleStatusCoordinator: FeedlyArticleStatusCoordinator, log: OSLog) {
		self.account = account
		self.articleStatusCoordinator = articleStatusCoordinator
		self.entryProvider = entryProvider
		self.log = log
	}
	
	override func main() {
		guard !isCancelled else {
			didFinish()
			return
		}
		
		articleStatusCoordinator.refreshArticleStatus(for: account, entries: entryProvider.entries) {
			self.didFinish()
		}
	}
}
