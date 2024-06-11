import { PermissionManager, TabClass, windowManager } from '@hm/basic'
import My from './My/My'
import { getUserInfo } from '../../api/user'
import TaskTabs from './Task/TaskTabs'
import { Log } from '@abner/log'
import Message from '../Message/Message'

@Entry
@Component
struct Index {
  @State @Watch("updateName") currentIndex: number = 0 // 当前激活项
  @State tabsData: TabClass[] = [{
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
  @Provide currentName: string = ""

  async aboutToAppear(): Promise<void> {
    // 开始沉浸式状态栏
    AppStorage.setOrCreate("userInfo", await getUserInfo())
    // 进入页面后,申请权限
    // 申请定位权限
    await new PermissionManager(getContext()).requestPermissions([
      'ohos.permission.LOCATION',
      'ohos.permission.APPROXIMATELY_LOCATION'
    ])
  }

  onPageShow(): void {
    windowManager.enableFullScreen(true)
  }

  onPageHide(): void {
    windowManager.enableFullScreen(false)
  }

  updateName() {
    this.currentName = this.tabsData[this.currentIndex].name
  }

  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon).width(22).height(22)
        .fillColor(item.name === this.tabsData[this.currentIndex].name ?
        $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(item.name === this.tabsData[this.currentIndex].name ?
        $r('app.color.primary') : $r('app.color.text_secondary'))
    }.alignItems(HorizontalAlign.Center)
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      ForEach(this.tabsData, (item: TabClass) => {
        TabContent() {
          if (item.name === 'task') {
            TaskTabs()
          } else if (item.name === 'message') {
            Message()
          } else {
            My()
          }
        }.tabBar(this.getTabBar(item))
      })
    }
    .scrollable(false)
    .padding({ bottom: 25 })
    .onTabBarClick((index) => {
      this.currentIndex = index
    })
  }
}