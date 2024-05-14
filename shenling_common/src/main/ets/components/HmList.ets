import { HmLoading } from './HmLoading'
import { ListDataSource } from '../models'
import vibrator from '@ohos.vibrator';
import { AVPlayerClass } from '../utils'

@Component
struct HmList {
  @State
  loading: boolean = false // 控制上拉加载的并发
  onLoad: () => void = () => {
  } // 上拉加载的函数
  onRefresh: () => void = () => {
  } // 下拉刷新的函数
  @Prop
  finished: boolean // 当前是否已经查询完所有数据
  @Link
  @Watch("updateDataSource")
  dataSource: object[] // 数据源
  @BuilderParam
  renderItem: (item: object) => void
  loadingText: string = "加载数据中" // 加载中文本
  finishText: string = "没有内容啦" // 结束文本
  showLoadingIcon: boolean = true // 是否显示加载文本
  @State
  refreshIng: boolean = false
  @State
  lazyDataSource: ListDataSource = new ListDataSource()
  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive

  updateDataSource() {
    this.lazyDataSource.reloadData(this.dataSource)
  }

  @Builder
  getBottomDisplay() {
    // 根据条件去控制显示内容
    Row({ space: 10 }) {
      // finished 为true的时候 表示已经结束了
      if (this.finished) {
        Text(this.finishText)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
      } else {
        if (this.loading) {
          Text(this.loadingText)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          if (this.showLoadingIcon) {
            // 还没请求完，应该显示进度条的动画
            HmLoading({
              hWidth: 20
            })
          }
        }
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  getRefreshDisPlay() {
    Row({ space: 10 }) {
      LoadingProgress()
        .color($r('app.color.primary'))
        .width(40)
        .height(40)
      Text(this.getStatusText())
        .fontColor($r('app.color.text_secondary'))
        .fontSize(14)
    }
    .justifyContent(FlexAlign.Center)
    .height(50)
    .width('100%')
  }

  // 动态生成文本
  getStatusText() {
    switch (this.refreshStatus) {
      case RefreshStatus.Inactive:
        return ""
      case RefreshStatus.Drag:
        return "继续下拉"
      case RefreshStatus.OverDrag:
        return "松手加载"
      case RefreshStatus.Refresh:
        return "加载中"
    }
    return ""
  }

  build() {
    Refresh({ refreshing: $$this.refreshIng, builder: this.getRefreshDisPlay }) {
      // 放置一个进度条不就行了吗
      List() {
        // 4.0 List必须有一个子元素才会触发onReachEnd
        // Next可以不放任何内容就执行
        // 每一个的结构不一样 每一个的数据还不一样 而且还不能在组件写死
        // 数据从哪里来
        LazyForEach(this.lazyDataSource, (item: object) => {
          ListItem() {
            // 可以放任何内容
            if (this.renderItem) {
              this.renderItem(item) // 渲染插槽内容
            }
          }
        })
        ListItem() {
          // 底部显示内容
          this.getBottomDisplay()
        }
      }.onReachEnd(async () => {
        // 上拉加载
        if (!this.finished && !this.loading) {
          this.loading = true
          await this.onLoad()
          this.loading = false
        }
      })
    }
    .onStateChange(async (state) => {
      this.refreshStatus = state
      if (state === RefreshStatus.Refresh) {
        await this.onRefresh()
        this.refreshIng = false
        this.loading = false
        AVPlayerClass.playAudio("success.wav", getContext(this))
        vibrator.startVibration({ duration: 300, type: 'time' }, { id: 0, usage: 'touch' })
      }
    })

  }
}

export { HmList }