# Swapify
## Student Skill Exchange Platform

**Swapify** is a mobile application that enables students to exchange skills with one another without using money. The platform focuses on peer-to-peer learning and collaboration.

---

## Concept

Users offer skills they have and exchange them with skills they want to learn.

**Example:**
- Teaching UI Design  
- Learning Flutter  

---

## User Flow

Login → Setup Profile → Browse → Request Swap → Accept → Chat → Complete → Rating

---

## Core Features

### User Profile
- Name
- Bio
- Skills Offered
- Skills Wanted
- Skill proficiency
- Certificates (S3-compatible storage)
- User rating

---

### Browse & Matching
- Discover users based on skills
- View skills offered and wanted
- Filter by category (e.g. Design, Development, Language)

---

### Swap Request System
- Send skill exchange requests

**Status:**
- Pending  
- Active  
- Done  

---

### Messaging
- One-to-one chat
- Available only after request is accepted

---

### Notifications
- New request received
- Request accepted / rejected
- Swap completed

---

### Rating System
- Available after swap is completed
- Rating: 1–5
- Optional comment
- Affects user’s overall rating

---

### Subscription System

**Free User**
- Maximum 2 active swap requests
- Cannot edit profile

**Premium User**
- Unlimited swap requests
- Full profile editing access

---

## Application Pages

- Splash Screen
- Login Page
- Setup Profile
- Home (Browse Users)
- User Profile
- Request Swap
- Requests (Pending / Active / Done)
- Messages
- Notifications
- Profile

---

## Navigation

- Home
- Requests
- Messages
- Notifications
- Profile

---

## Tech Stack (Planned)

| Layer     | Technology            |
|-----------|----------------------|
| Frontend  | Flutter              |
| Backend   | Node.js + Express    |
| Database  | Not yet implemented  |
| Storage   | MinIO (S3-compatible)|
| Auth      | Google OAuth         |

---

## Project Structure
├── frontend/ # Flutter mobile app
├── backend/ # Node.js API
└── README.md

---

## Project Status

- Database not yet implemented
- Backend in early development

---

## Objective

To provide a platform for students to exchange skills without financial barriers, using a structured request and rating system.
