# EventXchange React Native - Gen-Z Edition 🚀

A modern, immersive React Native mobile app for event management with cutting-edge Gen-Z design aesthetics.

## ✨ Features

### 🎨 Gen-Z Design Elements
- **Neon Color Palette**: Vibrant neons (pink, green, blue, yellow) with dark theme base
- **Glass Morphism**: Frosted glass cards with blur effects
- **Animated Backgrounds**: Floating orbs with smooth animations
- **Gradient Overlays**: Dynamic linear gradients throughout the UI
- **Micro-interactions**: Haptic feedback and smooth transitions

### 🏢 Core Functionality
- **Property Management**: Add, edit, and manage venues
- **Event Creation**: Create and manage events with rich media
- **Booking System**: Handle customer bookings and status updates
- **Offers & Promotions**: Create time-limited offers
- **Agent Management**: Assign and manage venue agents
- **Analytics Dashboard**: Track performance metrics

### 🎯 Modern UX/UI
- **Immersive Navigation**: Floating tab bar with blur effects
- **Smart Cards**: Context-aware property and event cards
- **Dynamic Theming**: Adaptive colors based on content type
- **Smooth Animations**: React Native Reanimated for 60fps animations
- **Haptic Feedback**: Tactile responses for better engagement

## 🛠️ Tech Stack

- **React Native 0.73+** - Latest stable version
- **TypeScript** - Type-safe development
- **React Navigation 6** - Modern navigation patterns
- **Redux Toolkit** - State management
- **React Native Reanimated 3** - High-performance animations
- **React Native Gesture Handler** - Touch interactions
- **Linear Gradient** - Beautiful gradient effects
- **Blur View** - Glass morphism effects
- **Vector Icons** - Scalable icon system
- **Lottie** - Complex animations
- **Fast Image** - Optimized image loading

## 🎨 Design System

### Color Palette
```typescript
// Primary Colors
primary: '#6E84FF'      // Electric Blue
secondary: '#00E5A8'    // Neon Green
tertiary: '#FF6B6B'     // Coral Pink

// Neon Accents
neonPink: '#FF10F0'     // Hot Pink
neonGreen: '#39FF14'    // Lime Green
neonBlue: '#1B03A3'     // Electric Blue
neonYellow: '#FFFF00'   // Bright Yellow

// Dark Base
background: '#0A0A0F'   // Deep Dark
surface: '#1A2033'      // Card Background
```

### Typography
- **Headings**: Bold, high contrast with tight letter spacing
- **Body Text**: Readable with proper line height
- **Captions**: Subtle with reduced opacity
- **Buttons**: Semi-bold with wide letter spacing

### Spacing System
- Based on 4px grid system
- Consistent spacing tokens (xs, sm, md, lg, xl, 2xl, etc.)
- Responsive scaling for different screen sizes

## 🚀 Getting Started

### Prerequisites
- Node.js 16+
- React Native CLI
- Android Studio / Xcode
- iOS Simulator / Android Emulator

### Installation

1. **Clone and setup**
```bash
git clone <repository>
cd EventXchangeRN
npm install
```

2. **iOS Setup**
```bash
cd ios && pod install && cd ..
npx react-native run-ios
```

3. **Android Setup**
```bash
npx react-native run-android
```

## 📱 Screen Architecture

### Main Screens
- **Properties Screen**: Grid/list view of venues with search
- **Events Screen**: Timeline view of events with filters
- **Offers Screen**: Promotional content with countdown timers
- **Bookings Screen**: Status-based booking management
- **Profile Screen**: User settings and analytics

### Component Library
- **GlassCard**: Frosted glass effect container
- **NeonButton**: Gradient buttons with glow effects
- **AnimatedBackground**: Floating orb animations
- **PropertyCard**: Rich venue display cards
- **EventCard**: Event information with media

## 🎭 Animation System

### Micro-interactions
- **Button Press**: Scale animation with haptic feedback
- **Card Hover**: Subtle lift with shadow increase
- **Loading States**: Skeleton screens with shimmer
- **Transitions**: Smooth page transitions with shared elements

### Background Animations
- **Floating Orbs**: Continuous movement with different speeds
- **Gradient Shifts**: Color transitions based on content
- **Parallax Effects**: Depth-based scrolling animations

## 🔧 Customization

### Theme Configuration
```typescript
// src/theme/colors.ts
export const colors = {
  primary: '#YOUR_COLOR',
  // ... customize all colors
};
```

### Component Styling
```typescript
// Each component uses StyleSheet.create()
// Easily customizable through theme tokens
```

## 📊 Performance Optimizations

- **Fast Image**: Optimized image loading and caching
- **Lazy Loading**: Components load on demand
- **Memoization**: React.memo for expensive components
- **Native Driver**: All animations use native driver
- **Bundle Splitting**: Code splitting for faster startup

## 🔮 Future Enhancements

- **AR Integration**: Venue preview in augmented reality
- **Voice Commands**: Voice-controlled navigation
- **AI Recommendations**: Smart event suggestions
- **Social Features**: Share events and venues
- **Offline Mode**: Core functionality without internet

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with 💜 for the Gen-Z generation**

*Featuring cutting-edge design, smooth animations, and an immersive user experience that speaks the language of modern mobile users.*