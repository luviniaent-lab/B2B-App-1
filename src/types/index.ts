export interface Property {
  id: string;
  name: string;
  location: string;
  type: 'Club' | 'Bar' | 'Restaurant' | 'Restaurant & Bar' | 'Farmhouse' | 'Banquet';
  occupancy?: number;
  agentName?: string;
  agentIds?: string[];
  themes?: string[];
  amenities?: string[];
  image?: string;
  media?: string[];
  entryFee?: string;
  entryFee24h?: string;
  entryFeePerHour?: string;
  weekendPrice24h?: string;
  weekendPricePerHour?: string;
  eventPriceDelta?: number;
  priceRangeHours?: string;
  priceRangeDays?: string;
  discountPercent?: number;
  verified?: boolean;
  totalBookings?: number;
}

export interface EventItem {
  id: string;
  title: string;
  date: string;
  startTime?: string;
  price?: string;
  bookingLimit?: number;
  description?: string;
  image?: string;
  video?: string;
  published: boolean;
  status: 'active' | 'past' | 'deactivated';
  bookingsCount?: number;
  propertyIds: string[];
}

export interface Offer {
  id: string;
  name: string;
  description?: string;
  startDate: string;
  endDate: string;
  discountType?: string;
  amount?: string;
  image?: string;
  status: 'active' | 'deactivated';
  bookingsCount?: number;
  propertyIds: string[];
}

export interface Booking {
  id: string;
  eventName: string;
  date: string;
  people: number;
  contact: string;
  status: 'Confirmed' | 'Cancelled' | 'Pending';
  customerName?: string;
  customerEmail?: string;
  price?: string;
  specialRequests?: string;
  isVerified?: boolean;
}

export interface Agent {
  id: string;
  name: string;
  agentId: string;
  password: string;
  avatar?: string;
}

export interface ProfileInfo {
  name: string;
  email: string;
  phone: string;
  aadhaar: string;
  businessId: string;
  address: string;
  companyVerified: boolean;
}

export interface AppState {
  properties: Property[];
  events: EventItem[];
  offers: Offer[];
  bookings: Booking[];
  profile: ProfileInfo;
  agents: Agent[];
}