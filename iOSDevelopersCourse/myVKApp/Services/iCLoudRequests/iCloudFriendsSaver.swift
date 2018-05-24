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
    
        self.lastUpdate = Date()
        
        let predicate = NSPredicate(value: true)
        let queryDel = CKQuery(recordType: recordType, predicate: predicate)
        
        cloudDB.perform(queryDel, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let records = records
            {
                for record in records {
                    self.recordIDsToDelete.append(record.recordID)
                }
                
                let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDsToDelete)
                
                operation.modifyRecordsCompletionBlock = { (savedRecords: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.recordIDsToDelete.removeAll()
                    DispatchQueue.main.async {
                        self.saveDataToCloud(friends: friends)
                    }
                }
                self.cloudDB.add(operation)
            }
        }
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
                    print(error.localizedDescription)
                    return
                }
                self.recordsToSave.removeAll()
                print("saved")
            }
           self.cloudDB.add(operation)
        }
}
