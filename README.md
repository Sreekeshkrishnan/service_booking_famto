# Famto Mini Service Booking Flow - Flutter Developer Technical Assignment

A clean, modern, and production-ready Flutter application built for the **Famto Technical Assignment**. The app demonstrates an end-to-end service booking experience featuring a modern design system, local data management, strict form validation, responsive UI, and state management using the **Provider** pattern.

---

## 🌟 Key Features & User Flow

### Step 1: Home & Service Selection (`HomeScreen`)
* **Location Bar & Search Header**: Interactive location selector and real-time live search filter.
* **Promotional Banner**: Highlighting active promo codes (e.g. `FAMTO20`).
* **Category Filters**: Horizontal scrollable categories (AC Repair, Deep Cleaning, Plumbing, Electrical, Beauty & Wellness) with dynamic service filtering.
* **Service Cards**: Displays pricing, original price strike-through, discount percentage badge, ratings, and execution duration.
* **Service Details Bottom Sheet**: Explains inclusions, detailed breakdown, and direct "Book Now" CTA.

### Step 2: Customisation & Schedule (`BookingCustomizationScreen`)
* **Add-ons Customisation**: Toggleable service add-ons (e.g. Anti-Rust Coating, Extra sofa shampooing) with instant price calculation.
* **Date Selection Strip**: Interactive calendar strip (Today, Tomorrow, and upcoming dates).
* **Time Slot Grid**: Morning, Afternoon, and Evening slots with availability status.
* **Address Management**: Select from saved addresses or add new addresses via a modal form.

### Step 3: Checkout & Review (`CheckoutScreen`)
* **Contact Information Form**: Built-in strict form validation for:
  * **Full Name**: Non-empty, minimum 3 characters.
  * **Mobile Phone**: Mandatory 10-digit numeric validation.
  * **Email**: RFC-compliant regex email validation.
* **Promo Code Engine**: Test codes like `FAMTO20` (20% OFF up to ₹200) or `WELCOME50` with minimum order amount validations and real-time discount deduction.
* **Itemised Pricing Summary**: Transparent breakup of base price, add-ons total, platform convenience fee, taxes (5% GST), and coupon discounts.
* **Payment Selector**: Online UPI/Card vs Cash on Delivery (Pay After Service).

### Step 4: Booking Confirmation (`BookingConfirmationScreen`)
* Animated checkmark success screen.
* Unique generated Booking Reference ID (e.g., `FAMTO-89321`).
* Full summary of scheduled slot, delivery address, contact details, and payment method.
* One-click navigation to **My Bookings** or **Home**.

### Step 5: Booking History & Management (`BookingHistoryScreen`)
* **Tabbed Navigation**: Active Bookings vs Past History.
* **Booking Cancellation**: Ability to cancel active bookings with confirmation modal dialogs.
* **Booking Details Modal**: Re-examine full receipt and details anytime.

---

## 🧠 State Management Explanation

This project implements the **Provider** pattern using `ChangeNotifier` to maintain clean separation of concerns:

1. **`ServiceProvider`**:
   * **Responsibility**: Manages categories, active search queries, and dynamic filtering of the service catalog.
   * **Why**: Keeps search and filter state decoupled from UI widgets so list renders remain fast and predictable.

2. **`BookingProvider`**:
   * **Responsibility**: Manages the lifecycle of a booking draft (selected service, add-ons, date, slot, delivery address, promo code, discounts, and payment method).
   * **Calculated Properties**: Exposes getters for `subtotal`, `addonsTotalPrice`, `discountAmount`, `taxesAmount`, and `grandTotal`. Re-calculates totals reactively whenever add-ons or promo codes change.
   * **Persistence & History**: Manages saved addresses and the list of active/past bookings.

---

## 📁 Project Architecture & Folder Structure

```
lib/
├── main.dart                      # App entrypoint & MultiProvider setup
├── theme/
│   └── app_theme.dart             # Famto brand colors, typography, theme data
├── models/
│   ├── service_model.dart         # Category, ServiceItem, ServiceAddon models
│   ├── booking_model.dart         # BookingModel, TimeSlot, PromoCode, BookingStatus
│   └── user_address_model.dart    # UserAddress, ContactInfo models
├── data/
│   └── mock_data.dart             # Local mock data repository (Services, Promos, Slots)
├── providers/
│   ├── service_provider.dart      # Catalog & search state management
│   └── booking_provider.dart      # Draft booking, checkout calculation & order history
├── widgets/
│   ├── custom_button.dart         # Primary / Outlined action buttons
│   ├── custom_text_field.dart     # Validated text input fields
│   ├── price_summary_card.dart    # Itemised price breakup widget
│   ├── status_badge.dart          # Booking status chip (Confirmed, Completed, Cancelled)
│   └── add_address_dialog.dart    # Dialog form for creating new addresses
└── screens/
    ├── main_navigation_screen.dart# Shell with BottomNavigationBar
    ├── home/
    │   ├── home_screen.dart       # Home tab with location, search, banners, categories
    │   └── service_details_bottom_sheet.dart # Inclusions & details sheet
    ├── booking/
    │   ├── booking_customization_screen.dart # Step 2: Add-ons, Date, Time Slot, Address
    │   ├── checkout_screen.dart   # Step 3: Contact validation, Promo code, Summary
    │   └── booking_confirmation_screen.dart # Step 4: Success confirmation screen
    ├── history/
    │   └── booking_history_screen.dart # Step 5: Active & Past booking tabs
    └── profile/
        └── profile_screen.dart    # Saved addresses & State Architecture overview
```

---

## 🚀 How to Run the App

1. **Ensure Flutter SDK is installed**:
   ```bash
   flutter --version
   ```

2. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Widget Tests**:
   ```bash
   flutter test
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

---

## 🎟️ Test Promo Codes
* **`FAMTO20`**: 20% OFF up to ₹200 (Min order: ₹300)
* **`WELCOME50`**: 25% OFF up to ₹150 (Min order: ₹499)
* **`CLEAN30`**: 30% OFF up to ₹300 (Min order: ₹800)
