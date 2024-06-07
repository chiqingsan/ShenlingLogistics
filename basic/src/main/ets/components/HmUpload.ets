import { picker } from '@kit.CoreFileKit';
import { ImageList } from '../models';
import { promptAction } from '@kit.ArkUI';

@Preview
@Component
struct HmUpload {
  title: string = ""
  maxNum: number = 3
  @State imgList: ImageList[] = []

  // 弹出相册选择器
  async selectImage() {
    const photoPicker = new picker.PhotoViewPicker();
    const result = await photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: this.maxNum - this.imgList.length
    })
    // 循环数组
    if (result.photoUris?.length) {
      this.imgList = this.imgList.concat(result.photoUris.map(url => {
        return { url } as ImageList
      }))
    } else {
      promptAction.showToast({ message: "取消选择" })
    }
  }

  build() {
    // 渲染图片
    Column() {
      Text(this.title).fontSize(14).fontColor($r("app.color.text_secondary")).margin({
        top: 16,
        bottom: 16
      })
      Grid() {
        ForEach(this.imgList, (item: ImageList) => {
          GridItem() {
            Image(item.url)
              .width(95)
              .height(95)
              .borderRadius(4)
          }
        })
        if (this.imgList.length < this.maxNum) {
          GridItem() {
            Row() {
              Image($r("app.media.ic_add_img")).width(30).height(30)
            }
            .width(95)
            .height(95)
            .backgroundColor($r("app.color.upload_panel"))
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.selectImage()
            })
          }
        }
      }
      .height(Math.ceil(this.maxNum / 3) * 105)
      .columnsTemplate("1fr 1fr 1fr")
      .columnsGap(10)
    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}

export { HmUpload }