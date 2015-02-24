#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();


target.delay(3)
captureLocalizedScreenshot("0-LandingScreen")


var target = UIATarget.localTarget();

target.frontMostApp().tabBar().buttons()["设置"].tap();
target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().tabBar().buttons()["个人课表"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(3)
captureLocalizedScreenshot("0-CourseTable")
target.frontMostApp().tabBar().buttons()["修读课程"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(3)
captureLocalizedScreenshot("0-Attending")
target.frontMostApp().tabBar().buttons()["教务通知"].tap();
target.frontMostApp().tabBar().buttons()["校历"].tap();
target.frontMostApp().tabBar().buttons()["考试安排"].tap();
target.delay(3)
captureLocalizedScreenshot("0-Exam")
