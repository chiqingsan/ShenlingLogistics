import { HmNavBar, TabClass } from '@hm/basic'
import MessageTemplate from './MessageTemplate'

@Component
struct Message {
  @StorageProp("topHeight") topHeight: number = 0
  @State currentTabName: string = 'information'
  @State tabBarData: TabClass[] = [{
    title: '公告',
    name: 'information'
  }, {
    title: '任务通知',
    name: 'notice'
  }]

  @Builder
  TabBuilder(item: TabClass) {
    Column({ space: 6 }) {
      Text(item.title)
        .fontSize(16)
        .fontColor(this.currentTabName === item.name ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
        .fontWeight(this.currentTabName === item.name ? 500 : 400)
        .lineHeight(20)
      Divider()
        .strokeWidth(4)
        .color($r('app.color.primary'))
        .opacity(this.currentTabName === item.name ? 1 : 0)
        .width(23)
        .animation({
          duration: 300,
          curve: Curve.EaseOut
        })
    }.height("100%").justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      HmNavBar({ title: '消息', showBackIcon: false })
      Tabs({
        barPosition: BarPosition.Start
      }) {
        ForEach(this.tabBarData, (item: TabClass) => {
          TabContent() {
            Flex() {
              MessageTemplate({ type: item.name || '' })
            }.height('100%').backgroundColor($r('app.color.background_page'))
          }.tabBar(this.TabBuilder(item))
        })
      }
      .animationDuration(300)
      .onChange((index) => {
        this.currentTabName = index === 0 ? 'information' : 'notice'
      })
    }.width('100%').height('100%').padding({ top: this.topHeight })
  }
}

export default Message