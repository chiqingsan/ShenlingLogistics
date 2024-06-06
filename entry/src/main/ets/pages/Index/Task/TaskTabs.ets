import { TabClass } from '@hm/basic'
import TaskList from './TaskList'

@Preview
@Component
struct TaskTabs {
  tabController: TabsController = new TabsController()
  @State tabsData: TabClass[] = [{
    name: 'waiting',
    title: '待提货'
  }, {
    name: 'line',
    title: '在途'
  }, {
    name: 'finish',
    title: '已完成'
  }]
  @State currentIndex: number = 0

  @Builder
  getTabBar(item: TabClass) {
    Stack() {
      Text(item.title)
        .fontSize(16)
        .fontColor(this.tabsData[this.currentIndex].name === item.name ? $r('app.color.text_primary') :
        $r('app.color.text_secondary'))
        .fontWeight(600)
        .animation({
          duration: 300
        })
        .margin({
          bottom: 10
        })
      Divider()
        .strokeWidth(4)
        .color($r('app.color.primary'))
        .lineCap(LineCapStyle.Round)
        .width(this.tabsData[this.currentIndex].name === item.name ? 23 : 0)

    }
    .alignContent(Alignment.Bottom)
    .onClick(() => {
      const index = this.tabsData.findIndex(i => i.name === item.name)
      // 因为是双向绑定的,所以不用控制器去跳转页面也可以
      // this.tabController.changeIndex(index)
      this.currentIndex = index
    })
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex, controller: this.tabController }) {
        ForEach(this.tabsData, (item: TabClass) => {
          TabContent() {
            if (item.name === "waiting") {
              // Text(item.title)
              TaskList()
            }
          }.tabBar(item.title)
        })
      }
      .backgroundColor($r('app.color.background_page'))
      .animationDuration(250)

      Row({ space: 35 }) {
        ForEach(this.tabsData, (item: TabClass) => {
          this.getTabBar(item)
        })
      }
      .padding({ left: 30, bottom: 10 })
      .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Bottom)
      .backgroundColor($r("app.color.white"))

    }
  }
}

export default TaskTabs