import React, { useEffect } from 'react';
import { View, StyleSheet, Dimensions, Animated } from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { colors } from '../../theme';

const { width, height } = Dimensions.get('window');

export const AnimatedBackground: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const animatedValue1 = new Animated.Value(0);
  const animatedValue2 = new Animated.Value(0);
  const animatedValue3 = new Animated.Value(0);

  useEffect(() => {
    const createAnimation = (animatedValue: Animated.Value, duration: number) => {
      return Animated.loop(
        Animated.sequence([
          Animated.timing(animatedValue, {
            toValue: 1,
            duration,
            useNativeDriver: true,
          }),
          Animated.timing(animatedValue, {
            toValue: 0,
            duration,
            useNativeDriver: true,
          }),
        ])
      );
    };

    const animation1 = createAnimation(animatedValue1, 8000);
    const animation2 = createAnimation(animatedValue2, 12000);
    const animation3 = createAnimation(animatedValue3, 15000);

    animation1.start();
    animation2.start();
    animation3.start();

    return () => {
      animation1.stop();
      animation2.stop();
      animation3.stop();
    };
  }, []);

  const translateX1 = animatedValue1.interpolate({
    inputRange: [0, 1],
    outputRange: [-width * 0.5, width * 0.5],
  });

  const translateY1 = animatedValue1.interpolate({
    inputRange: [0, 1],
    outputRange: [-height * 0.3, height * 0.3],
  });

  const translateX2 = animatedValue2.interpolate({
    inputRange: [0, 1],
    outputRange: [width * 0.3, -width * 0.3],
  });

  const translateY2 = animatedValue2.interpolate({
    inputRange: [0, 1],
    outputRange: [height * 0.2, -height * 0.2],
  });

  const translateX3 = animatedValue3.interpolate({
    inputRange: [0, 1],
    outputRange: [-width * 0.2, width * 0.4],
  });

  const translateY3 = animatedValue3.interpolate({
    inputRange: [0, 1],
    outputRange: [height * 0.4, -height * 0.1],
  });

  return (
    <View style={styles.container}>
      <LinearGradient
        colors={colors.gradientDark}
        style={styles.background}
      />
      
      {/* Floating Orbs */}
      <Animated.View
        style={[
          styles.orb,
          styles.orb1,
          {
            transform: [
              { translateX: translateX1 },
              { translateY: translateY1 },
            ],
          },
        ]}
      >
        <LinearGradient
          colors={[colors.neonPink, colors.primary]}
          style={styles.orbGradient}
        />
      </Animated.View>

      <Animated.View
        style={[
          styles.orb,
          styles.orb2,
          {
            transform: [
              { translateX: translateX2 },
              { translateY: translateY2 },
            ],
          },
        ]}
      >
        <LinearGradient
          colors={[colors.secondary, colors.neonGreen]}
          style={styles.orbGradient}
        />
      </Animated.View>

      <Animated.View
        style={[
          styles.orb,
          styles.orb3,
          {
            transform: [
              { translateX: translateX3 },
              { translateY: translateY3 },
            ],
          },
        ]}
      >
        <LinearGradient
          colors={[colors.tertiary, colors.neonYellow]}
          style={styles.orbGradient}
        />
      </Animated.View>

      <View style={styles.content}>
        {children}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  background: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  orb: {
    position: 'absolute',
    borderRadius: 100,
    opacity: 0.3,
  },
  orb1: {
    width: 200,
    height: 200,
    top: height * 0.1,
    left: width * 0.1,
  },
  orb2: {
    width: 150,
    height: 150,
    top: height * 0.6,
    right: width * 0.1,
  },
  orb3: {
    width: 120,
    height: 120,
    top: height * 0.3,
    left: width * 0.6,
  },
  orbGradient: {
    flex: 1,
    borderRadius: 100,
  },
  content: {
    flex: 1,
    zIndex: 1,
  },
});