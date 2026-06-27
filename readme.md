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

## Tech Stack

| Layer     | Technology            |
|-----------|----------------------|
| Frontend  | Flutter              |
| Backend   | NestJS               |
| Database  | SQLite               |
| Storage   | Local File Storage (`/uploads/`) |
| Auth      | Google OAuth (Dev Mode using `dev-test-token`) |

---

## Project Structure
├── frontend/ # Flutter app (Mobile & Web)
├── backend/ # NestJS API + SQLite Database
└── README.md

---

## Project Status

- **Integration Completed**: Flutter frontend and NestJS backend are fully integrated.
- **Database & Backend**: Implemented using NestJS + TypeORM + SQLite (`swapify.db`) running on port 3000.
- **Frontend Integration**: All pages (Auth, Setup Profile, Feed/Browse, Swap Requests, Chat, Notifications, Subscription & Checkout) communicate with real backend API endpoints.

---

## Getting Started

Follow these steps to set up and run Swapify locally.

### Prerequisites
- **Flutter SDK**: Ensure you have Flutter installed. [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
- **Node.js**: Make sure Node.js (v18+) is installed. [Node.js Downloads](https://nodejs.org/)

---

### Backend & Database Setup

The backend is built with NestJS and uses SQLite as the database.

1. **Navigate to the backend directory**:
   ```bash
   cd backend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure Environment Variables**:
   A `.env` file with default values is already set up for development in the `backend/` directory:
   ```env
   DATABASE_PATH=./swapify.db
   JWT_SECRET=swapify-dev-secret-change-in-production
   JWT_EXPIRATION=3600
   PORT=3000
   ```

4. **Run the Backend Server**:
   Start the development server. The backend will automatically create the SQLite database (`swapify.db`), run TypeORM migrations, and seed initial skill data and mock users.
   ```bash
   npm run start:dev
   ```
   - **API URL**: `http://localhost:3000`
   - **Swagger Documentation**: `http://localhost:3000/api/docs`

---

### Frontend Setup & Running

The frontend is a Flutter application that runs on Web, Mobile (Android/iOS), and Desktop.

1. **Navigate to the frontend directory**:
   ```bash
   cd ../frontend
   ```

2. **Fetch Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Configure API Endpoint**:
   The API endpoint configuration is located in `frontend/lib/services/api_config.dart`. It automatically detects the platform:
   - For **Web**, **iOS Simulator**, and **Desktop** (Windows/macOS/Linux), it connects to `http://localhost:3000`.
   - For **Android Emulator**, it connects to `http://10.0.2.2:3000`.
   
   If you are running on a **physical device**, update `baseUrl` in `api_config.dart` to your computer's local IP address (e.g. `http://192.168.1.100:3000`).

4. **Run the Application**:
   - To run on your default device:
     ```bash
     flutter run
     ```
   - To run specifically on Chrome (Web):
     ```bash
     flutter run -d chrome
     ```
   - To run on Windows desktop:
     ```bash
     flutter run -d windows
     ```

---

## Objective

To provide a platform for students to exchange skills without financial barriers, using a structured request and rating system.
