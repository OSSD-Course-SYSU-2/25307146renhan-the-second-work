import { IPlatformAdapter } from '../interfaces/IEngine';
import { PlatformConfig, PlatformType } from '../models/DataModels';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class PlatformAdapter implements IPlatformAdapter {
  private platformConfigs: Map<PlatformType, PlatformConfig> = new Map();

  constructor() {
    this.initializePlatformConfigs();
  }

  private initializePlatformConfigs(): void {
    this.platformConfigs.set(PlatformType.HARMONYOS, {
      platform: PlatformType.HARMONYOS,
      minVersion: '5.0.0(12)',
      supportedFeatures: ['advancedAnimation', 'hardwareAcceleration', 'nativeRendering'],
      parameters: {
        'apiVersion': '12',
        'compileSdkVersion': '5.0.2(22)',
        'compatibleSdkVersion': '5.0.0(12)'
      }
    });

    this.platformConfigs.set(PlatformType.ANDROID, {
      platform: PlatformType.ANDROID,
      minVersion: '8.0',
      supportedFeatures: ['basicAnimation', 'hardwareAcceleration'],
      parameters: {
        'minSdkVersion': '26',
        'targetSdkVersion': '34',
        'compileSdkVersion': '34'
      }
    });

    this.platformConfigs.set(PlatformType.IOS, {
      platform: PlatformType.IOS,
      minVersion: '12.0',
      supportedFeatures: ['advancedAnimation', 'hardwareAcceleration', 'nativeRendering'],
      parameters: {
        'minOSVersion': '12.0',
        'targetOSVersion': '17.0'
      }
    });

    this.platformConfigs.set(PlatformType.WEB, {
      platform: PlatformType.WEB,
      minVersion: '1.0',
      supportedFeatures: ['basicAnimation'],
      parameters: {
        'outputFormat': 'html5',
        'resourceCompression': 'enabled'
      }
    });
  }

  getPlatform(): PlatformType {
    return PlatformType.HARMONYOS;
  }

  supportsFeature(feature: string): boolean {
    const platform = this.getPlatform();
    const config = this.platformConfigs.get(platform);
    if (!config) {
      hilog.warn(0x0000, 'PlatformAdapter', `Platform config not found: ${platform}`);
      return false;
    }
    return config.supportedFeatures.includes(feature);
  }

  getPlatformConfig(): PlatformConfig {
    const platform = this.getPlatform();
    const config = this.platformConfigs.get(platform);
    if (!config) {
      hilog.error(0x0000, 'PlatformAdapter', `Platform config not found: ${platform}`);
      return {
        platform: platform,
        minVersion: '1.0',
        supportedFeatures: [],
        parameters: {}
      };
    }
    return config;
  }

  async buildPackage(): Promise<boolean> {
    try {
      hilog.info(0x0000, 'PlatformAdapter', `Building package for platform: ${this.getPlatform()}`);
      return true;
    } catch (error) {
      hilog.error(0x0000, 'PlatformAdapter', `Failed to build package: ${JSON.stringify(error)}`);
      return false;
    }
  }

  checkVersionCompatibility(version: string): boolean {
    const platform = this.getPlatform();
    const config = this.platformConfigs.get(platform);
    if (!config) {
      return false;
    }
    return this.compareVersions(version, config.minVersion) >= 0;
  }

  private compareVersions(version1: string, version2: string): number {
    const v1 = version1.replace(/\(.*\)/, '').split('.').map(Number);
    const v2 = version2.replace(/\(.*\)/, '').split('.').map(Number);
    for (let i = 0; i < Math.max(v1.length, v2.length); i++) {
      const num1 = v1[i] || 0;
      const num2 = v2[i] || 0;
      if (num1 > num2) return 1;
      if (num1 < num2) return -1;
    }
    return 0;
  }
}