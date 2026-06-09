export enum ResourceType {
  IMAGE = 'image',
  AUDIO = 'audio',
  VIDEO = 'video',
  TEXT = 'text'
}

export enum PlatformType {
  HARMONYOS = 'HarmonyOS',
  ANDROID = 'Android',
  IOS = 'iOS',
  WEB = 'Web'
}

export interface StoryLine {
  text: string;
  speaker: string;
  bgImage: string;
  characterImage: string;
  isCenter: boolean;
  hasChoice: boolean;
}

export interface GameConfig {
  story: StoryLine[];
  countdown: number;
  currentIndex: number;
}

export interface Choice {
  text: string;
  color: string;
  targetIndex: number;
}

export interface ResourceMetadata {
  name: string;
  type: ResourceType;
  path: string;
  size: number;
  hash: string;
}

export interface PlatformConfig {
  platform: PlatformType;
  minVersion: string;
  supportedFeatures: string[];
  parameters: Record<string, string>;
}

export interface ErrorInfo {
  code: number;
  message: string;
  details: string;
  timestamp: number;
  stack?: string;
}

export interface PerformanceMetrics {
  sceneSwitchTime: number;
  characterLoadTime: number;
  backgroundSwitchTime: number;
  appStartTime: number;
  fps: number;
  memoryUsage: number;
}