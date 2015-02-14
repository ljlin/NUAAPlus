//
//  DedEngine.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import Foundation
import EventKit

typealias SuccessHandler = ()->()

class DedEngine {
    var courses = [courseInfo]()
    var eventStore = EKEventStore()
    func GetCourseTableByXh(xh : String,xn : String, xq : String, success : SuccessHandler) {
        NSLog("querry = \(xh)")
        self.courses.removeAll()
        let dic = ["xn":xn,"xq":xq,"xh":xh]
        let utility = SoapUtility(fromFile: "NuaaDedWebService")
        let postXml = utility.BuildSoapwithMethodName("GetCourseTableByXh", withParas:dic)
        var soapRequest = SoapService()
        soapRequest.PostUrl = "http://ded.nuaa.edu.cn/NetEa/Services/WebService.asmx"
        soapRequest.SoapAction = utility.GetSoapActionByMethodName("GetCourseTableByXh", soapType: SOAP)
        soapRequest.PostAsync(postXml, success:{(response:String!) in
                self.analyzexmlString(response)
                success()
            },
            falure: { (error:NSError!) in
                NSLog("\(error.description)")
        })
    }
    
    func analyzexmlString(xmlString:String!){
        let xmlData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)
        var error:NSError? = nil
        let xmldoc = AEXMLDocument(xmlData: xmlData!, error: &error)
        
        if (error != nil) { NSLog("%@", error!.description) }
        if let xml = xmldoc{
            for child in xml["soap:Envelope"]["soap:Body"]["GetCourseTableByXhResponse"]["GetCourseTableByXhResult"]["diffgr:diffgram"]["NewDataSet"].children {
                courses.append(courseInfo(XML: child))
            }
        }

    }
    
    func importEvents(){
        self.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:{(granted:Bool, error:NSError?) in
            dispatch_async(dispatch_get_main_queue(), {
                if(granted){
                    self.importEventsImp()
                }
            })
        })
    }
    
    func importEventsImp(){
        var calendar = self.getCalendarby("NuaaTimeTable")
        var dateComponents = NSDateComponents()
        dateComponents.year  = 2015
        dateComponents.month = 3
        dateComponents.day   = 2
        var dateCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var semesterDate = dateCalendar?.dateFromComponents(dateComponents)!
        let timeForClass : [Int] = [8*60*60,10*60*60+15*60,14*60*60,16*60*60+15*60,18*60*60+30*60]
        
        for course in self.courses {
            let weekDay : Int = course.week - 1
            let oneDay  : Int = 60 * 60 * 24
            let oneWeek : Int = oneDay * 7
            for weekNum in course.weeks {
                let interval =
                    (weekNum - 1)  * oneWeek +
                    weekDay * oneDay +
                    timeForClass[ (course.unit - 1 ) / 2 ]
                
                let startDate = NSDate(timeInterval: Double(interval), sinceDate: semesterDate!)
                let endDate = startDate.dateByAddingTimeInterval((60 + 45) * 60)
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
    func getCalendarby(title:String) -> EKCalendar? {
        //let path = NSBundle.mainBundle().pathForResource("Settings", ofType: "plist")
        //var Settings = NSMutableDictionary(contentsOfFile: path!)
        //var ids : NSMutableDictionary = Settings?["identifier"] as NSMutableDictionary
        var localSource : EKSource? = (self.eventStore.sources() as [EKSource]).first
        var calendar : EKCalendar? = nil
        let sources = self.eventStore.sources() as NSArray
        for source in self.eventStore.sources() as [EKSource] {
            println(source.title)
            if ((source.title == "iCloud")  && (source.sourceType.value == EKSourceTypeCalDAV.value) ) {
                localSource = source;
                break;
            }
        }
        var created = false
        /*
        if let identifier = ids[title] as String? {
            if(identifier != ""){
                calendar = self.eventStore.calendarWithIdentifier(identifier)
                created = true
                NSLog("get cal id = %@", calendar!.calendarIdentifier);
            }
        }
        */
        if(!created){
            calendar = EKCalendar(forEntityType:EKEntityTypeEvent , eventStore:self.eventStore)
            calendar?.title = title;
            calendar?.source = localSource;
            self.eventStore.saveCalendar(calendar, commit:true, error:nil)
            NSLog("creat cal id = %@", calendar!.calendarIdentifier);
            //ids[title] = calendar!.calendarIdentifier;
            //Settings!.writeToFile(path!,atomically:true)
        }
        //Settings = NSMutableDictionary(contentsOfFile: path!)
        return calendar
    }
}