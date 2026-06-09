import { IRenderEngine } from '../interfaces/IEngine';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class RenderEngine implements IRenderEngine {
  private resourceCache: Map<string, Resource> = new Map();
  private onBackgroundLoad?: (resource: Resource) => void;
  private onCharacterLoad?: (resource: Resource, isCenter: boolean) => void;
  private onDialogueRender?: (speaker: string, text: string) => void;
  private onCountdownRender?: (seconds: number) => void;

  constructor(onBackgroundLoad?: (resource: Resource) => void,
    onCharacterLoad?: (resource: Resource, isCenter: boolean) => void,
    onDialogueRender?: (speaker: string, text: string) => void,
    onCountdownRender?: (seconds: number) => void) {
    this.onBackgroundLoad = onBackgroundLoad;
    this.onCharacterLoad = onCharacterLoad;
    this.onDialogueRender = onDialogueRender;
    this.onCountdownRender = onCountdownRender;
  }

  loadBackground(imageName: string): void {
    try {
      const resource = $r(`app.media.${imageName}`);
      this.resourceCache.set(imageName, resource);
      if (this.onBackgroundLoad) {
        this.onBackgroundLoad(resource);
      }
      hilog.info(0x0000, 'RenderEngine', `Background loaded: ${imageName}`);
    } catch (error) {
      hilog.error(0x0000, 'RenderEngine', `Failed to load background: ${JSON.stringify(error)}`);
    }
  }

  loadCharacter(imageName: string, isCenter: boolean): void {
    try {
      const resource = $r(`app.media.${imageName}`);
      this.resourceCache.set(imageName, resource);
      if (this.onCharacterLoad) {
        this.onCharacterLoad(resource, isCenter);
      }
      hilog.info(0x0000, 'RenderEngine', `Character loaded: ${imageName}, isCenter: ${isCenter}`);
    } catch (error) {
      hilog.error(0x0000, 'RenderEngine', `Failed to load character: ${JSON.stringify(error)}`);
    }
  }

  renderDialogue(speaker: string, text: string): void {
    if (this.onDialogueRender) {
      this.onDialogueRender(speaker, text);
    }
    hilog.info(0x0000, 'RenderEngine', `Dialogue rendered: ${speaker} - ${text}`);
  }

  renderCountdown(seconds: number): void {
    if (this.onCountdownRender) {
      this.onCountdownRender(seconds);
    }
  }

  clear(): void {
    this.resourceCache.clear();
    hilog.info(0x0000, 'RenderEngine', 'Render engine cleared');
  }
}