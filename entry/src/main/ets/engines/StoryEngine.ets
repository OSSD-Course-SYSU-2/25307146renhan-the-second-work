import { IStoryEngine } from '../interfaces/IEngine';
import { StoryLine } from '../models/DataModels';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class StoryEngine implements IStoryEngine {
  private story: StoryLine[] = [];
  private currentIndex: number = 0;
  private countdown: number = 5;
  private timerId: number = -1;
  private onSceneChange?: (scene: StoryLine) => void;
  private onCountdownUpdate?: (seconds: number) => void;

  constructor(story: StoryLine[], onSceneChange?: (scene: StoryLine) => void,
    onCountdownUpdate?: (seconds: number) => void) {
    this.story = story;
    this.onSceneChange = onSceneChange;
    this.onCountdownUpdate = onCountdownUpdate;
  }

  startStory(): void {
    try {
      this.currentIndex = 0;
      this.countdown = 5;
      this.startTimer();
      if (this.onSceneChange) {
        this.onSceneChange(this.story[this.currentIndex]);
      }
      hilog.info(0x0000, 'StoryEngine', 'Story started');
    } catch (error) {
      hilog.error(0x0000, 'StoryEngine', `Failed to start story: ${JSON.stringify(error)}`);
    }
  }

  jumpToScene(index: number): void {
    try {
      if (index < 0 || index >= this.story.length) {
        hilog.error(0x0000, 'StoryEngine', `Invalid scene index: ${index}`);
        return;
      }
      this.currentIndex = index;
      this.countdown = 5;
      this.stopTimer();
      if (this.onSceneChange) {
        this.onSceneChange(this.story[this.currentIndex]);
      }
      hilog.info(0x0000, 'StoryEngine', `Jumped to scene ${index}`);
    } catch (error) {
      hilog.error(0x0000, 'StoryEngine', `Failed to jump to scene: ${JSON.stringify(error)}`);
    }
  }

  pause(): void {
    this.stopTimer();
    hilog.info(0x0000, 'StoryEngine', 'Story paused');
  }

  resume(): void {
    this.startTimer();
    hilog.info(0x0000, 'StoryEngine', 'Story resumed');
  }

  getCurrentScene(): StoryLine | null {
    if (this.currentIndex < 0 || this.currentIndex >= this.story.length) {
      return null;
    }
    return this.story[this.currentIndex];
  }

  getCountdown(): number {
    return this.countdown;
  }

  private startTimer(): void {
    if (this.timerId === -1) {
      this.countdown = 5;
      this.timerId = setInterval(() => {
        this.countdown--;
        if (this.onCountdownUpdate) {
          this.onCountdownUpdate(this.countdown);
        }
        if (this.countdown <= 0) {
          this.autoNextDialogue();
          this.countdown = 5;
        }
      }, 1000);
    }
  }

  private stopTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  private autoNextDialogue(): void {
    if (this.currentIndex < this.story.length - 1) {
      this.currentIndex++;
      if (this.onSceneChange) {
        this.onSceneChange(this.story[this.currentIndex]);
      }
    } else {
      this.currentIndex = 0;
      if (this.onSceneChange) {
        this.onSceneChange(this.story[this.currentIndex]);
      }
    }
  }
}