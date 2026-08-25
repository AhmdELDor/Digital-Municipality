# Projects API Guide

## Overview
Manage projects with optional multiple images stored on the public disk. Uploads accept multipart form-data; the API stores public URLs in `image_urls`.

## Endpoints
- `GET /api/projects` – Paginated list (10 per page, latest first)
- `POST /api/projects` – Create a project with optional images
- `GET /api/projects/{id}` – Fetch a single project
- `PUT /api/projects/{id}` – Update a project (can replace images)
- `DELETE /api/projects/{id}` – Remove a project (deletes stored images)

## Request Fields
- `title` (string, required, max 255)
- `description` (string, required)
- `status` (string, optional, max 100)
- `category` (string, optional, max 100)
- `location` (string, optional, max 255)
- `image_urls` (array of files, optional) – each file: jpg/jpeg/png/svg, max 5 MB
- `start_date` (date, optional)
- `end_date` (date, optional, must be >= start_date)

## Create Example (multipart)
```bash
curl -X POST https://your-domain.test/api/projects \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Accept: application/json" \
  -F "title=Road upgrade" \
  -F "description=Resurfacing main street" \
  -F "status=planned" \
  -F "category=infrastructure" \
  -F "location=Central district" \
  -F "start_date=2025-01-15" \
  -F "end_date=2025-06-30" \
  -F "image_urls[]=@C:/path/to/photo1.jpg" \
  -F "image_urls[]=@C:/path/to/photo2.png"
```

## Update Example (multipart)
```bash
curl -X PUT https://your-domain.test/api/projects/{id} \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Accept: application/json" \
  -F "title=Road upgrade phase 2" \
  -F "status=ongoing" \
  -F "image_urls[]=@C:/path/to/new-photo.jpg"
```
- When new `image_urls` are sent, old images are deleted then replaced.

## Success Response Shape
```json
{
  "status": true,
  "message": "Project created successfully",
  "data": {
    "id": "01HB3...", 
    "title": "Road upgrade",
    "description": "Resurfacing main street",
    "status": "planned",
    "category": "infrastructure",
    "location": "Central district",
    "image_urls": [
      "https://your-domain.test/storage/projects/images/photo1.jpg",
      "https://your-domain.test/storage/projects/images/photo2.png"
    ],
    "start_date": "2025-01-15",
    "end_date": "2025-06-30",
    "created_at": "2025-12-30T12:00:00Z",
    "updated_at": "2025-12-30T12:00:00Z"
  }
}
```

## Notes
- Field name for files is `image_urls[]` (array). Use multiple `-F image_urls[]=@...` parts for multiple files.
- Storage uses the `public` disk via `uploadMultipleFiles()` in `app/Traits/FileUploadTrait.php`; ensure `php artisan storage:link` is present so URLs resolve.
- `DELETE /api/projects/{id}` removes stored images before deleting the record.
