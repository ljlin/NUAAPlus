//
//  DedEngine.swift
//  NuaaTimeTable
//
//  Created by ljlin on 14/11/16.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

import Foundation
import EventKit

class DedEngine {
    let keyArray=["kcm","jsm","week","unit","roomid","weeks","xiaoqu"]
    var course = [[String:String]]()
    var eventStore = EKEventStore()
    func GetCourseTableByXh(xh : String,xn : String, xq : String, success : SuccessHandler) {
        NSLog("querry = \(xh)")
        self.course.removeAll()
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
        //println(xmldoc?.xmlString)
        let xml = xmldoc!
        let junkdoc = xml["soap:Envelope"]["soap:Body"]["GetCourseTableByXhResponse"]["GetCourseTableByXhResult"]["diffgr:diffgram"]["NewDataSet"].children.last
        
        NSLog("%@",junkdoc!.xmlString)
        
        if (error != nil) { NSLog("%@", error!.description) }
        if let xml = xmldoc{
            for child in xml["soap:Envelope"]["soap:Body"]["GetCourseTableByXhResponse"]["GetCourseTableByXhResult"]["diffgr:diffgram"]["NewDataSet"].children {
                var courseInfo = [String:String]()
                for key in self.keyArray{
                    courseInfo[key] = child[key].value
                }
                course.append(courseInfo)
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
        dateComponents.year  = 2014
        dateComponents.month = 9
        dateComponents.day   = 1
        var dateCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var semesterDate = dateCalendar?.dateFromComponents(dateComponents)
        let timeForClass : [Double] = [8*60*60,10*60*60+15*60,14*60*60,16*60*60+15*60,18*60*60+30*60]
        for courseInfo in self.course {
            var title    = courseInfo["kcm"   ]! + " " + courseInfo["jsm"]!
            var location = courseInfo["roomid"]! + "@" + courseInfo["xiaoqu"]!
            var weeks = courseInfo["weeks"]!.componentsSeparatedByString(",")
            let unit = (courseInfo["unit"]!.toInt()! - 1 ) / 2
            let weekDay : Double = Double(courseInfo["week"]!.toInt()!) - 1
            let oneDay  : Double = 60 * 60 * 24
            let oneWeek : Double = oneDay * 7
            for weekString in weeks {
                let weekNum : Double = Double(weekString.toInt()!) - 1
                let startDate = NSDate(timeInterval: weekNum * oneWeek + weekDay * oneDay + timeForClass[unit],
                    sinceDate: semesterDate!)
                let endDate = startDate.dateByAddingTimeInterval((60 + 45) * 60)
                var event = EKEvent(eventStore: self.eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.location = location
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