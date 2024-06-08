import { HmNavBar, HmCard, HmCardItem } from '@hm/basic'
import { MapComponent } from '@hms.core.map.MapComponent'

@Entry
@Component
struct SelectLocation {
  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      Stack({ alignContent: Alignment.Bottom }) {
        //  地图区域
        MapComponent({
          mapOptions: {
            position: {
              target: {
                latitude: 39.9,
                longitude: 116.4
              },
              zoom: 10
            }
          },
          mapCallback: () => {
          }
        })
          .width('100%')
          .height('100%')
        Column() {
          HmCard() {
            HmCardItem({ leftTitle: '回龙观街道', rightText: '100m以内' })
            HmCardItem({ leftTitle: '金燕龙科研楼', rightText: '100m以内' })
            HmCardItem({ leftTitle: '春野画室', rightText: '100m以内' })
            HmCardItem({ leftTitle: '光滑时代(金艳龙科研楼店)', rightText: '100m以内' })
          }
        }
        .padding({
          bottom: 60
        })
      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}