//
//  DedEngine.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import Foundation
import EventKit
import Dollar

class DedEngine : NSObject {
    var courses = [DEDCourseInfo]()
    var eventStore = EKEventStore()
    lazy var userInfo : DEDUserInfo? = nil
    class var sharedInstance : DedEngine {
        struct Singleton {
            static let instance = DedEngine()
        }
        return Singleton.instance
    }
    lazy var calendars = DedEngine.sharedInstance.getCalendars()
    func requestAccessToEKEntityTypeEvent(success:SuccessBlock) {
        if EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) == EKAuthorizationStatus.Authorized {
            success("")
        }
        else {
            self.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:{(granted:Bool, error:NSError?) in
                if granted {
                    success("")
                }
                else{
                    SVProgressHUD.showErrorWithStatus("请在程序允许方法日历")
                }
            })
        }
    }
    func getCalendars() -> [EKCalendar] {
        var res = []
        self.requestAccessToEKEntityTypeEvent({(_) in
            res = self.eventStore.calendarsForEntityType(EKEntityTypeEvent).filter({
                ($0 as EKCalendar).source.title == "iCloud"
            })
        })
        return res as [EKCalendar]
    }
    func getCourseTableBySettings() -> Bool {
        if let user = userInfo {
            self.getCourseTableByXh(user.xh, xn: user.xn, xq: user.xq)
            return true
        }
        else {
            return false
        }
    }
    func getCourseTableByXh(xh : String,xn : String, xq : String) {
        NSLog("querry = \(xh)")
        self.courses.removeAll()
        let dic = ["xn":xn,"xq":xq,"xh":xh]
        let utility = SoapUtility(fromFile: "NuaaDedWebService")
        let postXml = utility.BuildSoapwithMethodName("GetCourseTableByXh", withParas:dic)
        var soapRequest = SoapService()
        soapRequest.PostUrl = "http://ded.nuaa.edu.cn/NetEa/Services/WebService.asmx"
        soapRequest.SoapAction = utility.GetSoapActionByMethodName("GetCourseTableByXh", soapType: SOAP)
        let result = soapRequest.PostSync(postXml)
        if result.StatusCode == 200 {
            self.analyzexmlString(result.Content)
            let data = NSKeyedArchiver.archivedDataWithRootObject(result.Content)
            NSUserDefaults.standardUserDefaults().setValue(data, forKey: "CourseTableXML")
        }
    }
    func tryLoadCachedTable() {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("CourseTableXML") as? NSData {
            if let xmlString = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? String {
                self.analyzexmlString(xmlString)
            }
        }
    }
    func analyzexmlString(xmlString:String!){
        let xmlData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)
        var error:NSError? = nil
        let xmldoc = AEXMLDocument(xmlData: xmlData!, error: &error)
        if (error != nil) { NSLog("%@", error!.description) }
        if let xml = xmldoc{
            for child in xml["soap:Envelope"]["soap:Body"]["GetCourseTableByXhResponse"]["GetCourseTableByXhResult"]["diffgr:diffgram"]["NewDataSet"].children {
                courses.append(DEDCourseInfo(XML: child))
            }
        }
    }
    func calculateFirstSemesterMonday() -> NSDate {
        let cnLocale = NSLocale(localeIdentifier: "zh_CN")
        let yearArray = self.userInfo!.xn.componentsSeparatedByString("-").map({(ele: String ) in ele.toInt()!})
        var approxComp = NSDateComponents()
        let idx = self.userInfo!.xq.toInt()! - 1
        approxComp <== [
            "day"   : 1,
            "month" : [9,3][idx],
            "year"  : yearArray[idx]
        ]
        var approx = cnLocale.objectForKey(NSLocaleCalendar)?.dateFromComponents(approxComp)
        var weekDayComp = cnLocale.objectForKey(NSLocaleCalendar)?.components( NSCalendarUnit.CalendarUnitWeekday, fromDate: approx!)
        let timeInterval : Int = {
            switch weekDayComp!.weekday {
            case 1 :
                return 60 * 60 * 24
            case 6 :
                return 60 * 60 * 24
            default :
                return ( 2 - weekDayComp!.weekday ) * 24 * 60 * 60
            }
        }()
        return approx!.dateByAddingTimeInterval(Double(timeInterval))
    }
    func importEvents(calendar:EKCalendar){
        self.requestAccessToEKEntityTypeEvent({(_) in self.importEventsImp(calendar)})
    }
    func importEventsImp(calendar:EKCalendar){
        var semesterDate : NSDate = {
            if let manually = self.userInfo?.setSemesterDateManually {
                if manually {
                    return self.userInfo!.semesterDate
                }
            }
            return self.calculateFirstSemesterMonday()
        }()
     
        let minutes = 60 , hours = 60 * minutes
        //[8*60*60,10*60*60+15*60,14*60*60,16*60*60+15*60,18*60*60+30*60]
        let timeForClass = [ 8  * hours,                // 1. 8:00 - 8:50
                             8  * hours + 55 * minutes, // 2. 8:55 - 9:45
                             10 * hours + 15 * minutes, // 3. 10:15 - 11:05
                             11 * hours + 15 * minutes, // 4. 11:10 - 12:00
                             14 * hours,                // 5. 14:00 - 14:50
                             14 * hours + 55 * minutes, // 6. 14:55 - 15:45
                             16 * hours + 15 * minutes, // 7. 16:15 - 17:05
                             17 * hours + 10 * minutes, // 8. 17:10 - 18:00
                             18 * hours + 30 * minutes, // 9. 18:30 - 19:20
                             20 * hours + 25 * minutes ]
        for course in self.courses {
            let weekDay : Int = course.week - 1
            let oneDay  : Int = 60 * 60 * 24
            let oneWeek : Int = oneDay * 7
            for weekNum in course.weeks {
                let interval =
                    (weekNum - 1)  * oneWeek +
                    weekDay * oneDay +
                    timeForClass[course.unit - 1]
                let startDate = NSDate(timeInterval: Double(interval), sinceDate: semesterDate)
                let lasting =  (course.lsjs * 55 - 5) * minutes
                let endDate = startDate.dateByAddingTimeInterval(Double(lasting))
                var event = EKEvent(eventStore: self.eventStore)
                event <== (course,["title","location"])
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = calendar
                event.allDay = false
                self.eventStore.saveEvent(event, span: EKSpanThisEvent, commit: false, error: nil)
            }
        }
        self.eventStore .commit(nil)
    }
    func creatCalendarby(title:String) -> EKCalendar? {
        var calendar : EKCalendar? = nil
        let sources = (self.eventStore.sources() as [EKSource]).filter {
           ($0.title == "iCloud")&&($0.sourceType.value == EKSourceTypeCalDAV.value)
        }
        var localSource : EKSource? = sources.isEmpty ?
                                        (self.eventStore.sources() as [EKSource]).first :
                                        sources.first
        calendar = EKCalendar(forEntityType:EKEntityTypeEvent , eventStore:self.eventStore)
        calendar?.title = title;
        calendar?.source = localSource;
        self.eventStore.saveCalendar(calendar, commit:true, error:nil)
        NSLog("creat cal id = %@", calendar!.calendarIdentifier);
        return calendar
    }
}