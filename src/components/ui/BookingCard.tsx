import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Dimensions,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { GlassCard } from './GlassCard';
import { NeonButton } from './NeonButton';
import { Booking } from '../../types';
import { colors, spacing, borderRadius, textStyles } from '../../theme';

const { width } = Dimensions.get('window');

interface BookingCardProps {
  booking: Booking;
  onPress: () => void;
  onStatusChange: (status: 'Confirmed' | 'Cancelled' | 'Pending') => void;
}

export const BookingCard: React.FC<BookingCardProps> = ({ 
  booking, 
  onPress, 
  onStatusChange 
}) => {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'Confirmed': return colors.success;
      case 'Pending': return colors.warning;
      case 'Cancelled': return colors.error;
      default: return colors.textMuted;
    }
  };

  const formatDate = (dateStr: string) => {
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
      <GlassCard style={styles.card}>
        <View style={styles.header}>
          <View style={styles.statusContainer}>
            <View style={[styles.statusDot, { backgroundColor: getStatusColor(booking.status) }]} />
            <Text style={[styles.statusText, { color: getStatusColor(booking.status) }]}>
              {booking.status}
            </Text>
          </View>
          {booking.isVerified && (
            <View style={styles.verifiedBadge}>
              <Text style={styles.verifiedText}>✓ Verified</Text>
            </View>
          )}
        </View>

        <View style={styles.content}>
          <Text style={styles.eventName} numberOfLines={1}>
            {booking.eventName}
          </Text>
          
          <View style={styles.details}>
            <View style={styles.detailRow}>
              <Text style={styles.detailIcon}>📅</Text>
              <Text style={styles.detailText}>{formatDate(booking.date)}</Text>
            </View>
            
            <View style={styles.detailRow}>
              <Text style={styles.detailIcon}>👥</Text>
              <Text style={styles.detailText}>{booking.people} people</Text>
            </View>
            
            <View style={styles.detailRow}>
              <Text style={styles.detailIcon}>📞</Text>
              <Text style={styles.detailText}>{booking.contact}</Text>
            </View>

            {booking.customerName && (
              <View style={styles.detailRow}>
                <Text style={styles.detailIcon}>👤</Text>
                <Text style={styles.detailText}>{booking.customerName}</Text>
              </View>
            )}

            {booking.price && (
              <View style={styles.detailRow}>
                <Text style={styles.detailIcon}>💰</Text>
                <Text style={styles.priceText}>{booking.price}</Text>
              </View>
            )}
          </View>

          {/* Action Buttons */}
          {booking.status !== 'Confirmed' && booking.status !== 'Cancelled' && (
            <View style={styles.actions}>
              <NeonButton
                title="Confirm"
                onPress={() => onStatusChange('Confirmed')}
                variant="secondary"
                size="sm"
                style={styles.actionButton}
              />
              <NeonButton
                title="Cancel"
                onPress={() => onStatusChange('Cancelled')}
                variant="ghost"
                size="sm"
                style={styles.actionButton}
              />
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
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  statusContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  statusDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    marginRight: spacing.xs,
  },
  statusText: {
    ...textStyles.caption,
    fontWeight: '700',
  },
  verifiedBadge: {
    backgroundColor: colors.success,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: borderRadius.md,
  },
  verifiedText: {
    ...textStyles.caption,
    color: colors.textPrimary,
    fontWeight: '600',
    fontSize: 10,
  },
  content: {
    paddingHorizontal: spacing.sm,
  },
  eventName: {
    ...textStyles.h4,
    color: colors.textPrimary,
    marginBottom: spacing.md,
  },
  details: {
    marginBottom: spacing.lg,
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  detailIcon: {
    fontSize: 14,
    marginRight: spacing.sm,
    width: 20,
  },
  detailText: {
    ...textStyles.body,
    color: colors.textSecondary,
    flex: 1,
  },
  priceText: {
    ...textStyles.body,
    color: colors.secondary,
    fontWeight: '600',
    flex: 1,
  },
  actions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  actionButton: {
    flex: 1,
    marginHorizontal: spacing.xs,
  },
});