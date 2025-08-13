import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { Property, EventItem, Offer, Booking, ProfileInfo, Agent, AppState } from '../../types';

const initialState: AppState = {
  properties: [
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
  ],
  events: [
    {
      id: 'e1',
      title: 'Neon DJ Night',
      date: '15082025',
      startTime: '21:00',
      price: '₹1500',
      bookingLimit: 200,
      description: 'Experience the ultimate DJ night with neon lights and electrifying beats',
      published: true,
      status: 'active',
      bookingsCount: 89,
      propertyIds: ['p1'],
    },
  ],
  offers: [
    {
      id: 'o1',
      name: 'Weekend Special',
      description: 'Get 30% off on weekend bookings',
      startDate: '10082025',
      endDate: '31082025',
      discountType: '%',
      amount: '30',
      status: 'active',
      bookingsCount: 45,
      propertyIds: ['p1', 'p2'],
    },
  ],
  bookings: [
    {
      id: 'b1',
      eventName: 'Neon DJ Night',
      date: '15082025',
      people: 4,
      contact: '+91 98765 43210',
      status: 'Confirmed',
      customerName: 'Rahul Sharma',
      customerEmail: 'rahul@example.com',
      price: '₹6000',
      isVerified: true,
    },
    {
      id: 'b2',
      eventName: 'Rooftop Jazz Evening',
      date: '18082025',
      people: 2,
      contact: '+91 99999 11111',
      status: 'Pending',
      customerName: 'Priya Patel',
      customerEmail: 'priya@example.com',
      price: '₹1600',
      isVerified: false,
    },
  ],
  profile: {
    name: 'Your Name',
    email: 'you@example.com',
    phone: '+91 90000 00000',
    aadhaar: 'XXXX-XXXX-XXXX',
    businessId: 'BIZ-123456',
    address: 'Address line, City, State',
    companyVerified: true,
  },
  agents: [],
};

export const appSlice = createSlice({
  name: 'app',
  initialState,
  reducers: {
    // Properties
    addProperty: (state, action: PayloadAction<Property>) => {
      state.properties.push(action.payload);
    },
    updateProperty: (state, action: PayloadAction<{ id: string; property: Property }>) => {
      const index = state.properties.findIndex(p => p.id === action.payload.id);
      if (index !== -1) {
        state.properties[index] = action.payload.property;
      }
    },
    deleteProperty: (state, action: PayloadAction<string>) => {
      state.properties = state.properties.filter(p => p.id !== action.payload);
    },
    
    // Events
    addEvent: (state, action: PayloadAction<EventItem>) => {
      state.events.push(action.payload);
    },
    updateEvent: (state, action: PayloadAction<{ id: string; event: EventItem }>) => {
      const index = state.events.findIndex(e => e.id === action.payload.id);
      if (index !== -1) {
        state.events[index] = action.payload.event;
      }
    },
    deleteEvent: (state, action: PayloadAction<string>) => {
      state.events = state.events.filter(e => e.id !== action.payload);
    },
    
    // Offers
    addOffer: (state, action: PayloadAction<Offer>) => {
      state.offers.push(action.payload);
    },
    updateOffer: (state, action: PayloadAction<{ id: string; offer: Offer }>) => {
      const index = state.offers.findIndex(o => o.id === action.payload.id);
      if (index !== -1) {
        state.offers[index] = action.payload.offer;
      }
    },
    deleteOffer: (state, action: PayloadAction<string>) => {
      state.offers = state.offers.filter(o => o.id !== action.payload);
    },
    
    // Bookings
    updateBookingStatus: (state, action: PayloadAction<{ id: string; status: 'Confirmed' | 'Cancelled' | 'Pending' }>) => {
      const index = state.bookings.findIndex(b => b.id === action.payload.id);
      if (index !== -1) {
        state.bookings[index].status = action.payload.status;
      }
    },
    
    // Profile
    updateProfile: (state, action: PayloadAction<Partial<ProfileInfo>>) => {
      state.profile = { ...state.profile, ...action.payload };
    },
    
    // Agents
    addAgent: (state, action: PayloadAction<Agent>) => {
      state.agents.push(action.payload);
    },
    updateAgent: (state, action: PayloadAction<{ id: string; agent: Agent }>) => {
      const index = state.agents.findIndex(a => a.id === action.payload.id);
      if (index !== -1) {
        state.agents[index] = action.payload.agent;
      }
    },
    deleteAgent: (state, action: PayloadAction<string>) => {
      state.agents = state.agents.filter(a => a.id !== action.payload);
    },
  },
});

export const {
  addProperty,
  updateProperty,
  deleteProperty,
  addEvent,
  updateEvent,
  deleteEvent,
  addOffer,
  updateOffer,
  deleteOffer,
  updateBookingStatus,
  updateProfile,
  addAgent,
  updateAgent,
  deleteAgent,
} = appSlice.actions;