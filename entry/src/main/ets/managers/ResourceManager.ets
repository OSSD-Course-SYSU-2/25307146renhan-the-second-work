import { StoryLine, ResourceMetadata, ResourceType } from '../models/DataModels';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class ResourceManager {
  private resourceLoadTotal: number = 0;
  private resourceLoadSuccess: number = 0;
  private resourceCache: Map<string, Resource> = new Map();

  loadResource(resourceName: string): Resource | null {
    this.resourceLoadTotal++;
    try {
      const resource = $r(`app.media.${resourceName}`);
      this.resourceCache.set(resourceName, resource);
      this.trackResourceLoad(true);
      hilog.info(0x0000, 'ResourceManager', `Resource loaded: ${resourceName}`);
      return resource;
    } catch (error) {
      this.trackResourceLoad(false);
      hilog.error(0x0000, 'ResourceManager', `Failed to load resource: ${resourceName}, error: ${JSON.stringify(error)}`);
      return null;
    }
  }

  preloadResources(story: StoryLine[]): void {
    for (const scene of story) {
      this.loadResource(scene.bgImage);
      if (scene.characterImage) {
        this.loadResource(scene.characterImage);
      }
    }
  }

  getResourceMetadata(resourceName: string): ResourceMetadata | null {
    const resource = this.resourceCache.get(resourceName);
    if (!resource) {
      hilog.error(0x0000, 'ResourceManager', `Resource not found: ${resourceName}`);
      return null;
    }
    return {
      name: resourceName,
      type: ResourceType.IMAGE,
      path: `app.media.${resourceName}`,
      size: 0,
      hash: ''
    };
  }

  trackResourceLoad(success: boolean): void {
    if (success) {
      this.resourceLoadSuccess++;
    }
    const failureRate = (this.resourceLoadTotal - this.resourceLoadSuccess) / this.resourceLoadTotal;
    if (failureRate > 0.005) {
      hilog.warn(0x0000, 'ResourceManager', `Resource load failure rate: ${(failureRate * 100).toFixed(2)}%`);
    }
  }

  getLoadStats(): { total: number, success: number, failureRate: number } {
    const failureRate = this.resourceLoadTotal > 0
      ? (this.resourceLoadTotal - this.resourceLoadSuccess) / this.resourceLoadTotal
      : 0;
    return {
      total: this.resourceLoadTotal,
      success: this.resourceLoadSuccess,
      failureRate
    };
  }
}