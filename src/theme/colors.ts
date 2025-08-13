export const colors = {
  // Gen-Z Primary Palette
  primary: '#6E84FF',
  primaryDark: '#5A6FE8',
  primaryLight: '#91A0FF',
  
  // Vibrant Accents
  secondary: '#00E5A8',
  secondaryDark: '#00D6A0',
  tertiary: '#FF6B6B',
  tertiaryDark: '#FF5757',
  
  // Neon Highlights
  neonPink: '#FF10F0',
  neonGreen: '#39FF14',
  neonBlue: '#1B03A3',
  neonYellow: '#FFFF00',
  
  // Dark Theme Base
  background: '#0A0A0F',
  backgroundSecondary: '#121622',
  surface: '#1A2033',
  surfaceLight: '#242A3D',
  
  // Text Colors
  textPrimary: '#E6EAF5',
  textSecondary: '#8892B0',
  textMuted: '#64748B',
  
  // Status Colors
  success: '#00E5A8',
  warning: '#FFB800',
  error: '#FF6B6B',
  info: '#6E84FF',
  
  // Gradients
  gradientPrimary: ['#6E84FF', '#FF6B6B'],
  gradientSecondary: ['#00E5A8', '#6E84FF'],
  gradientNeon: ['#FF10F0', '#39FF14'],
  gradientDark: ['#0A0A0F', '#121622'],
  
  // Glass Effect
  glass: 'rgba(255, 255, 255, 0.1)',
  glassDark: 'rgba(0, 0, 0, 0.3)',
  
  // Shadows
  shadow: 'rgba(110, 132, 255, 0.3)',
  shadowDark: 'rgba(0, 0, 0, 0.5)',
};

export const gradients = {
  primary: {
    colors: colors.gradientPrimary,
    start: { x: 0, y: 0 },
    end: { x: 1, y: 1 },
  },
  secondary: {
    colors: colors.gradientSecondary,
    start: { x: 0, y: 0 },
    end: { x: 1, y: 0 },
  },
  neon: {
    colors: colors.gradientNeon,
    start: { x: 0, y: 0 },
    end: { x: 1, y: 1 },
  },
  dark: {
    colors: colors.gradientDark,
    start: { x: 0, y: 0 },
    end: { x: 0, y: 1 },
  },
};