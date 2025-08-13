import React, { useState } from 'react';
import {
  View,
  Text,
  FlatList,
  TextInput,
  StyleSheet,
  SafeAreaView,
  StatusBar,
} from 'react-native';
import { AnimatedBackground } from '../components/ui/AnimatedBackground';
import { GlassCard } from '../components/ui/GlassCard';
import { NeonButton } from '../components/ui/NeonButton';
import { PropertyCard } from '../components/ui/PropertyCard';
import { Property } from '../types';
import { colors, spacing, textStyles, borderRadius } from '../theme';

// Mock data
const mockProperties: Property[] = [
  {
    id: 'p1',
    name: 'Neon Night Club',
    location: 'DLF CyberHub, Gurugram',
    type: 'Club',
    occupancy: 320,
    verified: true,
    totalBookings: 1284,
    themes: ['DJ', 'Bollywood', 'Ladies Night'],
    amenities: ['Parking', 'Valet', 'Dance Floor'],
  },
  {
    id: 'p2',
    name: 'Skybar Rooftop',
    location: 'Connaught Place, Delhi',
    type: 'Bar',
    occupancy: 150,
    verified: true,
    totalBookings: 892,
    themes: ['Jazz', 'Live Band', 'Rooftop'],
    amenities: ['WiFi', 'AC', 'VIP Section'],
  },
];

export const PropertiesScreen: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [properties] = useState<Property[]>(mockProperties);

  const filteredProperties = properties.filter(property =>
    property.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    property.location.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const renderProperty = ({ item }: { item: Property }) => (
    <PropertyCard
      property={item}
      onPress={() => console.log('Navigate to property:', item.id)}
    />
  );

  return (
    <AnimatedBackground>
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="light-content" backgroundColor={colors.background} />
        
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Your Properties</Text>
          <Text style={styles.subtitle}>Manage your venues ✨</Text>
        </View>

        {/* Search Bar */}
        <GlassCard style={styles.searchContainer}>
          <View style={styles.searchBar}>
            <Text style={styles.searchIcon}>🔍</Text>
            <TextInput
              style={styles.searchInput}
              placeholder="Search properties..."
              placeholderTextColor={colors.textMuted}
              value={searchQuery}
              onChangeText={setSearchQuery}
            />
          </View>
          <NeonButton
            title="Add+"
            onPress={() => console.log('Add property')}
            variant="neon"
            size="sm"
            style={styles.addButton}
          />
        </GlassCard>

        {/* Properties List */}
        <FlatList
          data={filteredProperties}
          renderItem={renderProperty}
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
  addButton: {
    alignSelf: 'flex-end',
    minWidth: 80,
  },
  listContainer: {
    paddingBottom: spacing['6xl'],
  },
});