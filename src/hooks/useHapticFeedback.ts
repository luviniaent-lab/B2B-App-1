import { Platform } from 'react-native';

// Mock haptic feedback for web/development
const mockHaptic = {
  impact: () => console.log('Haptic: Impact'),
  selection: () => console.log('Haptic: Selection'),
  notification: () => console.log('Haptic: Notification'),
};

export const useHapticFeedback = () => {
  const impact = (style: 'light' | 'medium' | 'heavy' = 'medium') => {
    if (Platform.OS === 'ios' || Platform.OS === 'android') {
      // In a real React Native app, you would use:
      // import HapticFeedback from 'react-native-haptic-feedback';
      // HapticFeedback.impact(HapticFeedback.ImpactFeedbackStyle[style]);
      mockHaptic.impact();
    }
  };

  const selection = () => {
    if (Platform.OS === 'ios' || Platform.OS === 'android') {
      // HapticFeedback.selection();
      mockHaptic.selection();
    }
  };

  const notification = (type: 'success' | 'warning' | 'error' = 'success') => {
    if (Platform.OS === 'ios' || Platform.OS === 'android') {
      // HapticFeedback.notification(HapticFeedback.NotificationFeedbackType[type]);
      mockHaptic.notification();
    }
  };

  return { impact, selection, notification };
};