import React, { useState } from 'react';
import {
  View,
  Text,
  FlatList,
  TextInput,
  StyleSheet,
  SafeAreaView,
  StatusBar,
  TouchableOpacity,
  Modal,
} from 'react-native';
import { useAppSelector } from '../hooks/useAppSelector';
import { AnimatedBackground } from '../components/ui/AnimatedBackground';
import { GlassCard } from '../components/ui/GlassCard';
import { NeonButton } from '../components/ui/NeonButton';
import { EventCard } from '../components/ui/EventCard';
import { EventForm } from '../components/forms/EventForm';
import { EventItem } from '../types';
import { colors, spacing, textStyles, borderRadius } from '../theme';


export const EventsScreen: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const events = useAppSelector(state => state.app.events);
  const [showCreateModal, setShowCreateModal] = useState(false);

  const filteredEvents = events.filter(event =>
    event.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
    event.date.includes(searchQuery)
  );

  const renderEvent = ({ item }: { item: EventItem }) => (
    <EventCard
      event={item}
      onPress={() => console.log('Navigate to event:', item.id)}
    />
  );

  const handleCreateEvent = (eventData: Partial<EventItem>) => {
    console.log('Create event:', eventData);
    setShowCreateModal(false);
  };

  return (
    <AnimatedBackground>
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" backgroundColor={colors.background} />
        
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Events</Text>
          <Text style={styles.subtitle}>Manage your events 🎉</Text>
        </View>

        {/* Search Bar */}
        <GlassCard style={styles.searchContainer}>
          <View style={styles.searchBar}>
            <Text style={styles.searchIcon}>🔍</Text>
            <TextInput
              style={styles.searchInput}
              placeholder="Search events..."
              placeholderTextColor={colors.textMuted}
              value={searchQuery}
              onChangeText={setSearchQuery}
            />
          </View>
          <NeonButton
            title="Create+"
            onPress={() => setShowCreateModal(true)}
            variant="secondary"
            size="sm"
            style={styles.createButton}
          />
        </GlassCard>

        {/* Events List */}
        <FlatList
          data={filteredEvents}
          renderItem={renderEvent}
          keyExtractor={(item) => item.id}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={styles.listContainer}
        />

        {/* Create Event Modal */}
        <Modal
          visible={showCreateModal}
          animationType="slide"
          presentationStyle="pageSheet"
          onRequestClose={() => setShowCreateModal(false)}
        >
          <SafeAreaView style={styles.modalContainer}>
            <View style={styles.modalHeader}>
              <TouchableOpacity onPress={() => setShowCreateModal(false)}>
                <Text style={styles.cancelButton}>Cancel</Text>
              </TouchableOpacity>
              <Text style={styles.modalTitle}>Create Event</Text>
              <View style={styles.placeholder} />
            </View>
            <EventForm onSubmit={handleCreateEvent} />
          </SafeAreaView>
        </Modal>
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
  searchContainer: {
    marginHorizontal: spacing.lg,
    marginBottom: spacing.lg,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: borderRadius.lg,
    paddingHorizontal: spacing.md,
    marginBottom: spacing.md,
  },
  searchIcon: {
    fontSize: 18,
    marginRight: spacing.sm,
  },
  searchInput: {
    flex: 1,
    ...textStyles.body,
    color: colors.textPrimary,
    paddingVertical: spacing.md,
  },
  createButton: {
    alignSelf: 'flex-end',
    minWidth: 100,
  },
  listContainer: {
    paddingBottom: spacing['6xl'],
  },
  modalContainer: {
    flex: 1,
    backgroundColor: colors.background,
  },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    borderBottomWidth: 1,
    borderBottomColor: colors.surface,
  },
  modalTitle: {
    ...textStyles.h3,
    color: colors.textPrimary,
  },
  cancelButton: {
    ...textStyles.body,
    color: colors.primary,
  },
  placeholder: {
    width: 60,
  },
});