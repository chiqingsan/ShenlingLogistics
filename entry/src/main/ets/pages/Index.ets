import { windowManager } from '../common/utils/WindowManager';
import { Message } from './Message/Message';
import { Mine } from './Mine/Mine';
import { Task } from './Task/Task';

interface tabsSubstance {
  substance: string,
  src: ResourceStr
}

@Entry
@Component
struct Index {
  @StorageProp("topHeight") topHeight: number = 0
  @State tabsIndex: number = 0
  @State TabsItemsList: tabsSubstance[] = [
    { substance: "任务", src: $r("app.media.ic_tab_btn_task") },
    { substance: "消息", src: $r("app.media.ic_tab_btn_mess_nor") },
    { substance: "我的", src: $r("app.media.ic_tab_btn_mine_nor") },
  ]

  aboutToAppear(): void {
    // 开启沉浸式状态栏
    windowManager.enableFullScreen()
  }

  build() {
    Column() {

      Tabs() {
        ForEach(
          this.TabsItemsList,
          (item: tabsSubstance, index) => {
            TabContent() {
              if (this.tabsIndex === 0) {
                // 任务页面
                Task()
              } else if (this.tabsIndex === 1) {
                // 消息页面
                Message()
              } else if (this.tabsIndex === 2) {
                // 我的页面
                Mine()
              }
            }.tabBar(this.tabsItem(item, index))
          }
        )
      }
      .barHeight(70)
      .barPosition(BarPosition.End)
      .onTabBarClick((index) => {
        this.tabsIndex = index
      })

    }
    .padding({ top: this.topHeight, bottom: 20 })
  }

  @Builder
  tabsItem(item: tabsSubstance, index: number) {
    Column() {
      Image(item.src)
        .width(20)
        .aspectRatio(1)
        .fillColor(this.tabsIndex === index ? "#EF4F3F" : "#818181")
      Text(item.substance)
        .fontSize(12)
        .fontColor(this.tabsIndex === index ? "#EF4F3F" : "#818181")
    }.height(100)
  }
}