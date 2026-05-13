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
    bgImage: string; // 背景图资源名
    characterImage: string; // 立绘资源名
    isCenter: boolean; // 立绘是否居中
}
class TrashGame extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__currentIndex = new ObservedPropertySimplePU(0, this, "currentIndex");
        this.timerId = -1;
        this.__countdown = new ObservedPropertySimplePU(5, this, "countdown");
        this.story = [
            {
                text: "雪怪：我是snow monster。",
                speaker: "雪怪",
                bgImage: "corn",
                characterImage: "snow",
                isCenter: true
            },
            {
                text: "我爱吃大玉米棒子",
                speaker: "雪怪",
                bgImage: "corn",
                characterImage: "snow",
                isCenter: true
            },
            {
                text: "好吃。",
                speaker: "雪怪",
                bgImage: "corn",
                characterImage: "snow",
                isCenter: true
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
    // 1. 定义当前剧情索引
    private __currentIndex: ObservedPropertySimplePU<number>;
    get currentIndex() {
        return this.__currentIndex.get();
    }
    set currentIndex(newValue: number) {
        this.__currentIndex.set(newValue);
    }
    // 定时器ID
    private timerId: number;
    // 倒计时显示
    private __countdown: ObservedPropertySimplePU<number>;
    get countdown() {
        return this.__countdown.get();
    }
    set countdown(newValue: number) {
        this.__countdown.set(newValue);
    }
    // 2. 定义你的“垃圾”剧本（在这里加剧情）
    private story: StoryLine[];
    // 自动跳转到下一个对话
    private autoNextDialogue(): void {
        if (this.currentIndex < this.story.length - 1) {
            this.currentIndex++;
            console.log('自动跳转到下一个对话,新索引:', this.currentIndex);
        }
        else {
            // 循环播放,重新开始
            this.currentIndex = 0;
            console.log('自动重新开始,索引重置为0');
        }
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.width('100%');
            Stack.height('100%');
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 3. 背景层
            Image.create({ get id() {
                    return typeof __getResourceId__ === "function" ? __getResourceId__(this) : -1;
                }, "type": -1, params: ['app.media.' + this.story[this.currentIndex].bgImage], "bundleName": "com.example.myapplication", "moduleName": "entry" });
            // 3. 背景层
            Image.width('100%');
            // 3. 背景层
            Image.height('100%');
            // 3. 背景层
            Image.objectFit(ImageFit.Cover);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 4. 立绘层 (根据剧本显示)
            if (this.story[this.currentIndex].characterImage !== "") {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ get id() {
                                return typeof __getResourceId__ === "function" ? __getResourceId__(this) : -1;
                            }, "type": -1, params: ['app.media.' + this.story[this.currentIndex].characterImage], "bundleName": "com.example.myapplication", "moduleName": "entry" });
                        Image.width(300);
                        Image.height(500);
                        Image.position({
                            x: '50%',
                            y: '20%'
                        });
                        Image.translate({ x: '-50%' });
                        Image.transition({ type: TransitionType.All, opacity: 1.0, scale: { x: 1.0, y: 1.0 } });
                    }, Image);
                });
            }
            // 5. 对话框层 (底部)
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 5. 对话框层 (底部)
            Column.create();
            // 5. 对话框层 (底部)
            Column.width('100%');
            // 5. 对话框层 (底部)
            Column.height(200);
            // 5. 对话框层 (底部)
            Column.backgroundColor('rgba(0, 0, 0, 0.8)');
            // 5. 对话框层 (底部)
            Column.position({ x: 0, y: '80%' });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.story[this.currentIndex].speaker);
            Text.fontSize(24);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#ff0000');
            Text.layoutWeight(1);
            Text.margin({ left: 20, top: 20 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.countdown}s`);
            Text.fontSize(20);
            Text.fontColor('#FFFF00');
            Text.margin({ right: 20, top: 20 });
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.story[this.currentIndex].text);
            Text.fontSize(18);
            Text.fontColor('#ffffff');
            Text.alignSelf(ItemAlign.Start);
            Text.margin({ left: 20, top: 10, right: 20 });
        }, Text);
        Text.pop();
        // 5. 对话框层 (底部)
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
