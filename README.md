MCH Pink Book – Mobile App

Maternal & Child Health Digital Solution (Nurse + Mother Dashboards)
Built with Flutter + Riverpod + Clean Architecture

📱 Overview

The MCH Pink Book App is a digital maternal and child health platform designed to support nurses, clinics, and mothers throughout the pregnancy and early childhood journey.

This README describes the structure and functionality of the two main dashboards:

Nurse Home Screen – a clinical MCH dashboard for health workers

Mother Home Screen – a personalized health companion for mothers

 Nurse Dashboard
Comprehensive MCH Clinical Dashboard

The NurseHomeScreen provides real-time clinic insights, patient management tools, and ANC/KMC follow-up workflows.

Key Features
✅ AppBar

Display authenticated nurse + clinic details

MFL Code or Clinic Name

Quick actions:

Filters

Notifications

Sync Status

Logout

🔍 Search Bar

Allows nurses to quickly search for mothers, pregnancies, appointments, or children.

📊 Dashboard Sections
1. Clinic Statistics

Displays aggregated:

ANC visits

Deliveries

Children services

Growth monitoring

Immunization stats

2. Today’s Tasks

Shows actionable items for the day:

Scheduled ANC visits

Immunization tasks

Follow-up reminders

3. High-Risk Alerts

Identifies:

High-risk pregnancies

Mothers with complications

Critical alerts requiring immediate attention

4. Active Pregnancies

Filterable by:

All

High Risk

Upcoming

Overdue
Uses Riverpod with dynamic filtering.

5. Defaulters

Mothers who missed:

ANC visits

Growth monitoring

Immunization

6. Immunization Tracker

Shows:

Immunizations due today

Overdue vaccines

Next scheduled dose

🔄 Full Data Refresh

Pull-to-refresh reloads all:

Stats

Pregnancies

Alerts

Defaulters

Tasks

Immunization summaries

Appointments

⚡ Quick Action Floating Button

Shortcuts for:

Add pregnancy

Add child

Add appointment

Register new mother

🤱 Mother Dashboard
Personal Pregnancy & Child Health Home Screen

The MotherHomeScreen helps mothers track appointments, pregnancy progress, and children’s health.

🧭 AppBar

App title

Settings

Notifications

👋 Welcome Card

Shows:

Mother’s name

Number of children

Count of upcoming appointments

“Expecting” pregnancy badge (if active pregnancy exists)

🧩 Profile Completion Prompt

Appears when setup is incomplete:

Encourages mother to complete profile

Navigates to profile screen

 Pregnancy Card

If the mother is pregnant:

Expected delivery date

Quick access to pregnancy journey

ANC visit tracking

 Quick Actions

Grid shortcuts including:

Pregnancy tracking

My Children

Vaccines

Growth charts

 Preferred Clinic

Shows:

Selected clinic

Last visit

Tap to view more (coming soon)

 My Children Section

Displays:

Count

Quick preview

“Add Child” action

📅 Upcoming Appointments

Real data fetched from:

upcomingAppointmentsProvider

Features:

Next appointments

Card layout with date, type, clinic

View All navigation

💡 Health Tips

Useful guidance on:

Breastfeeding

Nutrition

Hygiene

Infant care

⬇️ Bottom Navigation

Tabs:

Home

Children

Appointments

Learn

Profile

🏗 Technical Summary
Architecture

Flutter

Riverpod State Management

Domain-driven separation

Clean Providers + Entities

Modular UI Widgets

Centralized App Constants & Typography

Key Providers Used

authNotifierProvider

clinicStatsProvider

activePregnanciesProvider

highRiskMothersProvider

currentPregnancyProvider

upcomingAppointmentsProvider

Important Helpers

DialogHelpers

Navigation Helpers

Search

FAB Quick Actions

🔄 Refresh Behavior

Nurses → refreshes all clinical data
Mothers → refreshes user data + pregnancy + appointments

All screens use:

RefreshIndicator()

How to Run
Install dependencies:
flutter pub get

Run app:
flutter run

❤️ Contributors

MCH Pink Book Digital Health Team
Ministry of Health + Supporting Partners
