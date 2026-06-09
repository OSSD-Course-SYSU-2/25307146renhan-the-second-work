interface StoryLine {
  text: string;
  speaker: string;
  bgImage: string;
  characterImage: string;
  isCenter: boolean;
  hasChoice: boolean;
}

@Entry
@Component
struct TrashGame {
  @State currentIndex: number = 0;
  private timerId: number = -1;
  @State countdown: number = 2;

  private story: StoryLine[] = [
    {
      text: "雪怪：我是snow monster。",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: false
    },
    {
      text: "我爱吃大玉米棒子",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: false
    },
    {
      text: "好吃。",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: false
    },
    {
      text: "如果你给我吃玉米的话。我就认你当老大。",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: false
    },
    {
      text: "老大再给一根玉米好不好",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: true
    },
    {
      text: "雪怪：我很生气！",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow3",
      isCenter: true,
      hasChoice: false
    },
    {
      text: "雪怪：谢谢老大！老大真好！",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: false
    },
    {
      text: "吃完玉米我变得更帅了",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow1",
      isCenter: true,
      hasChoice: false
    }
  ];

  private autoNextDialogue(): void {
    if (this.currentIndex < this.story.length - 1) {
      this.currentIndex++;
      console.log('自动跳转到下一个对话,新索引:', this.currentIndex);
    } else {
      this.stopTimer();
      console.log('剧情播放结束');
    }
  }

  private giveCorn(): void {
    this.currentIndex = 6;
    this.stopTimer();
    this.startTimer();
  }

  private refuseCorn(): void {
    this.currentIndex = 5;
    this.stopTimer();

  }

  private startTimer(): void {
    if (this.timerId === -1) {
      this.countdown = 2;
      this.timerId = setInterval(() => {
        this.countdown--;
        console.log('倒计时:', this.countdown);
        if (this.countdown <= 0) {
          this.autoNextDialogue();
          this.countdown = 2;
        }
      }, 1000);
      console.log('定时器已启动,5秒后自动跳转');
    }
  }

  private stopTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
      console.log('定时器已停止');
    }
  }

  aboutToAppear(): void {
    this.startTimer();
  }

  aboutToDisappear(): void {
    this.stopTimer();
  }

  build() {
    Stack() {
      Image($r('app.media.' + this.story[this.currentIndex].bgImage))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      if (this.story[this.currentIndex].characterImage !== "") {
        Image($r('app.media.' + this.story[this.currentIndex].characterImage))
          .width('85%')
          .height('88%')
          .objectFit(ImageFit.Contain)
          .position({
            x: '50%',
            y: '10%'
          })
          .translate({ x: '-50%' })
          .transition({ type: TransitionType.All, opacity: 1.0, scale: { x: 1.0, y: 1.0 } })
      }

      Column() {
        Row() {
          Text(this.story[this.currentIndex].speaker)
            .fontSize($r('app.float.speaker_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor('#ff0000')
            .layoutWeight(1)
            .margin({ left: '3%', top: '2%' })

          Text(`${this.countdown}s`)
            .fontSize($r('app.float.countdown_size'))
            .fontColor('#FFFF00')
            .margin({ right: '3%', top: '2%' })
        }
        .width('100%')

        Text(this.story[this.currentIndex].text)
          .fontSize($r('app.float.text_size'))
          .fontColor('#ffffff')
          .alignSelf(ItemAlign.Start)
          .margin({ left: '3%', top: '1%', right: '3%' })

        if (this.story[this.currentIndex].hasChoice) {
          Row() {
            Button('给玉米')
              .fontSize($r('app.float.btn_text_size'))
              .backgroundColor('#ff9900')
              .fontColor('#ffffff')
              .width('30%')
              .height($r('app.float.btn_height'))
              .margin({ right: '3%' })
              .onClick(() => {
                this.giveCorn();
              })

            Button('不给')
              .fontSize($r('app.float.btn_text_size'))
              .backgroundColor('#ff3333')
              .fontColor('#ffffff')
              .width('30%')
              .height($r('app.float.btn_height'))
              .onClick(() => {
                this.refuseCorn();
              })
          }
          .margin({ top: '1%' })
        }
      }
      .width('100%')
      .height('25%')
      .backgroundColor('rgba(0, 0, 0, 0.8)')
      .position({ x: 0, y: '75%' })
    }
    .width('100%')
    .height('100%')
  }
}