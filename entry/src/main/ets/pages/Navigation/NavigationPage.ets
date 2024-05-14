import webview from '@ohos.web.webview'
import router from '@ohos.router'
import { HmNavBar, WebSdkClass } from 'shenling_common'
import { CommonRouterParams } from '../../models'
@Entry
@Component
struct NavigationPage {
  aboutToAppear() {
    WebSdkClass.controller = new webview.WebviewController()
  }
  aboutToDisappear() {
    WebSdkClass.controller = null // 释放资源
  }
  build() {
     Column() {
       HmNavBar({ title: '导航' })
       Web({ src: $rawfile("navigation_page.html") , controller: WebSdkClass.controller! })
         .width('100%')
         .layoutWeight(1)
         .onPageEnd(() => {
           const params = router.getParams() as CommonRouterParams
           if(params && params.start && params.end) {
              WebSdkClass.controller!.runJavaScript(`beginDriving('${params.start}','${params.end}')`)
           }
         })
     }
    .width('100%')
    .height('100%')
  }
}