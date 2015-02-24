#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();


target.delay(3)
captureLocalizedScreenshot("0-LandingScreen")

target.frontMostApp().tabBar().buttons()["More"].tap();
target.frontMostApp().navigationBar().rightButton().tap();
captureLocalizedScreenshot("0-ALL")
target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().tabBar().buttons()["设置"].tap();
captureLocalizedScreenshot("0-Settings")
target.frontMostApp().navigationBar().rightButton().tap();
target.frontMostApp().tabBar().buttons()["个人课表"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(3)
captureLocalizedScreenshot("0-CourseTable")
target.frontMostApp().tabBar().buttons()["修读课程"].tap();
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(3)
captureLocalizedScreenshot("0-Attending")

