// ── Supabase configuration ──────────────────────────────────────────────
// 1. Go to https://supabase.com → create a project (free tier is fine).
// 2. Project Settings → API → copy "Project URL" and "anon public" key.
// 3. Paste them below.
class SupabaseConfig {
  static const String url = 'https://YOUR_PROJECT.supabase.co';
  static const String anonKey = 'YOUR_ANON_PUBLIC_KEY';

  // Storage bucket names — must match the buckets you create in
  // Supabase Storage (see supabase_schema.sql / SETUP.md).
  static const String studentPhotosBucket = 'student_photos';
  static const String parentPhotosBucket = 'parent_photos';
}
