import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class StateManager {
  private dataPreferences?: preferences.Preferences;

  async init(context: Context) {
    try {
      this.dataPreferences = await preferences.getPreferences(context, 'myStore');
      hilog.info(0x0000, 'StateManager', 'initDataPreferences success');
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'StateManager', `Failed to init preferences. Code is ${code},message is ${message}`);
    }
  }

  async saveGameState(key: string, value: preferences.ValueType) {
    if (!this.dataPreferences) {
      hilog.error(0x0000, 'StateManager', 'saveGameState failed, preferences not initialized');
      return;
    }
    try {
      await this.dataPreferences.put(key, value);
      hilog.info(0x0000, 'StateManager', 'saveGameState success');
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'StateManager', `Failed to save data. Code:${code}, message:${message}`);
    }
  }

  async loadGameState(key: string) {
    if (!this.dataPreferences) {
      hilog.error(0x0000, 'StateManager', 'loadGameState failed, preferences not initialized');
      return;
    }
    try {
      let val = await this.dataPreferences.get(key, 'default');
      hilog.info(0x0000, 'StateManager', `loadGameState success, data:${val}`);
      return val;
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'StateManager', `Failed to load data. Code:${code}, message:${message}`);
    }
  }

  async clearGameState() {
    if (!this.dataPreferences) {
      hilog.error(0x0000, 'StateManager', 'clearGameState failed, preferences not initialized');
      return;
    }
    try {
      await this.dataPreferences.clear();
      hilog.info(0x0000, 'StateManager', 'clearGameState success');
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'StateManager', `Failed to clear data. Code:${code}, message:${message}`);
    }
  }
}