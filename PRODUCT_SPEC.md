# AgentAssist — Real Estate Agent-to-Agent Job Board

## Product Vision

**AgentAssist** is the first mobile-native marketplace connecting real estate agents with vetted, licensed professionals who can help with the tasks that eat up their day — showings, open houses, photography, transaction coordination, and more.

> *"Uber for real estate agent tasks."*

Think of it as the missing middle between doing everything yourself and hiring a full-time assistant. Post a task, get matched with a qualified nearby agent or specialist, and get back to closing deals.

---

## Market Opportunity

### The Problem

- **3 million+ licensed agents** in the U.S., 1.5M+ active NAR members
- Median income is **$58,100** — most agents can't afford a full-time assistant
- **63% are solo agents** juggling showings, paperwork, marketing, and client management
- Agents lose **15-20 hours/week** on non-revenue tasks
- Existing solutions are fragmented: Showami (showings only), Transactly (TC only), generic platforms like Upwork (no RE specialization)
- Median age is **57** — the app must be dead-simple to use

### The Gap

| What Exists | What's Missing |
|---|---|
| Showami — showing assistance only | **Unified marketplace** for ALL agent tasks |
| Transactly — TC only | **Mobile-first** experience (most agents live on their phones) |
| Upwork — generic freelancing | **Licensed agent verification** & real estate context |
| TaskRabbit — consumer tasks | **MLS/CRM integrations** that eliminate double-entry |
| Virtual assistants — $1,500+/mo | **Pay-per-task** pricing accessible to all agents |

### Market Size

- **PropTech agent tools segment**: $6.67B (2025) → $15.51B (2035)
- **U.S. PropTech market**: $24.73B (2026), 18.5% CAGR
- **Serviceable addressable market (SAM)**: ~1.5M active agents × $200/mo avg spend = **$3.6B/yr**
- **Initial target**: Top 10 metro areas, ~300K agents = **$720M/yr SAM**

---

## Target Users

### Primary: The Busy Listing Agent ("The Poster")
- 5-15 years experience, $75K-$200K income
- Handles 15-30+ transactions/year
- Constantly double-booked — needs showing help, open house coverage
- Already spends money on TCs, photographers, stagers
- **Pain**: Time is their #1 bottleneck. Every hour on admin = $$$ lost

### Secondary: The Flexible Agent ("The Helper")
- Newer agents (1-5 years) building experience and income
- Part-time agents with schedule flexibility
- Agents in slower markets wanting supplemental income
- Retired/semi-retired agents still licensed
- **Pain**: Inconsistent deal flow, wants steady supplemental income

### Tertiary: Specialized Freelancers
- Real estate photographers
- Transaction coordinators
- Home stagers
- Marketing specialists (drone, video, social media)

---

## Design System

### Inspiration: Medica UI Kit (Adapted for Real Estate)

Taking cues from the clean, trustworthy Medica health app design:

### Color Palette
| Token | Value | Usage |
|---|---|---|
| `primary-600` | `#1A6AFF` | Primary buttons, active states, links |
| `primary-500` | `#4A8CFF` | Secondary accents, hover states |
| `primary-100` | `#E8F1FF` | Light backgrounds, selected cards |
| `success-500` | `#22C55E` | Task completed, available status |
| `warning-500` | `#F59E0B` | Pending, in-progress states |
| `error-500` | `#EF4444` | Urgent, cancellation, errors |
| `neutral-900` | `#111827` | Primary text |
| `neutral-500` | `#6B7280` | Secondary text |
| `neutral-100` | `#F3F4F6` | Card backgrounds, dividers |
| `white` | `#FFFFFF` | Page backgrounds, card surfaces |
| `dark-bg` | `#1E1E2E` | Dark mode background |
| `dark-card` | `#2A2A3C` | Dark mode card surface |

### Typography (SF Pro / System)
| Style | Size | Weight | Usage |
|---|---|---|---|
| Hero | 32pt | Bold | Onboarding headlines |
| H1 | 24pt | Bold | Screen titles |
| H2 | 20pt | Semibold | Section headers |
| H3 | 16pt | Semibold | Card titles, labels |
| Body | 14pt | Regular | General content |
| Caption | 12pt | Regular | Metadata, timestamps |
| Overline | 10pt | Medium (uppercase) | Category labels, badges |

### Component Library
- **Buttons**: Full-width pill (56pt height, 28pt radius) for primary CTA; outline variant for secondary
- **Cards**: 16pt corner radius, 1px border `neutral-100`, subtle shadow (`0 2px 8px rgba(0,0,0,0.06)`)
- **Avatars**: Circular, 48pt (list), 80pt (profile), blue border for verified agents
- **Chips/Tags**: Rounded pill badges for categories (e.g., "Showing", "Open House", "Photography")
- **Input Fields**: 52pt height, 12pt radius, light gray border, floating labels
- **Bottom Tab Bar**: 5 tabs — Home, Search, Post (+), Messages, Profile
- **Navigation**: Clean top bar with back arrow, right-side action icons
- **Empty States**: Friendly vector illustrations (agent-themed) with CTA button
- **Toast Notifications**: Slide-down with icon, auto-dismiss after 3s
- **Skeleton Loaders**: Animated placeholder cards while content loads

### Dark Mode
Full dark mode support mirroring the Medica dark theme — dark navy backgrounds with maintained blue accent colors and proper contrast ratios (WCAG AA minimum).

### Illustrations Style
Custom flat vector illustrations featuring:
- Diverse real estate agents (suits, blazers, casual professional)
- Houses, keys, "For Sale" signs, open house balloons
- Friendly, approachable, professional tone (not cartoonish)

---

## MVP Feature Set (v1.0)

### 1. Onboarding & Authentication

**Flow** (inspired by Medica):
```
Splash → 3-screen walkthrough → Sign Up/Sign In → Profile Setup → Home
```

**Walkthrough Screens:**
1. "Find help in minutes" — illustration of agent getting matched
2. "Earn on your schedule" — illustration of agent accepting tasks
3. "Trusted & licensed" — illustration of verification badge

**Authentication:**
- Sign in with Apple (required for iOS)
- Sign in with Google
- Email + password
- OTP verification via SMS

**Profile Setup:**
- Full name, photo, phone
- License number + state (verified against state database)
- Brokerage affiliation
- Service area (zip codes / radius)
- Skills & services offered (multi-select)
- Hourly rate / per-task rates
- Bio / experience summary
- Link MLS account (optional, v1 stretch)

### 2. Task Marketplace (Home Screen)

The core experience — a feed of nearby tasks that need help.

**Task Categories (MVP):**
| Category | Icon | Avg Price Range |
|---|---|---|
| Showing Assistance | 🏠 | $40-$100/showing |
| Open House Coverage | 🚪 | $75-$200/session |
| Photography | 📸 | $100-$300/property |
| Transaction Coordination | 📋 | $300-$500/transaction |
| Lockbox/Access | 🔑 | $25-$50/trip |
| Inspection Attendance | 🔍 | $50-$100/inspection |
| Sign Installation | 📍 | $25-$50/install |
| General Admin | 💼 | $25-$50/hour |

**Home Feed:**
- Location-based task cards sorted by proximity + urgency
- Each card shows: Task type chip, address (partial until accepted), date/time, pay, poster avatar + rating
- Filter by: category, distance, date, pay range
- Map view toggle (MapKit)
- Pull-to-refresh, infinite scroll

**Task Detail Screen:**
- Full description
- Property type & details
- Date/time with calendar integration
- Compensation (fixed or hourly)
- Special instructions
- Poster profile (rating, reviews, verification badge)
- "Apply" / "Accept" button (configurable by poster)
- Similar nearby tasks section

### 3. Post a Task

**Quick Post Flow (3 steps):**
1. **What**: Select category → add title & description → upload photos (optional)
2. **When & Where**: Property address → date/time picker → duration estimate
3. **Pay & Preferences**: Set compensation → require license? → auto-accept or review applicants?

**Smart Defaults:**
- Auto-suggest pricing based on category + market rates
- Save frequently posted task types as templates
- Duplicate previous tasks with one tap
- Draft auto-save

### 4. Matching & Acceptance

**Two modes:**
- **Open Board**: Task posted publicly, helpers apply, poster reviews & picks
- **Instant Match**: System auto-matches based on proximity, rating, availability → helper gets push notification → 15 min to accept

**Helper Application:**
- One-tap "I'm Interested" with optional note
- Poster sees helper's profile, rating, distance, availability
- Poster can accept/decline from notification or app

### 5. In-Task Experience

Once matched:
- **In-app messaging** between poster & helper (text + photo)
- **Task status tracker**: Confirmed → En Route → In Progress → Completed
- **Check-in/Check-out**: Helper taps to start/end (optional GPS verification)
- **Photo documentation**: Helper can upload photos (e.g., showing feedback, property condition)
- **Timer** for hourly tasks

### 6. Payments

**MVP Payment Flow:**
- Stripe Connect integration
- Poster funds task when posting (held in escrow)
- Released to helper on task completion
- 2-hour dispute window
- Instant payout option (for fee) via Stripe

**Pricing:**
- Poster sets price (with market rate suggestion)
- Tipping enabled post-task
- Platform fee: 10% from poster, 5% from helper (15% total take rate)

### 7. Ratings & Reviews

**Bidirectional ratings (after each task):**
- 5-star rating
- Written review (optional)
- Quick tags: "On time", "Great communication", "Professional", "Would hire again"
- Ratings visible on profiles
- Minimum 4.5 stars to maintain "Top Helper" badge

### 8. Messaging

- Real-time chat (powered by Firebase/Stream)
- Photo sharing
- Quick-reply suggestions ("On my way", "Running 5 min late", "Task complete")
- Push notifications for new messages
- Chat archived per task

### 9. Profile & Reputation

**Profile includes:**
- Photo, name, brokerage, license (verified badge ✓)
- Star rating + review count
- Badges: "Top Helper", "Super Poster", "Verified License", "Fast Responder"
- Task history (count by category)
- Earnings dashboard (helpers)
- Spend dashboard (posters)
- Availability calendar
- Service radius on map

### 10. Notifications

Card-based notification center (Medica style):
- New task matches in your area
- Application status updates
- Task reminders (30 min before)
- Payment confirmations
- New messages
- Review received
- Weekly earnings summary

---

## Integrations (MVP)

### Must-Have
| Integration | Purpose | API/Method |
|---|---|---|
| **Stripe Connect** | Payments, payouts, escrow | Stripe SDK |
| **Apple Sign-In** | Authentication | AuthenticationServices |
| **Google Sign-In** | Authentication | Google Sign-In SDK |
| **MapKit** | Map views, distance calc | Native iOS |
| **Firebase Cloud Messaging** | Push notifications | Firebase SDK |
| **Apple Calendar** | Task scheduling sync | EventKit |
| **Contacts** | Invite agents you know | ContactsUI |

### High-Value (v1.1)
| Integration | Purpose | API/Method |
|---|---|---|
| **Follow Up Boss** | CRM — sync contacts, tasks | REST API |
| **Dotloop / Skyslope** | Transaction management — auto-create TC tasks | REST API |
| **Canva** | Marketing task templates | Canva Connect API |
| **Google Calendar** | Cross-platform scheduling | Google Calendar API |

### Future (v2+)
| Integration | Purpose |
|---|---|
| **MLS (RESO/Spark)** | Auto-pull listing details for tasks |
| **DocuSign** | E-sign within TC tasks |
| **Zillow/Realtor.com** | Import listing data |
| **QuickBooks** | Expense tracking for helpers |
| **Slack** | Team/brokerage notifications |

---

## Technical Architecture

### Platform
- **iOS native** (Swift / SwiftUI)
- Minimum iOS 16+
- iPhone optimized (iPad adaptive layout future)

### Architecture Pattern
- **MVVM + Coordinator** pattern
- SwiftUI for views
- Combine for reactive data flow
- Swift Concurrency (async/await) for networking

### Backend
- **Firebase** (MVP — fast to ship)
  - Firestore (database)
  - Firebase Auth (authentication)
  - Cloud Functions (business logic, matching algorithm)
  - Cloud Storage (photos)
  - Cloud Messaging (push notifications)
- **Stripe Connect** (payments)
- **Algolia** or Firestore GeoQuery (location search)

### Project Structure
```
AgentAssist/
├── App/
│   ├── AgentAssistApp.swift          # App entry point
│   ├── AppCoordinator.swift          # Navigation coordinator
│   └── ContentView.swift             # Root view
├── Core/
│   ├── Authentication/
│   │   ├── AuthService.swift
│   │   ├── AuthViewModel.swift
│   │   └── Views/
│   │       ├── WelcomeView.swift
│   │       ├── OnboardingCarousel.swift
│   │       ├── SignInView.swift
│   │       ├── SignUpView.swift
│   │       ├── OTPVerificationView.swift
│   │       └── ProfileSetupView.swift
│   ├── TaskMarketplace/
│   │   ├── TaskService.swift
│   │   ├── TaskListViewModel.swift
│   │   ├── TaskDetailViewModel.swift
│   │   └── Views/
│   │       ├── TaskFeedView.swift
│   │       ├── TaskCardView.swift
│   │       ├── TaskDetailView.swift
│   │       ├── TaskMapView.swift
│   │       └── TaskFilterSheet.swift
│   ├── PostTask/
│   │   ├── PostTaskViewModel.swift
│   │   └── Views/
│   │       ├── PostTaskFlow.swift
│   │       ├── TaskCategoryPicker.swift
│   │       ├── TaskDetailsForm.swift
│   │       └── TaskPricingView.swift
│   ├── Messaging/
│   │   ├── ChatService.swift
│   │   ├── ChatViewModel.swift
│   │   └── Views/
│   │       ├── ConversationListView.swift
│   │       └── ChatView.swift
│   ├── Payments/
│   │   ├── PaymentService.swift
│   │   ├── PaymentViewModel.swift
│   │   └── Views/
│   │       ├── PaymentMethodsView.swift
│   │       └── EarningsDashboardView.swift
│   ├── Profile/
│   │   ├── ProfileService.swift
│   │   ├── ProfileViewModel.swift
│   │   └── Views/
│   │       ├── ProfileView.swift
│   │       ├── EditProfileView.swift
│   │       ├── ReviewsListView.swift
│   │       └── BadgesView.swift
│   └── Notifications/
│       ├── NotificationService.swift
│       └── Views/
│           └── NotificationCenterView.swift
├── Shared/
│   ├── Models/
│   │   ├── User.swift
│   │   ├── Task.swift
│   │   ├── Message.swift
│   │   ├── Review.swift
│   │   └── Payment.swift
│   ├── DesignSystem/
│   │   ├── Colors.swift
│   │   ├── Typography.swift
│   │   ├── Components/
│   │   │   ├── PillButton.swift
│   │   │   ├── TaskCard.swift
│   │   │   ├── AvatarView.swift
│   │   │   ├── RatingStars.swift
│   │   │   ├── CategoryChip.swift
│   │   │   ├── InputField.swift
│   │   │   └── EmptyStateView.swift
│   │   └── Illustrations/
│   ├── Extensions/
│   ├── Utilities/
│   └── Networking/
│       ├── FirebaseManager.swift
│       └── StripeManager.swift
├── Resources/
│   ├── Assets.xcassets
│   ├── LaunchScreen.storyboard
│   └── Info.plist
└── Tests/
    ├── UnitTests/
    └── UITests/
```

---

## User Flows

### Flow 1: Poster Creates a Task
```
Home → Tap "+" → Select Category ("Showing Assistance")
→ Enter address, date/time, notes → Set price ($75)
→ Choose "Open Board" → Confirm & Pay → Task posted!
→ Push notification when helper applies
→ Review helper profile → Accept → Chat opens
→ Task day: helper checks in → completes → checks out
→ Payment released → Rate & review
```

### Flow 2: Helper Finds & Completes a Task
```
Home → Browse feed / filter "Showings within 10mi"
→ Tap task card → View details → "I'm Interested"
→ Wait for acceptance → Push: "You've been accepted!"
→ Chat with poster for details → Add to calendar
→ Task day: Tap "En Route" → Arrive → "Check In"
→ Conduct showing → Take notes/photos → "Complete"
→ Payment received → Rate poster
```

### Flow 3: Instant Match
```
Poster posts urgent task ("Need showing coverage in 2 hours")
→ System finds top 5 qualified helpers within radius
→ Push notification to best match → 15 min to accept
→ If declined → next match notified
→ Accepted → Chat opens → Task proceeds
```

---

## Monetization Strategy

### Revenue Streams

1. **Transaction Fee (Primary)**: 15% total (10% poster + 5% helper) — projected $8-12 per task average
2. **Featured Listings**: Posters pay $5-10 to boost task visibility (like Uber surge positioning)
3. **AgentAssist Pro** (Subscription - v1.1):
   - $29/mo for posters: Reduced fees (7%), task templates, priority support, analytics
   - $14/mo for helpers: Featured profile, early access to tasks, instant payout free
4. **Brokerage Plans** (v2): $199/mo per office — team dashboards, bulk posting, agent management

### Unit Economics (Target)
| Metric | Target |
|---|---|
| Avg task value | $85 |
| Platform take | $12.75 (15%) |
| Tasks/poster/month | 8 |
| Tasks/helper/month | 12 |
| Monthly poster value | $10.20 |
| Monthly helper value | $7.65 |
| CAC target | < $25 |
| LTV target (12mo) | > $100 |

---

## Launch Strategy

### Phase 1: Single Market Launch (Months 1-3)
- **Target**: One major metro (Austin, TX or Phoenix, AZ — high agent density, tech-friendly)
- **Seed supply**: Partner with 3-5 brokerages, onboard 200+ agents
- **Seed demand**: Offer first 3 tasks free for posters
- Launch with core categories: Showings, Open Houses, Lockbox Access

### Phase 2: Validate & Expand Categories (Months 3-6)
- Add Photography, Transaction Coordination, Sign Installation
- Expand to 3 additional metros
- Launch Pro subscription
- Target: 2,000 active agents, 500 tasks/week

### Phase 3: Scale (Months 6-12)
- Top 10 metros
- CRM integrations (Follow Up Boss, Dotloop)
- Brokerage partnerships
- Target: 15,000 active agents, 3,000 tasks/week

---

## Success Metrics (MVP)

| Metric | 30-Day Target | 90-Day Target |
|---|---|---|
| Registered agents | 500 | 2,000 |
| Tasks posted | 200 | 1,500 |
| Task completion rate | 70% | 85% |
| Avg time to match | < 4 hours | < 2 hours |
| Helper acceptance rate | 40% | 60% |
| Avg rating | 4.5+ | 4.6+ |
| Repeat poster rate | 30% | 50% |
| NPS | 30+ | 50+ |

---

## Risk Mitigation

| Risk | Mitigation |
|---|---|
| **Chicken-and-egg** (no tasks = no helpers) | Pre-seed both sides with brokerage partnerships; offer poster credits |
| **Disintermediation** (users go off-platform) | Payments, reviews, and insurance only through platform; make it easier to stay |
| **License verification** | Partner with ARELLO or state databases for real-time license validation |
| **Liability** | Helpers act as independent contractors; require E&O insurance; platform ToS |
| **Low initial supply** | Geo-fence to one market; create density before expanding |
| **Trust & safety** | Background checks, license verification, bidirectional reviews, dispute resolution |

---

## What Makes AgentAssist Win

1. **Unified marketplace** — One app for ALL agent tasks (not 5 different apps)
2. **Mobile-native** — Built for agents who live on their phones, not desktop-first
3. **Licensed & verified** — Every helper is a verified, licensed professional
4. **Integrated** — Connects to the tools agents already use (CRM, MLS, calendar)
5. **Beautiful & simple** — Clean, trustworthy design (Medica-inspired) that a 57-year-old agent can navigate instantly
6. **Two-sided value** — Busy agents save time; newer agents earn money. Everyone wins.

---

*AgentAssist: Stop doing it all. Start doing what matters.*
