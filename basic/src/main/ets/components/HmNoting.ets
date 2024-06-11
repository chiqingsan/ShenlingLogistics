@Entry
@Component
export struct HmNoting {
  contents: string = "没有货物"

  build() {
    Column({ space: 20 }) {
      Image($r("app.media.nothing"))
        .width(200)
        .height(120)
      Text(this.contents)
        .fontColor($r("app.color.text_secondary"))
        .lineHeight(22)
    }
  }
}