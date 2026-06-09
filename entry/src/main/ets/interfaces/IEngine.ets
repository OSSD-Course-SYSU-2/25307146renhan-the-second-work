import { StoryLine, Choice, PlatformConfig, PlatformType } from '../models/DataModels';

export interface IStoryEngine {
  startStory(): void;
  jumpToScene(index: number): void;
  pause(): void;
  resume(): void;
  getCurrentScene(): StoryLine | null;
  getCountdown(): number;
}

export interface IRenderEngine {
  loadBackground(imageName: string): void;
  loadCharacter(imageName: string, isCenter: boolean): void;
  renderDialogue(speaker: string, text: string): void;
  renderCountdown(seconds: number): void;
  clear(): void;
}

export interface IChoiceEngine {
  renderChoices(choices: Choice[]): void;
  handleChoice(index: number): void;
  validateChoiceIndex(index: number, choices: Choice[]): boolean;
  clearChoices(): void;
}

export interface IPlatformAdapter {
  getPlatform(): PlatformType;
  supportsFeature(feature: string): boolean;
  getPlatformConfig(): PlatformConfig;
  buildPackage(): Promise<boolean>;
}