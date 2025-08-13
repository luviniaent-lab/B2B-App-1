import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Dimensions,
  ImageBackground,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { GlassCard } from './GlassCard';
import { Property } from '../../types';
import { colors, spacing, borderRadius, textStyles, shadows } from '../../theme';

const { width } = Dimensions.get('window');

interface PropertyCardProps {
  property: Property;
  onPress: () => void;
}

export const PropertyCard: React.FC<PropertyCardProps> = ({ property, onPress }) => {
  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'Club': return '🎵';
      case 'Bar': return '🍸';
      case 'Restaurant': return '🍽️';
      case 'Farmhouse': return '🏡';
      case 'Banquet': return '🎉';
      default: return '🏢';
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'Club': return colors.neonPink;
      case 'Bar': return colors.tertiary;
      case 'Restaurant': return colors.secondary;
      case 'Farmhouse': return colors.neonGreen;
      case 'Banquet': return colors.primary;
      default: return colors.primary;
    }
  };

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.9}>
      <GlassCard style={styles.card} neonBorder>
        <View style={styles.imageContainer}>
          {property.image ? (
            <ImageBackground
              source={{ uri: property.image }}
              style={styles.image}
              imageStyle={styles.imageStyle}
            >
              <LinearGradient
                colors={['transparent', 'rgba(0,0,0,0.8)']}
                style={styles.imageOverlay}
              />
            </ImageBackground>
          ) : (
            <LinearGradient
              colors={[getTypeColor(property.type), colors.background]}
              style={styles.placeholderImage}
            >
              <Text style={styles.placeholderIcon}>
                {getTypeIcon(property.type)}
              </Text>
            </LinearGradient>
          )}
          
          {/* Type Badge */}
          <View style={[styles.typeBadge, { backgroundColor: getTypeColor(property.type) }]}>
            <Text style={styles.typeBadgeText}>{property.type}</Text>
          </View>
          
          {/* Verified Badge */}
          {property.verified && (
            <View style={styles.verifiedBadge}>
              <Text style={styles.verifiedText}>✓</Text>
            </View>
          )}
        </View>

        <View style={styles.content}>
          <Text style={styles.name} numberOfLines={1}>
            {property.name}
          </Text>
          <Text style={styles.location} numberOfLines={1}>
            📍 {property.location}
          </Text>
          
          <View style={styles.stats}>
            {property.occupancy && (
              <View style={styles.stat}>
                <Text style={styles.statIcon}>👥</Text>
                <Text style={styles.statText}>{property.occupancy}</Text>
              </View>
            )}
            {property.totalBookings && (
              <View style={styles.stat}>
                <Text style={styles.statIcon}>📅</Text>
                <Text style={styles.statText}>{property.totalBookings}</Text>
              </View>
            )}
          </View>

          {/* Themes */}
          {property.themes && property.themes.length > 0 && (
            <View style={styles.themes}>
              {property.themes.slice(0, 3).map((theme, index) => (
                <View key={index} style={styles.themeChip}>
                  <Text style={styles.themeText}>{theme}</Text>
                </View>
              ))}
              {property.themes.length > 3 && (
                <Text style={styles.moreThemes}>+{property.themes.length - 3}</Text>
              )}
            </View>
          )}
        </View>
      </GlassCard>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    marginHorizontal: spacing.md,
    marginVertical: spacing.sm,
    width: width - spacing.md * 2,
  },
  imageContainer: {
    height: 180,
    borderRadius: borderRadius.lg,
    overflow: 'hidden',
    marginBottom: spacing.md,
    position: 'relative',
  },
  image: {
    flex: 1,
  },
  imageStyle: {
    borderRadius: borderRadius.lg,
  },
  imageOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: '50%',
  },
  placeholderImage: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: borderRadius.lg,
  },
  placeholderIcon: {
    fontSize: 48,
  },
  typeBadge: {
    position: 'absolute',
    top: spacing.sm,
    left: spacing.sm,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: borderRadius.md,
  },
  typeBadgeText: {
    ...textStyles.caption,
    color: colors.textPrimary,
    fontWeight: '600',
  },
  verifiedBadge: {
    position: 'absolute',
    top: spacing.sm,
    right: spacing.sm,
    width: 24,
    height: 24,
    borderRadius: 12,
    backgroundColor: colors.success,
    justifyContent: 'center',
    alignItems: 'center',
  },
  verifiedText: {
    color: colors.textPrimary,
    fontSize: 12,
    fontWeight: 'bold',
  },
  content: {
    paddingHorizontal: spacing.sm,
  },
  name: {
    ...textStyles.h4,
    color: colors.textPrimary,
    marginBottom: spacing.xs,
  },
  location: {
    ...textStyles.body,
    color: colors.textSecondary,
    marginBottom: spacing.md,
  },
  stats: {
    flexDirection: 'row',
    marginBottom: spacing.md,
  },
  stat: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: spacing.lg,
  },
  statIcon: {
    fontSize: 14,
    marginRight: spacing.xs,
  },
  statText: {
    ...textStyles.caption,
    color: colors.textSecondary,
  },
  themes: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'center',
  },
  themeChip: {
    backgroundColor: colors.glass,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: borderRadius.md,
    marginRight: spacing.xs,
    marginBottom: spacing.xs,
    borderWidth: 1,
    borderColor: colors.primary,
  },
  themeText: {
    ...textStyles.caption,
    color: colors.primary,
    fontSize: 10,
  },
  moreThemes: {
    ...textStyles.caption,
    color: colors.textMuted,
    fontSize: 10,
  },
});