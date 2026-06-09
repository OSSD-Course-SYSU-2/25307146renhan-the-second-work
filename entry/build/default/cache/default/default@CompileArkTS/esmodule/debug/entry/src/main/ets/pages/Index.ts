if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TrashGame_Params {
    currentIndex?: number;
    timerId?: number;
    countdown?: number;
    story?: StoryLine[];
}
interface StoryLine {
    text: string;
    speaker: string;
    bgImage: string;
    characterImage: string;
    isCenter: boolean;
    hasChoice: boolean;
}
class TrashGame extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__currentIndex = new ObservedPropertySimplePU(0, this, "currentIndex");
        this.timerId = -1;
        this.__countdown = new ObservedPropertySimplePU(2, this, "countdown");
        this.story = [
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
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TrashGame_Params) {
        if (params.currentIndex !== undefined) {
            this.currentIndex = params.currentIndex;
        }
        if (params.timerId !== undefined) {
            this.timerId = params.timerId;
        }
        if (params.countdown !== undefined) {
            this.countdown = params.countdown;
        }
        if (params.story !== undefined) {
            this.story = params.story;
        }
    }
    updateStateVars(params: TrashGame_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentIndex.purgeDependencyOnElmtId(rmElmtId);
        this.__countdown.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentIndex.aboutToBeDeleted();
        this.__countdown.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __currentIndex: ObservedPropertySimplePU<number>;
    get currentIndex() {
        return this.__currentIndex.get();
    }
    set currentIndex(newValue: number) {
        this.__currentIndex.set(newValue);
    }
    private timerId: number;
    private __countdown: ObservedPropertySimplePU<number>;
    get countdown() {
        return this.__countdown.get();
    }
    set countdown(newValue: number) {
        this.__countdown.set(newValue);
    }
    private story: StoryLine[];
    private autoNextDialogue(): void {
        if (this.currentIndex < this.story.length - 1) {
            this.currentIndex++;
            console.log('自动跳转到下一个对话,新索引:', this.currentIndex);
        }
        else {
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.width('100%');
            Stack.height('100%');
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ get id() {
                    return typeof __getResourceId__ === "function" ? __getResourceId__(this) : -1;
                }, "type": -1, params: ['app.media.' + this.story[this.currentIndex].bgImage], "bundleName": "com.example.myapplication", "moduleName": "entry" });
            Image.width('100%');
            Image.height('100%');
            Image.objectFit(ImageFit.Cover);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.story[this.currentIndex].characterImage !== "") {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ get id() {
                                return typeof __getResourceId__ === "function" ? __getResourceId__(this) : -1;
                            }, "type": -1, params: ['app.media.' + this.story[this.currentIndex].characterImage], "bundleName": "com.example.myapplication", "moduleName": "entry" });
                        Image.width('85%');
                        Image.height('88%');
                        Image.objectFit(ImageFit.Contain);
                        Image.position({
                            x: '50%',
                            y: '10%'
                        });
                        Image.translate({ x: '-50%' });
                        Image.transition({ type: TransitionType.All, opacity: 1.0, scale: { x: 1.0, y: 1.0 } });
                    }, Image);
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('25%');
            Column.backgroundColor('rgba(0, 0, 0, 0.8)');
            Column.position({ x: 0, y: '75%' });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.story[this.currentIndex].speaker);
            Text.fontSize({ "id": 16777233, "type": 10002, params: [], "bundleName": "com.example.myapplication", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#ff0000');
            Text.layoutWeight(1);
            Text.margin({ left: '3%', top: '2%' });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.countdown}s`);
            Text.fontSize({ "id": 16777232, "type": 10002, params: [], "bundleName": "com.example.myapplication", "moduleName": "entry" });
            Text.fontColor('#FFFF00');
            Text.margin({ right: '3%', top: '2%' });
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.story[this.currentIndex].text);
            Text.fontSize({ "id": 16777234, "type": 10002, params: [], "bundleName": "com.example.myapplication", "moduleName": "entry" });
            Text.fontColor('#ffffff');
            Text.alignSelf(ItemAlign.Start);
            Text.margin({ left: '3%', top: '1%', right: '3%' });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.story[this.currentIndex].hasChoice) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.margin({ top: '1%' });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Button.createWithLabel('给玉米');
                        Button.fontSize({ "id": 16777231, "type": 10002, params: [], "bundleName": "com.example.myapplication", "moduleName": "entry" });
                        Button.backgroundColor('#ff9900');
                        Button.fontColor('#ffffff');
                        Button.width('30%');
                        Button.height({ "id": 16777230, "type": 10002, params: [], "bundleName": "com.example.myapplication", "moduleName": "entry" });
                        Button.margin({ right: '3%' });
                        Button.onClick(() => {
                            this.giveCorn();
                        });
                    }, Button);
                    Button.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Button.createWithLabel('不给');
                        Button.fontSize({ "id": 16777231, "type": 10002, params: [], "bundleName": "com.example.myapplication", "moduleName": "entry" });
                        Button.backgroundColor('#ff3333');
                        Button.fontColor('#ffffff');
                        Button.width('30%');
                        Button.height({ "id": 16777230, "type": 10002, params: [], "bundleName": "com.example.myapplication", "moduleName": "entry" });
                        Button.onClick(() => {
                            this.refuseCorn();
                        });
                    }, Button);
                    Button.pop();
                    Row.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Column.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "TrashGame";
    }
}
registerNamedRoute(() => new TrashGame(undefined, {}), "", { bundleName: "com.example.myapplication", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
