//
//  iCloudFriendsSaver.swift
//  myVKApp
//
//  Created by Natalya on 24/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import CloudKit

class CloudFriendsSaver {
    
    
    static private let recordType = "Friends"
    static private var recordIDsToDelete = [CKRecordID]()
    static private var recordsToSave = [CKRecord]()
    static private var cloudDB: CKDatabase = CKContainer.default().publicCloudDatabase
    static private var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "LastUpdate") as? Date
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "LastUpdate")
        }
    }
    
    static func operateDataCloud(friends: [Friend]) {
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 30 {
            print("Update isn`t nessesary")
            return
        }
        recordsToSave.removeAll()
        recordIDsToDelete.removeAll()
        lastUpdate = Date()
        
        let predicate = NSPredicate(value: true)
        let queryDel = CKQuery(recordType: recordType, predicate: predicate)
        var queryOperation = CKQueryOperation(query: queryDel)
        queryOperation.queuePriority =  .veryHigh
        queryOperation.qualityOfService = .userInitiated
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { record in
            self.recordIDsToDelete.append(record.recordID)
        }
        queryOperation.queryCompletionBlock = { (cursor, error) in
            
            if let cursor = cursor {
                let cursorOperation = CKQueryOperation(cursor: cursor)
                cursorOperation.cursor = cursor
                cursorOperation.resultsLimit = queryOperation.resultsLimit
                cursorOperation.queryCompletionBlock = queryOperation.queryCompletionBlock
                
                cursorOperation.recordFetchedBlock = { record in
                    self.recordIDsToDelete.append(record.recordID)
                }
                
                queryOperation = cursorOperation
                
                cloudDB.add(queryOperation)
                return
            } else {
                let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDsToDelete)
                
                operation.modifyRecordsCompletionBlock = { (savedRecords: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: Error?) in
                    if let error = error {
                        print("deleting error: ", error.localizedDescription)
                        return
                    }
                    self.recordsToSave.removeAll()
                    DispatchQueue.main.async {
                        self.saveDataToCloud(friends: friends)
                    }
                }
                self.cloudDB.add(operation)
            }
        }
        cloudDB.add(queryOperation)
}
    
    static private func saveDataToCloud(friends: [Friend]) {
        
            for item in friends {
                let recordId = CKRecordID(recordName: "\(item.compoundKey)")
                let record = CKRecord(recordType: self.recordType , recordID: recordId)
                record.setValue("\(item.idFriend)", forKey: "idFriend")
                record.setValue(item.online, forKey: "online")
                record.setValue("\(item.firstName)", forKey: "firstName")
                record.setValue("\(item.lastName)", forKey: "lastName")
                record.setValue(item.photoUrl, forKey: "photoUrl")
                record.setValue("\(item.userId)", forKey: "userId")
                
                recordsToSave.append(record)
            }
            
            let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: nil)
            
            operation.modifyRecordsCompletionBlock = { (savedRecords: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: Error?) in
                if let error = error {
                    print("savings error: ", error.localizedDescription)
                    return
                }
                print("saved")
            }
           self.cloudDB.add(operation)
        }
}
