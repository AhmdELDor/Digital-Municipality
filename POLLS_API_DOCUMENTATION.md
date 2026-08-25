# Polls API Documentation

## Overview
The Polls API allows administrators to create, manage, and conduct polls for citizen engagement. Users can vote on active polls, and the system tracks votes to prevent duplicate voting.

---

## Endpoints

### 1. List All Polls
**Endpoint:** `GET /api/polls`

**Description:** Retrieve a paginated list of all polls with search functionality.

**Query Parameters:**
- `search` (optional): Search text to filter polls by title
- `page` (optional): Page number for pagination (default: 1)

**Request Example:**
```http
GET /api/polls?search=budget&page=1
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Polls retrieved successfully",
    "data": [
        {
            "id": "01HM123...",
            "title": "2026 Budget Priorities",
            "description": "Help us decide where to allocate the municipal budget",
            "options": {
                "Education": 45,
                "Healthcare": 32,
                "Infrastructure": 28,
                "Environment": 15
            },
            "start_at": "2026-01-01T00:00:00.000000Z",
            "end_at": "2026-01-31T23:59:59.000000Z",
            "status": "in_progress",
            "votes_count": 120,
            "created_at": "2025-12-15T10:00:00.000000Z",
            "updated_at": "2026-01-01T15:30:00.000000Z"
        }
    ],
    "pagination": {
        "current_page": 1,
        "last_page": 3,
        "per_page": 10,
        "total": 25
    }
}
```

---

### 2. Create a New Poll
**Endpoint:** `POST /api/polls`

**Description:** Create a new poll (Admin only).

**Headers:**
- `Content-Type: application/json`
- `Authorization: Bearer {token}`

**Request Body:**
```json
{
    "title": "Park Renovation Options",
    "description": "Which park should we renovate first?",
    "options": ["Central Park", "East Park", "West Park", "North Park"],
    "start_at": "2026-01-15T00:00:00Z",
    "end_at": "2026-02-15T23:59:59Z",
    "status": "pending"
}
```

**Validation Rules:**
- `title`: Required, string, max 255 characters
- `description`: Optional, string
- `options`: Required, array of strings (will be converted to object with 0 votes)
- `start_at`: Optional, datetime
- `end_at`: Optional, datetime, must be after start_at
- `status`: Required, enum: `pending`, `in_progress`, `ended`

**Response (201 Created):**
```json
{
    "status": "success",
    "message": "Poll created successfully",
    "data": {
        "id": "01HM456...",
        "title": "Park Renovation Options",
        "description": "Which park should we renovate first?",
        "options": {
            "Central Park": 0,
            "East Park": 0,
            "West Park": 0,
            "North Park": 0
        },
        "start_at": "2026-01-15T00:00:00.000000Z",
        "end_at": "2026-02-15T23:59:59.000000Z",
        "status": "pending",
        "votes_count": 0,
        "created_at": "2026-01-01T14:30:00.000000Z",
        "updated_at": "2026-01-01T14:30:00.000000Z"
    }
}
```

---

### 3. View Single Poll
**Endpoint:** `GET /api/polls/{id}`

**Description:** Retrieve details of a specific poll including current vote counts.

**Request Example:**
```http
GET /api/polls/01HM456...
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Poll retrieved successfully",
    "data": {
        "id": "01HM456...",
        "title": "Park Renovation Options",
        "description": "Which park should we renovate first?",
        "options": {
            "Central Park": 45,
            "East Park": 32,
            "West Park": 28,
            "North Park": 15
        },
        "start_at": "2026-01-15T00:00:00.000000Z",
        "end_at": "2026-02-15T23:59:59.000000Z",
        "status": "in_progress",
        "votes_count": 120,
        "created_at": "2026-01-01T14:30:00.000000Z",
        "updated_at": "2026-01-10T10:20:00.000000Z"
    }
}
```

---

### 4. Update a Poll
**Endpoint:** `PUT/PATCH /api/polls/{id}`

**Description:** Update an existing poll (Admin only).

**Headers:**
- `Content-Type: application/json`
- `Authorization: Bearer {token}`

**Request Body:**
```json
{
    "title": "Updated Poll Title",
    "description": "Updated description",
    "status": "in_progress",
    "end_at": "2026-03-01T23:59:59Z"
}
```

**Validation Rules:**
- `title`: Optional, string, max 255 characters
- `description`: Optional, string
- `options`: Optional, array
- `start_at`: Optional, datetime
- `end_at`: Optional, datetime, must be after start_at
- `status`: Optional, enum: `pending`, `in_progress`, `ended`

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Poll updated successfully",
    "data": {
        "id": "01HM456...",
        "title": "Updated Poll Title",
        "description": "Updated description",
        "options": {
            "Central Park": 45,
            "East Park": 32,
            "West Park": 28,
            "North Park": 15
        },
        "start_at": "2026-01-15T00:00:00.000000Z",
        "end_at": "2026-03-01T23:59:59.000000Z",
        "status": "in_progress",
        "votes_count": 120,
        "created_at": "2026-01-01T14:30:00.000000Z",
        "updated_at": "2026-01-12T09:15:00.000000Z"
    }
}
```

---

### 5. Delete a Poll
**Endpoint:** `DELETE /api/polls/{id}`

**Description:** Delete a poll (Admin only).

**Request Example:**
```http
DELETE /api/polls/01HM456...
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Poll deleted successfully",
    "data": null
}
```

---

### 6. Vote on a Poll
**Endpoint:** `POST /api/polls/{id}/vote`

**Description:** Cast a vote on an active poll. Each user can only vote once per poll.

**Headers:**
- `Content-Type: application/json`
- `Authorization: Bearer {token}`

**Request Body:**
```json
{
    "option": "Central Park"
}
```

**Validation Rules:**
- `option`: Required, string, must match one of the poll's available options

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Vote cast successfully.",
    "data": null
}
```

**Error Responses:**

**400 - Poll Not Active:**
```json
{
    "status": "error",
    "message": "This poll is not currently active."
}
```

**400 - Poll Closed:**
```json
{
    "status": "error",
    "message": "This poll is closed."
}
```

**400 - Invalid Option:**
```json
{
    "status": "error",
    "message": "Invalid option selected."
}
```

**409 - Already Voted:**
```json
{
    "status": "error",
    "message": "You have already voted in this poll."
}
```

---

## Data Structure

### Poll Object
```json
{
    "id": "ULID string",
    "title": "string (max 255)",
    "description": "text or null",
    "options": {
        "Option 1": number,
        "Option 2": number,
        "Option 3": number
    },
    "start_at": "timestamp or null",
    "end_at": "timestamp or null",
    "status": "pending|in_progress|ended",
    "votes_count": number,
    "created_at": "timestamp",
    "updated_at": "timestamp"
}
```

### Status Values
- `pending`: Poll created but not yet started
- `in_progress`: Poll is currently active and accepting votes
- `ended`: Poll has concluded, no more votes accepted

### Options Format
The `options` field is stored as a JSON object where:
- **Keys** are the option names (string)
- **Values** are the vote counts (integer)

When creating a poll, you can submit options as a simple array:
```json
"options": ["Option A", "Option B", "Option C"]
```

The system will automatically convert it to:
```json
"options": {
    "Option A": 0,
    "Option B": 0,
    "Option C": 0
}
```

---

## Search Functionality

The search feature allows you to find polls by title:

**Example:**
```http
GET /api/polls?search=budget
```
This will return all polls where the title contains "budget" (case-insensitive, partial match).

---

## Voting Rules

1. **One Vote Per User**: Each authenticated user can only vote once on each poll
2. **Poll Must Be Active**: Poll status must be `in_progress`
3. **Time Window**: Current time must be between `start_at` and `end_at` (if set)
4. **Valid Option**: The selected option must exist in the poll's options
5. **Transaction Safety**: Vote recording and count increment happen atomically

---

## Poll Lifecycle

```
1. Created (status: pending)
   ↓
2. Started (status: in_progress) ← Voting allowed
   ↓
3. Ended (status: ended) ← No more voting
```

---

## Error Responses

### 401 Unauthorized
```json
{
    "message": "Unauthenticated."
}
```

### 404 Not Found
```json
{
    "status": "error",
    "message": "Poll not found"
}
```

### 422 Validation Error
```json
{
    "message": "The given data was invalid.",
    "errors": {
        "title": ["The title field is required."],
        "options": ["The options field is required."],
        "end_at": ["The end at field must be a date after start at."]
    }
}
```

---

## Notes

1. **Authentication**: All endpoints require authentication using Bearer token
2. **Admin Privileges**: Create, update, and delete operations typically require admin role
3. **Vote Tracking**: Votes are tracked in a separate `poll_votes` table
4. **Real-time Counts**: Vote counts are updated immediately when a vote is cast
5. **Pagination**: List endpoint returns 10 polls per page by default
6. **Duplicate Prevention**: System prevents users from voting multiple times on the same poll
7. **Time Validation**: Polls can have optional start and end times for automatic activation/deactivation
8. **Options Flexibility**: Options are stored as JSON allowing dynamic poll structures
