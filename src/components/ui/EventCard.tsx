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
import { EventItem } from '../../types';
import { colors, spacing, borderRadius, textStyles } from '../../theme';

const { width } = Dimensions.get('window');

interface EventCardProps {
  event: EventItem;
  onPress: () => void;
}

export const EventCard: React.FC<EventCardProps> = ({ event, onPress }) => {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return colors.success;
      case 'past': return colors.textMuted;
      case 'deactivated': return colors.error;
      default: return colors.textMuted;
    }
  };

  const formatDate = (dateStr: string) => {
    // Assuming DDMMYYYY format
    if (dateStr.length === 8) {
      const day = dateStr.substring(0, 2);
      const month = dateStr.substring(2, 4);
      const year = dateStr.substring(4, 8);
      return `${day}/${month}/${year}`;
    }
    return dateStr;
  };

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.9}>
      <GlassCard style={styles.card} neonBorder>
        <View style={styles.imageContainer}>
          {event.image ? (
            <ImageBackground
              source={{ uri: event.image }}
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
              colors={[colors.primary, colors.tertiary]}
              style={styles.placeholderImage}
            >
              <Text style={styles.placeholderIcon}>🎉</Text>
            </LinearGradient>
          )}
          
          {/* Status Badge */}
          <View style={[styles.statusBadge, { backgroundColor: getStatusColor(event.status) }]}>
            <Text style={styles.statusText}>
              {event.published ? 'LIVE' : 'DRAFT'}
            </Text>
          </View>
        </View>

        <View style={styles.content}>
          <Text style={styles.title} numberOfLines={2}>
            {event.title}
          </Text>
          
          {event.description && (
            <Text style={styles.description} numberOfLines={2}>
              {event.description}
            </Text>
          )}
          
          <View style={styles.details}>
            <View style={styles.detailRow}>
              <Text style={styles.detailIcon}>📅</Text>
              <Text style={styles.detailText}>{formatDate(event.date)}</Text>
              {event.startTime && (
                <>
                  <Text style={styles.detailSeparator}>•</Text>
                  <Text style={styles.detailText}>{event.startTime}</Text>
                </>
              )}
            </View>
            
            {(event.price || event.bookingLimit) && (
              <View style={styles.detailRow}>
                {event.price && (
                  <>
                    <Text style={styles.detailIcon}>💰</Text>
                    <Text style={styles.priceText}>{event.price}</Text>
                  </>
                )}
                {event.bookingLimit && (
                  <>
                    {event.price && <Text style={styles.detailSeparator}>•</Text>}
                    <Text style={styles.detailIcon}>👥</Text>
                    <Text style={styles.detailText}>Max {event.bookingLimit}</Text>
                  </>
                )}
              </View>
            )}
          </View>

          {event.bookingsCount !== undefined && (
            <View style={styles.bookingsContainer}>
              <LinearGradient
                colors={[colors.secondary, colors.primary]}
                style={styles.bookingsGradient}
              >
                <Text style={styles.bookingsText}>
                  {event.bookingsCount} bookings
                </Text>
              </LinearGradient>
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
    height: 160,
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
  statusBadge: {
    position: 'absolute',
    top: spacing.sm,
    right: spacing.sm,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: borderRadius.md,
  },
  statusText: {
    ...textStyles.caption,
    color: colors.textPrimary,
    fontWeight: '700',
    fontSize: 10,
  },
  content: {
    paddingHorizontal: spacing.sm,
  },
  title: {
    ...textStyles.h4,
    color: colors.textPrimary,
    marginBottom: spacing.xs,
  },
  description: {
    ...textStyles.body,
    color: colors.textSecondary,
    marginBottom: spacing.md,
    fontSize: 14,
  },
  details: {
    marginBottom: spacing.md,
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.xs,
  },
  detailIcon: {
    fontSize: 14,
    marginRight: spacing.xs,
  },
  detailText: {
    ...textStyles.caption,
    color: colors.textSecondary,
  },
  detailSeparator: {
    ...textStyles.caption,
    color: colors.textMuted,
    marginHorizontal: spacing.xs,
  },
  priceText: {
    ...textStyles.caption,
    color: colors.secondary,
    fontWeight: '600',
  },
  bookingsContainer: {
    alignSelf: 'flex-start',
  },
  bookingsGradient: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: borderRadius.lg,
  },
  bookingsText: {
    ...textStyles.caption,
    color: colors.textPrimary,
    fontWeight: '600',
  },
});