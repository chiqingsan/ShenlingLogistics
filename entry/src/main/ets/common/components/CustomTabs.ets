interface TabItem {
  name: string
  value: number
  onAreaChange?: (area: Area) => void
}


@Entry
@Component
export struct CustomTabs {
  @State left: number = 16
  yokojoWidth: number = 23
  @Link index: number
  @State tabBuilderList: string[] = []

  setLineLeft(area: Area) {
    const width = area.width as number
    const x = area.position.x as number
    this.left = x + (width - this.yokojoWidth) / 2
  }

  build() {
    // 标签页
    Row() {
      Row({ space: 24 }) {

        ForEach(
          this.tabBuilderList,
          (item: string, index) => {

            this.tabBuilder({
              name: item,
              value: index,
              onAreaChange: index ? () => {
              } : (area) => {
                this.setLineLeft(area)
              }
            })
          }
        )
      }
      .width('100%')
      .padding({ left: 30, right: 16 })
      .height(40)


      Text()
        .width(this.yokojoWidth)
        .height(4)
        .borderRadius(2)
        .linearGradient({
          angle: 210,
          colors: [["#F25C4D", 0], ["#E52D21", 1]]
        })
        .position({ x: this.left, y: 38 })
        .animation({
          duration: 300
        })
    }
  }

  // 标签页
  @Builder
  tabBuilder(tab: TabItem) {
    Text(tab.name)
      .fontSize(16)
      .padding(6)
      .fontWeight(600)
      .fontColor(this.index === tab.value ? '#2A2929' : '#818181')
      .animation({
        duration: 300,
        curve: Curve.Ease
      })
      .onClick((e) => {
        this.setLineLeft(e.target.area)
        this.index = tab.value
      })
      .onAreaChange((_o, n) => tab.onAreaChange && tab.onAreaChange(n))
  }
}