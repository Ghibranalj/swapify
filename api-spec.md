# Swapify API Specification

**Version:** 1.0.0
**Base URL:** `https://api.swapify.com/v1`

## Authentication

All endpoints (except OAuth) require Bearer token authentication:

```
Authorization: Bearer {access_token}
```

## Data Models

### User
```json
{
  "id": "string (uuid)",
  "name": "string",
  "bio": "string",
  "createdAt": "string (ISO8601)",
  "updatedAt": "string (ISO8601)"
}
```

### Skill
```json
{
  "id": "string (uuid)",
  "name": "string",
  "description": "string",
  "certificateUrl": "string (nullable)",
  "isUserCreated": "boolean"
}
```

### UserSkill
```json
{
  "id": "string (uuid)",
  "userId": "string (uuid)",
  "skillId": "string (uuid)",
  "proficiency": "number (1-5)",
  "certificateUrl": "string (nullable)",
  "createdAt": "string (ISO8601)"
}
```

### SwapRequest
```json
{
  "id": "string (uuid)",
  "requesterId": "string (uuid)",
  "providerId": "string (uuid)",
  "requesterSkillId": "string (uuid)",
  "providerSkillId": "string (uuid)",
  "status": "pending | active | done | cancelled",
  "createdAt": "string (ISO8601)",
  "updatedAt": "string (ISO8601)"
}
```

### Message
```json
{
  "id": "string (uuid)",
  "swapRequestId": "string (uuid)",
  "senderId": "string (uuid)",
  "recipientId": "string (uuid)",
  "content": "string",
  "timestamp": "string (ISO8601)",
  "read": "boolean"
}
```

### Rating
```json
{
  "id": "string (uuid)",
  "swapRequestId": "string (uuid)",
  "raterId": "string (uuid)",
  "ratedUserId": "string (uuid)",
  "rating": "number (1-5)",
  "comment": "string (optional)",
  "createdAt": "string (ISO8601)"
}
```

---

## Endpoints

### Authentication

#### POST /auth/google
Exchange Google OAuth token for access token.

**Request Body:**
```json
{
  "idToken": "string"
}
```

**Response (200):**
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "expiresIn": "number (seconds)",
  "user": { "id": "string", "name": "string", "bio": "string" }
}
```

#### POST /auth/refresh
Refresh access token using refresh token.

**Request Body:**
```json
{
  "refreshToken": "string"
}
```

**Response (200):**
```json
{
  "accessToken": "string",
  "expiresIn": "number (seconds)"
}
```

---

### Users

#### GET /users/me
Get current user profile.

**Response (200):**
```json
{
  "id": "string",
  "name": "string",
  "bio": "string",
  "skills": [{ "skill": {...}, "proficiency": 5 }],
  "createdAt": "string",
  "updatedAt": "string"
}
```

#### PUT /users/me
Update current user profile.

**Request Body:**
```json
{
  "name": "string (optional)",
  "bio": "string (optional)"
}
```

**Response (200):**
```json
{
  "id": "string",
  "name": "string",
  "bio": "string",
  "skills": [{ "skill": {...}, "proficiency": 5 }],
  "createdAt": "string",
  "updatedAt": "string"
}
```

#### GET /users/{userId}
Get public user profile.

**Response (200):**
```json
{
  "id": "string",
  "name": "string",
  "bio": "string",
  "skills": [{ "skill": {...}, "proficiency": 5 }],
  "averageRating": "number"
}
```

---

### Skills

#### GET /skills
List all available skills (including user-created).

**Query Parameters:**
- `search`: string (optional) - Search skill names
- `page`: number (default: 1)
- `limit`: number (default: 20)

**Response (200):**
```json
{
  "skills": [{ "id": "string", "name": "string", "description": "string" }],
  "page": 1,
  "totalPages": 5,
  "total": 100
}
```

#### POST /skills
Create a new custom skill.

**Request Body:**
```json
{
  "name": "string",
  "description": "string"
}
```

**Response (201):**
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "isUserCreated": "true"
}
```

---

### User Skills

#### GET /users/me/skills
Get current user's skills.

**Response (200):**
```json
{
  "skills": [
    {
      "id": "string",
      "skill": { "id": "string", "name": "string" },
      "proficiency": 5,
      "certificateUrl": "string (nullable)"
    }
  ]
}
```

#### POST /users/me/skills
Add a skill to current user.

**Request Body:**
```json
{
  "skillId": "string",
  "proficiency": "number (1-5)",
  "certificateUrl": "string (optional)"
}
```

**Response (201):**
```json
{
  "id": "string",
  "skillId": "string",
  "proficiency": 5,
  "certificateUrl": "string (nullable)"
}
```

#### PUT /users/me/skills/{userSkillId}
Update a user skill.

**Request Body:**
```json
{
  "proficiency": "number (1-5, optional)",
  "certificateUrl": "string (optional)"
}
```

**Response (200):**
```json
{
  "id": "string",
  "skillId": "string",
  "proficiency": 5,
  "certificateUrl": "string (nullable)"
}
```

#### DELETE /users/me/skills/{userSkillId}
Remove a skill from current user.

**Response (204):** No content

---

### Skills to Learn

#### GET /users/me/skills-to-learn
Get skills the current user wants to learn.

**Response (200):**
```json
{
  "skills": [
    {
      "id": "string",
      "skill": { "id": "string", "name": "string" },
      "rating": "number (1-5)"
    }
  ]
}
```

#### POST /users/me/skills-to-learn
Add a skill to learn.

**Request Body:**
```json
{
  "skillId": "string",
  "rating": "number (1-5)"
}
```

**Response (201):**
```json
{
  "id": "string",
  "skillId": "string",
  "rating": 5
}
```

#### DELETE /users/me/skills-to-learn/{id}
Remove a skill from learning list.

**Response (204):** No content

---

### Certificate Upload

#### POST /certificates/upload
Upload certificate to S3-compatible storage (MinIO).

**Request:** `multipart/form-data`

| Field | Type | Required |
|-------|------|----------|
| file | File | Yes |
| filename | string | Yes |

**Response (200):**
```json
{
  "url": "string",
  "filename": "string",
  "size": "number",
  "contentType": "string"
}
```

---

### Feed

#### GET /feed
Get matching users based on skills to learn.

**Query Parameters:**
- `page`: number (default: 1)
- `limit`: number (default: 20)
- `sort`: string (default: "relevance") - "relevance" | "rating" | "newest"

**Response (200):**
```json
{
  "matches": [
    {
      "user": {
        "id": "string",
        "name": "string",
        "bio": "string",
        "averageRating": "number"
      },
      "matchingSkills": [
        {
          "skill": { "id": "string", "name": "string" },
          "proficiency": 5,
          "certificateUrl": "string (nullable)"
        }
      ],
      "matchScore": "number"
    }
  ],
  "page": 1,
  "totalPages": 10,
  "total": 200
}
```

---

### Swap Requests

#### GET /swap-requests
Get current user's swap requests.

**Query Parameters:**
- `status`: string (optional) - "pending" | "active" | "done" | "cancelled"
- `direction`: string (optional) - "sent" | "received"
- `page`: number (default: 1)
- `limit`: number (default: 20)

**Response (200):**
```json
{
  "requests": [
    {
      "id": "string",
      "requester": { "id": "string", "name": "string" },
      "provider": { "id": "string", "name": "string" },
      "requesterSkill": { "id": "string", "name": "string" },
      "providerSkill": { "id": "string", "name": "string" },
      "status": "pending",
      "createdAt": "string",
      "updatedAt": "string"
    }
  ],
  "page": 1,
  "totalPages": 3,
  "total": 50
}
```

#### POST /swap-requests
Create a new swap request.

**Request Body:**
```json
{
  "providerId": "string",
  "requesterSkillId": "string",
  "providerSkillId": "string"
}
```

**Response (201):**
```json
{
  "id": "string",
  "requesterId": "string",
  "providerId": "string",
  "requesterSkillId": "string",
  "providerSkillId": "string",
  "status": "pending",
  "createdAt": "string",
  "updatedAt": "string"
}
```

#### PUT /swap-requests/{id}/status
Update swap request status.

**Request Body:**
```json
{
  "status": "active | done | cancelled"
}
```

**Response (200):**
```json
{
  "id": "string",
  "status": "active",
  "updatedAt": "string"
}
```

#### GET /swap-requests/{id}
Get swap request details.

**Response (200):**
```json
{
  "id": "string",
  "requester": { "id": "string", "name": "string" },
  "provider": { "id": "string", "name": "string" },
  "requesterSkill": { "id": "string", "name": "string" },
  "providerSkill": { "id": "string", "name": "string" },
  "status": "pending",
  "createdAt": "string",
  "updatedAt": "string"
}
```

---

### Messages

#### GET /swap-requests/{swapRequestId}/messages
Get messages for a swap request.

**Query Parameters:**
- `before`: string (ISO8601, optional) - Pagination cursor
- `limit`: number (default: 50)

**Response (200):**
```json
{
  "messages": [
    {
      "id": "string",
      "senderId": "string",
      "recipientId": "string",
      "content": "string",
      "timestamp": "string",
      "read": "boolean"
    }
  ],
  "hasMore": "boolean",
  "nextCursor": "string (nullable)"
}
```

#### POST /swap-requests/{swapRequestId}/messages
Send a message.

**Request Body:**
```json
{
  "content": "string"
}
```

**Response (201):**
```json
{
  "id": "string",
  "swapRequestId": "string",
  "senderId": "string",
  "recipientId": "string",
  "content": "string",
  "timestamp": "string",
  "read": "false"
}
```

#### PUT /messages/{id}/read
Mark message as read.

**Response (200):**
```json
{
  "id": "string",
  "read": "true"
}
```

---

### Ratings

#### GET /users/{userId}/ratings
Get ratings for a user.

**Response (200):**
```json
{
  "ratings": [
    {
      "id": "string",
      "swapRequestId": "string",
      "rating": 5,
      "comment": "string",
      "createdAt": "string"
    }
  ],
  "averageRating": "number",
  "totalRatings": "number"
}
```

#### POST /swap-requests/{swapRequestId}/ratings
Rate a user for a completed swap.

**Request Body:**
```json
{
  "ratedUserId": "string",
  "rating": "number (1-5)",
  "comment": "string (optional)"
}
```

**Response (201):**
```json
{
  "id": "string",
  "swapRequestId": "string",
  "raterId": "string",
  "ratedUserId": "string",
  "rating": 5,
  "comment": "string",
  "createdAt": "string"
}
```

---

### Notifications

#### GET /notifications
Get user notifications.

**Query Parameters:**
- `read`: boolean (optional) - Filter by read status
- `type`: string (optional) - "swap_request" | "message" | "rating"
- `page`: number (default: 1)
- `limit`: number (default: 20)

**Response (200):**
```json
{
  "notifications": [
    {
      "id": "string",
      "type": "swap_request",
      "title": "string",
      "body": "string",
      "data": { "swapRequestId": "string" },
      "read": "false",
      "createdAt": "string"
    }
  ],
  "page": 1,
  "totalPages": 5,
  "total": 100
}
```

#### PUT /notifications/{id}/read
Mark notification as read.

**Response (200):**
```json
{
  "id": "string",
  "read": "true"
}
```

#### PUT /notifications/read-all
Mark all notifications as read.

**Response (200):**
```json
{
  "updatedCount": 25
}
```

---

## Error Responses

All endpoints may return error responses:

```json
{
  "error": {
    "code": "string",
    "message": "string",
    "details": { } (optional)
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `UNAUTHORIZED` | 401 | Invalid or missing token |
| `FORBIDDEN` | 403 | User lacks permission |
| `NOT_FOUND` | 404 | Resource not found |
| `VALIDATION_ERROR` | 400 | Invalid request data |
| `CONFLICT` | 409 | Resource already exists |
| `INTERNAL_ERROR` | 500 | Server error |
