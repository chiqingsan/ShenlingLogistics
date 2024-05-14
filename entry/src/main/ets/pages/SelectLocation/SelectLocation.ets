import webview from '@ohos.web.webview'
import { HmNavBar, HmCard, WebSdkClass, HmCardItem } from 'shenling_common'
import { AddressItem } from '../../models'
import router from '@ohos.router'

@Entry
@Component
struct SelectLocation {
  webSdk: WebSdkClass = new WebSdkClass()
  @State
  list: AddressItem[] = []
  async aboutToAppear() {
    WebSdkClass.controller = new webview.WebviewController()
    WebSdkClass.context = getContext(this)
    WebSdkClass.context.eventHub.on("search_list", (json: string) => {
      this.list = JSON.parse(json) as AddressItem[]
    })
  }
  async aboutToDisappear() {
    WebSdkClass.controller = null
    WebSdkClass.context = null
  }

  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      //  地图区域
      Web({ src: $rawfile("location.html"), controller: WebSdkClass.controller! })
      .height('100%')
      .width('100%')
      .javaScriptProxy({
        object: this.webSdk,
        name: 'shenling',
        methodList:["toast", "alert", "getLocation", "receiveData"],
        controller: WebSdkClass.controller!
      })
      Column() {
        HmCard() {
          ForEach(this.list, (item: AddressItem) => {
            HmCardItem({ leftTitle: item.address, rightText: `${item.distance}米` })
              .onClick(() => {
                router.back({
                  url: 'pages/ExceptionReport/ExceptionReport',
                  params: {
                    address: item.address.substring(0, 8)
                  }
                })
              //  item.address.substring(0, 8)
              })
          })
        }
      }.position({
        y: '100%'
      }).translate({
        y: -260
      })

    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}