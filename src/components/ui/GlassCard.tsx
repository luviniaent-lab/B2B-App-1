import React from 'react';
import { View, ViewStyle, StyleSheet } from 'react-native';
import { BlurView } from '@react-native-community/blur';
import { colors, spacing, borderRadius, shadows } from '../../theme';

interface GlassCardProps {
  children: React.ReactNode;
  style?: ViewStyle;
  blurType?: 'light' | 'dark' | 'xlight';
  blurAmount?: number;
  neonBorder?: boolean;
}

export const GlassCard: React.FC<GlassCardProps> = ({
  children,
  style,
  blurType = 'dark',
  blurAmount = 10,
  neonBorder = false,
}) => {
  return (
    <View style={[styles.container, neonBorder && styles.neonBorder, style]}>
      <BlurView
        style={styles.blur}
        blurType={blurType}
        blurAmount={blurAmount}
        reducedTransparencyFallbackColor={colors.surface}
      />
      <View style={styles.content}>
        {children}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    borderRadius: borderRadius.xl,
    overflow: 'hidden',
    backgroundColor: colors.glass,
    ...shadows.lg,
  },
  blur: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  content: {
    padding: spacing.lg,
  },
  neonBorder: {
    borderWidth: 1,
    borderColor: colors.neonPink,
    ...shadows.neon,
  },
});