interface StoryLine {
  text: string;
  speaker: string;
  bgImage: string; // 背景图资源名
  characterImage: string; // 立绘资源名
  isCenter: boolean; // 立绘是否居中
  hasChoice: boolean; // 是否有选择
}

@Entry
@Component
struct TrashGame {
  // 1. 定义当前剧情索引
  @State currentIndex: number = 0;
  // 定时器ID
  private timerId: number = -1;
  // 倒计时显示
  @State countdown: number = 5;


  private story: StoryLine[] = [
    {
      text: "雪怪：我是snow monster。",
      speaker: "雪怪",
      bgImage: "corn", // 使用corn背景
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
      text: "雪怪：谢谢老大！老大真好！",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: false
    },
    {
      text: "雪怪：我很生气！",
      speaker: "雪怪",
      bgImage: "corn",
      characterImage: "snow",
      isCenter: true,
      hasChoice: false
    }
  ];

  // 自动跳转到下一个对话
  private autoNextDialogue(): void {
    if (this.currentIndex < this.story.length - 1) {
      this.currentIndex++;
      console.log('自动跳转到下一个对话,新索引:', this.currentIndex);
    } else {
      // 循环播放,重新开始
      this.currentIndex = 0;
      console.log('自动重新开始,索引重置为0');
    }
  }

  // 选择给玉米
  private giveCorn(): void {
    this.currentIndex = 5; // 跳转到第六幕
    this.stopTimer(); // 停止定时器
  }

  // 选择不给玉米
  private refuseCorn(): void {
    this.currentIndex = 6; // 跳转到第七幕
    this.stopTimer(); // 停止定时器
  }

  // 启动定时器
  private startTimer(): void {
    if (this.timerId === -1) {
      this.countdown = 5; // 重置倒计时
      this.timerId = setInterval(() => {
        this.countdown--;
        console.log('倒计时:', this.countdown);
        if (this.countdown <= 0) {
          this.autoNextDialogue();
          this.countdown = 5; // 重置倒计时
        }
      }, 1000); // 每秒更新一次
      console.log('定时器已启动,5秒后自动跳转');
    }
  }

  // 停止定时器
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
      // 3. 背景层
      Image($r('app.media.' + this.story[this.currentIndex].bgImage))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 4. 立绘层 (根据剧本显示)
      if (this.story[this.currentIndex].characterImage !== "") {
        Image($r('app.media.' + this.story[this.currentIndex].characterImage))
          .width(400) // 立绘宽度
          .height(600)
          .position({
            x: '50%', // 完全居中
            y: '10%'
          })
          .translate({ x: '-50%' }) // 向左偏移自身宽度的50%,实现真正的居中
          .transition({ type: TransitionType.All, opacity: 1.0, scale: { x: 1.0, y: 1.0 } })
      }

      // 5. 对话框层 (底部)
      Column() {
        Row() {
          Text(this.story[this.currentIndex].speaker)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ff0000') // 名字用大红色，土味十足
            .layoutWeight(1)
            .margin({ left: 20, top: 20 })

          Text(`${this.countdown}s`)
            .fontSize(20)
            .fontColor('#FFFF00')
            .margin({ right: 20, top: 20 })
        }
        .width('100%')

        Text(this.story[this.currentIndex].text)
          .fontSize(18)
          .fontColor('#ffffff')
          .alignSelf(ItemAlign.Start)
          .margin({ left: 20, top: 10, right: 20 })

        // 选择按钮
        if (this.story[this.currentIndex].hasChoice) {
          Row() {
            Button('给玉米')
              .fontSize(16)
              .backgroundColor('#ff9900')
              .fontColor('#ffffff')
              .width(120)
              .height(40)
              .margin({ right: 20 })
              .onClick(() => {
                this.giveCorn();
              })

            Button('不给')
              .fontSize(16)
              .backgroundColor('#ff3333')
              .fontColor('#ffffff')
              .width(120)
              .height(40)
              .onClick(() => {
                this.refuseCorn();
              })
          }
          .margin({ top: 10 })
        }
      }
      .width('100%')
      .height(250)
      .backgroundColor('rgba(0, 0, 0, 0.8)') // 半透明黑底
      .position({ x: 0, y: '75%' }) // 固定在底部
    }
    .width('100%')
    .height('100%')
  }
}