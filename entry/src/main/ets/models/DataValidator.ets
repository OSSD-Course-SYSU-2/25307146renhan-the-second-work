import { StoryLine, GameConfig, Choice, ResourceMetadata } from './DataModels';

export interface ValidationResult {
  valid: boolean;
  errors: string[];
}

export class DataValidator {
  static validateStoryLine(storyLine: StoryLine): ValidationResult {
    const errors: string[] = [];

    if (!storyLine.text || storyLine.text.trim().length === 0) {
      errors.push('text cannot be empty');
    }

    if (!storyLine.speaker || storyLine.speaker.trim().length === 0) {
      errors.push('speaker cannot be empty');
    }

    if (!storyLine.bgImage || storyLine.bgImage.trim().length === 0) {
      errors.push('bgImage cannot be empty');
    }

    if (storyLine.text && storyLine.text.length > 500) {
      errors.push('text length cannot exceed 500 characters');
    }

    if (storyLine.speaker && storyLine.speaker.length > 50) {
      errors.push('speaker length cannot exceed 50 characters');
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }

  static validateGameConfig(gameConfig: GameConfig): ValidationResult {
    const errors: string[] = [];

    if (!gameConfig.story || gameConfig.story.length === 0) {
      errors.push('story cannot be empty');
    }

    if (gameConfig.countdown <= 0 || gameConfig.countdown > 60) {
      errors.push('countdown must be between 1 and 60 seconds');
    }

    if (gameConfig.currentIndex < 0) {
      errors.push('currentIndex cannot be negative');
    }

    if (gameConfig.story && gameConfig.currentIndex >= gameConfig.story.length) {
      errors.push('currentIndex cannot exceed story length');
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }

  static validateChoice(choice: Choice): ValidationResult {
    const errors: string[] = [];

    if (!choice.text || choice.text.trim().length === 0) {
      errors.push('choice text cannot be empty');
    }

    if (!choice.color || choice.color.trim().length === 0) {
      errors.push('choice color cannot be empty');
    }

    if (choice.targetIndex < 0) {
      errors.push('targetIndex cannot be negative');
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }

  static validateResourceMetadata(metadata: ResourceMetadata): ValidationResult {
    const errors: string[] = [];

    if (!metadata.name || metadata.name.trim().length === 0) {
      errors.push('resource name cannot be empty');
    }

    if (!metadata.type) {
      errors.push('resource type cannot be empty');
    }

    if (!metadata.path || metadata.path.trim().length === 0) {
      errors.push('resource path cannot be empty');
    }

    if (metadata.size <= 0) {
      errors.push('resource size must be positive');
    }

    if (!metadata.hash || metadata.hash.trim().length === 0) {
      errors.push('resource hash cannot be empty');
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }
}