import { StoryEngine } from '../engines/StoryEngine';
import { RenderEngine } from '../engines/RenderEngine';
import { ChoiceEngine } from '../engines/ChoiceEngine';
import { StoryLine, Choice } from '../models/DataModels';

@Entry
@Component
export struct GamePage {
  @State currentIndex: number = 0;
  @State countdown: number = 5;
  @State currentScene: StoryLine | null = null;
  @State backgroundResource: Resource = $r('app.media.startIcon');
  @State characterResource: Resource = $r('app.media.startIcon');
  @State isCenter: boolean = true;
  @State speaker: string = '';
  @State dialogueText: string = '';
  @State choices: Choice[] = [];

  private storyEngine?: StoryEngine;
  private renderEngine?: RenderEngine;
  private choiceEngine?: ChoiceEngine;

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

  aboutToAppear(): void {
    this.storyEngine = new StoryEngine(
      this.story,
      (scene: StoryLine) => {
        this.currentScene = scene;
        this.speaker = scene.speaker;
        this.dialogueText = scene.text;
      },
      (seconds: number) => {
        this.countdown = seconds;
      }
    );

    this.renderEngine = new RenderEngine(
      (resource: Resource) => {
        this.backgroundResource = resource;
      },
      (resource: Resource, isCenter: boolean) => {
        this.characterResource = resource;
        this.isCenter = isCenter;
      },
      (speaker: string, text: string) => {
        this.speaker = speaker;
        this.dialogueText = text;
      },
      (seconds: number) => {
        this.countdown = seconds;
      }
    );

    this.choiceEngine = new ChoiceEngine(
      this.storyEngine,
      (choices: Choice[]) => {
        this.choices = choices;
      },
      () => {
        this.choices = [];
      }
    );

    this.storyEngine.startStory();
  }

  build() {
    Stack() {
      Image(this.backgroundResource)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      if (this.currentScene && this.currentScene.characterImage !== "") {
        Image(this.characterResource)
          .width(400)
          .height(600)
          .position({
            x: '50%',
            y: '10%'
          })
          .translate({ x: '-50%' })
      }

      Column() {
        Row() {
          Text(this.speaker)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ff0000')
            .layoutWeight(1)
            .margin({ left: 20, top: 20 })

          Text(`${this.countdown}s`)
            .fontSize(20)
            .fontColor('#FFFF00')
            .margin({ right: 20, top: 20 })
        }
        .width('100%')

        Text(this.dialogueText)
          .fontSize(18)
          .fontColor('#ffffff')
          .alignSelf(ItemAlign.Start)
          .margin({ left: 20, top: 10, right: 20 })

        if (this.currentScene && this.currentScene.hasChoice) {
          Row() {
            Button('给玉米')
              .fontSize(16)
              .backgroundColor('#ff9900')
              .fontColor('#ffffff')
              .width(120)
              .height(40)
              .margin({ right: 20 })
              .onClick(() => {
                if (this.storyEngine && this.choiceEngine) {
                  this.storyEngine.jumpToScene(5);
                  this.choiceEngine.handleChoice(0);
                }
              })

            Button('不给')
              .fontSize(16)
              .backgroundColor('#ff3333')
              .fontColor('#ffffff')
              .width(120)
              .height(40)
              .onClick(() => {
                if (this.storyEngine && this.choiceEngine) {
                  this.storyEngine.jumpToScene(6);
                  this.choiceEngine.handleChoice(1);
                }
              })
          }
          .margin({ top: 10 })
        }
      }
      .width('100%')
      .height(250)
      .backgroundColor('rgba(0, 0, 0, 0.8)')
      .position({ x: 0, y: '75%' })
    }
    .width('100%')
    .height('100%')
  }
}