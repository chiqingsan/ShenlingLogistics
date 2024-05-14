import { CustomTabs } from '../../../common/components/CustomTabs'
import { TabClass, TaskListParamsModel, TaskTypeEnum, TaskListParams } from '../../../models'
import TaskList from './TaskList'


@Preview
@Component
struct TaskTabs {
  @State left: number = 16
  @State
  tabsData: TabClass[] = [
    { name: 'waiting', title: '待提货' },
    { name: 'line', title: '在途' },
    { name: 'finish', title: '已完成' }
  ]
  @State currentTabIndex: number = 0

  build() {
    Column() {
      CustomTabs({
        tabBuilderList: this.tabsData.map(item => item.title),
        index: this.currentTabIndex
      })
        .padding({ bottom: 10 })
      Column() {
        if (this.currentTabIndex === 0) {
          // 待提货
          TaskList()
        }
        else if (this.currentTabIndex === 1) {
          // 在途
          TaskList({
            queryParams: new TaskListParamsModel({
              page: 1,
              pageSize: 5,
              status: TaskTypeEnum.Line // 查询的是在途的数据
            } as TaskListParams)
          })
        }
        else if (this.currentTabIndex === 2) {
          // 已完成
          TaskList({
            queryParams: new TaskListParamsModel({
              page: 1,
              pageSize: 5,
              status: TaskTypeEnum.Finish // 查询的是已完成的数据
            } as TaskListParams)
          })
        }
      }.layoutWeight(1)
    }
    .width("100%")
    .height("100%")
  }
}

export default TaskTabs