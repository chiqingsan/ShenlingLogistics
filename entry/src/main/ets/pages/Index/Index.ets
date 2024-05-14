import { TOKEN_KEY } from 'shenling_common'
import { TabClass } from '../../models'
import My from './My/My'
import TaskTabs from './Task/TaskTabs'
import Message from './Message/Message'

PersistentStorage.PersistProp(TOKEN_KEY, "")

@Entry
@Component
struct Index {
  @State
  tabsData: TabClass[] = [{
    title: '任务',
    name: 'task',
    icon: $r("app.media.ic_tab_btn_task")
  }, {
    title: '消息',
    name: 'message',
    icon: $r("app.media.ic_tab_btn_mess_nor")
  }, {
    title: '我的',
    name: 'my',
    icon: $r("app.media.ic_tab_btn_mine_nor")
  }]
  @State
  currentName: string = "task"

  @Builder
  // 可以直接写ArkUI
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon)
        .width(22)
        .height(22)
        .fillColor(item.name === this.currentName ? $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontColor(this.currentName === item.name ? $r('app.color.primary') : $r('app.color.text_secondary'))
        .fontWeight(400)
        .margin({
          top: 5
        })
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      ForEach(this.tabsData, (item: TabClass) => {
        TabContent() {
          if (item.name === 'task') {
            TaskTabs()
          }
          else if (item.name === 'message') {
            Message()
          }
          else {
            My()
          }
        }
        .tabBar(this.getTabBar(item))
      })
    }
    // 无法调整tabbar的对齐方式
    .onTabBarClick(index => {
      this.currentName = this.tabsData[index].name
    })
    .animationDuration(300)
    .scrollable(false)
  }
}