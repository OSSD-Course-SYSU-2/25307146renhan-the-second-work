import { IChoiceEngine } from '../interfaces/IEngine';
import { IStoryEngine } from '../interfaces/IEngine';
import { Choice } from '../models/DataModels';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class ChoiceEngine implements IChoiceEngine {
  private storyEngine: IStoryEngine;
  private onChoicesRender?: (choices: Choice[]) => void;
  private onChoicesClear?: () => void;

  constructor(storyEngine: IStoryEngine, onChoicesRender?: (choices: Choice[]) => void,
    onChoicesClear?: () => void) {
    this.storyEngine = storyEngine;
    this.onChoicesRender = onChoicesRender;
    this.onChoicesClear = onChoicesClear;
  }

  renderChoices(choices: Choice[]): void {
    try {
      if (this.onChoicesRender) {
        this.onChoicesRender(choices);
      }
      hilog.info(0x0000, 'ChoiceEngine', `Choices rendered: ${choices.length}`);
    } catch (error) {
      hilog.error(0x0000, 'ChoiceEngine', `Failed to render choices: ${JSON.stringify(error)}`);
    }
  }

  handleChoice(index: number): void {
    try {
      this.storyEngine.pause();
      hilog.info(0x0000, 'ChoiceEngine', `Choice handled: ${index}`);
    } catch (error) {
      hilog.error(0x0000, 'ChoiceEngine', `Failed to handle choice: ${JSON.stringify(error)}`);
    }
  }

  validateChoiceIndex(index: number, choices: Choice[]): boolean {
    if (index < 0 || index >= choices.length) {
      hilog.error(0x0000, 'ChoiceEngine', `Invalid choice index: ${index}`);
      return false;
    }
    return true;
  }

  clearChoices(): void {
    if (this.onChoicesClear) {
      this.onChoicesClear();
    }
    hilog.info(0x0000, 'ChoiceEngine', 'Choices cleared');
  }
}