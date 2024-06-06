import { CommonRouterParams, HmNavBar } from '@hm/basic'
import { router } from '@kit.ArkUI'


@Entry
@Component
struct TaskDetail {
  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      // AlertDialog.show({
      //   message: params.id
      // })
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '任务详情' })
    }.backgroundColor($r('app.color.background_page')).height('100%')
  }
}