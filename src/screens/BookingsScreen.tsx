import React, { useState } from 'react';
import {
  View,
  Text,
  FlatList,
  StyleSheet,
  SafeAreaView,
  StatusBar,
  TouchableOpacity,
} from 'react-native';
import { useAppSelector, useAppDispatch } from '../hooks';
import { AnimatedBackground } from '../components/ui/AnimatedBackground';
import { GlassCard } from '../components/ui/GlassCard';
import { BookingCard } from '../components/ui/BookingCard';
import { updateBookingStatus } from '../store/slices/appSlice';
import { Booking } from '../types';
import { colors, spacing, textStyles, borderRadius } from '../theme';


export const BookingsScreen: React.FC = () => {
  const bookings = useAppSelector(state => state.app.bookings);
  const dispatch = useAppDispatch();
  const [statusFilter, setStatusFilter] = useState<'all' | 'Confirmed' | 'Pending' | 'Cancelled'>('all');

  const filteredBookings = bookings.filter(booking => 
    statusFilter === 'all' || booking.status === statusFilter
  );

  const getStatusCounts = () => {
    return {
      all: bookings.length,
      confirmed: bookings.filter(b => b.status === 'Confirmed').length,
      pending: bookings.filter(b => b.status === 'Pending').length,
      cancelled: bookings.filter(b => b.status === 'Cancelled').length,
    };
  };

  const statusCounts = getStatusCounts();

  const renderBooking = ({ item }: { item: Booking }) => (
    <BookingCard
      booking={item}
      onPress={() => console.log('View booking details:', item.id)}
      onStatusChange={(newStatus) => dispatch(updateBookingStatus({ id: item.id, status: newStatus }))}
    />
  );

  const getFilterColor = (status: string) => {
    switch (status) {
      case 'Confirmed': return colors.success;
      case 'Pending': return colors.warning;
      case 'Cancelled': return colors.error;
      default: return colors.primary;
    }
  };

  return (
    <AnimatedBackground>
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" backgroundColor={colors.background} />
        
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Bookings</Text>
          <Text style={styles.subtitle}>Manage reservations 📅</Text>
        </View>

        {/* Status Filter */}
        <GlassCard style={styles.filterContainer}>
          <Text style={styles.filterLabel}>Filter by Status</Text>
          <View style={styles.filterChips}>
            {[
              { key: 'all', label: 'All', count: statusCounts.all },
              { key: 'Confirmed', label: 'Confirmed', count: statusCounts.confirmed },
              { key: 'Pending', label: 'Pending', count: statusCounts.pending },
              { key: 'Cancelled', label: 'Cancelled', count: statusCounts.cancelled },
            ].map((filter) => (
              <TouchableOpacity
                key={filter.key}
                style={[
                  styles.filterChip,
                  statusFilter === filter.key && [
                    styles.filterChipActive,
                    { borderColor: getFilterColor(filter.key) }
                  ]
                ]}
                onPress={() => setStatusFilter(filter.key as any)}
              >
                <Text style={[
                  styles.filterChipText,
                  statusFilter === filter.key && [
                    styles.filterChipTextActive,
                    { color: getFilterColor(filter.key) }
                  ]
                ]}>
                  {filter.label} ({filter.count})
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </GlassCard>

        {/* Bookings List */}
        <FlatList
          data={filteredBookings}
          renderItem={renderBooking}
          keyExtractor={(item) => item.id}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={styles.listContainer}
        />
      </SafeAreaView>
    </AnimatedBackground>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.xl,
    paddingBottom: spacing.lg,
  },
  title: {
    ...textStyles.h1,
    color: colors.textPrimary,
    textAlign: 'center',
    marginBottom: spacing.xs,
  },
  subtitle: {
    ...textStyles.body,
    color: colors.textSecondary,
    textAlign: 'center',
  },
  filterContainer: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.lg,
  },
  filterLabel: {
    ...textStyles.body,
    color: colors.textPrimary,
    fontWeight: '600',
    marginBottom: spacing.sm,
  },
  filterChips: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  filterChip: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.lg,
    backgroundColor: colors.surface,
    marginRight: spacing.sm,
    marginBottom: spacing.sm,
    borderWidth: 1,
    borderColor: colors.textMuted,
  },
  filterChipActive: {
    backgroundColor: colors.glass,
  },
  filterChipText: {
    ...textStyles.caption,
    color: colors.textSecondary,
    fontWeight: '600',
  },
  filterChipTextActive: {
    fontWeight: '700',
  },
  listContainer: {
    paddingBottom: spacing['6xl'],
  },
});