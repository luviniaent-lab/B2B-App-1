import { TextStyle } from 'react-native';

export const typography = {
  // Font Families
  primary: 'System',
  secondary: 'System',
  mono: 'Courier New',
  
  // Font Sizes
  xs: 12,
  sm: 14,
  base: 16,
  lg: 18,
  xl: 20,
  '2xl': 24,
  '3xl': 30,
  '4xl': 36,
  '5xl': 48,
  '6xl': 60,
  
  // Font Weights
  thin: '100' as TextStyle['fontWeight'],
  light: '300' as TextStyle['fontWeight'],
  normal: '400' as TextStyle['fontWeight'],
  medium: '500' as TextStyle['fontWeight'],
  semibold: '600' as TextStyle['fontWeight'],
  bold: '700' as TextStyle['fontWeight'],
  extrabold: '800' as TextStyle['fontWeight'],
  black: '900' as TextStyle['fontWeight'],
  
  // Line Heights
  lineHeight: {
    tight: 1.2,
    normal: 1.5,
    relaxed: 1.75,
  },
  
  // Letter Spacing
  letterSpacing: {
    tight: -0.5,
    normal: 0,
    wide: 0.5,
    wider: 1,
  },
};

export const textStyles = {
  h1: {
    fontSize: typography['5xl'],
    fontWeight: typography.black,
    lineHeight: typography['5xl'] * typography.lineHeight.tight,
    letterSpacing: typography.letterSpacing.tight,
  },
  h2: {
    fontSize: typography['4xl'],
    fontWeight: typography.bold,
    lineHeight: typography['4xl'] * typography.lineHeight.tight,
  },
  h3: {
    fontSize: typography['3xl'],
    fontWeight: typography.bold,
    lineHeight: typography['3xl'] * typography.lineHeight.normal,
  },
  h4: {
    fontSize: typography['2xl'],
    fontWeight: typography.semibold,
    lineHeight: typography['2xl'] * typography.lineHeight.normal,
  },
  body: {
    fontSize: typography.base,
    fontWeight: typography.normal,
    lineHeight: typography.base * typography.lineHeight.normal,
  },
  bodyLarge: {
    fontSize: typography.lg,
    fontWeight: typography.normal,
    lineHeight: typography.lg * typography.lineHeight.normal,
  },
  caption: {
    fontSize: typography.sm,
    fontWeight: typography.normal,
    lineHeight: typography.sm * typography.lineHeight.normal,
  },
  button: {
    fontSize: typography.base,
    fontWeight: typography.semibold,
    letterSpacing: typography.letterSpacing.wide,
  },
};