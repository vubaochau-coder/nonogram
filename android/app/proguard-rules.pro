# ProGuard / R8 keep rules cho bản release (isMinifyEnabled = true).
#
# Flutter Gradle plugin đã tự thêm keep rules cơ bản cho io.flutter.**; file này
# chỉ bổ sung rules cho các plugin/thư viện mà R8 có thể làm rối nhầm và gây
# crash runtime (phản chiếu, JNI, native, Play Core...).

# --- Flutter deferred components / Play Core (thường bị R8 cảnh báo thiếu lớp) ---
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# --- Giữ annotation, Parcelable, enum, Keep ---
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod
-keep class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class androidx.annotation.Keep
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# --- Google Mobile Ads (AdMob) ---
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# --- Google Play Billing / in_app_purchase ---
-keep class com.android.billingclient.api.** { *; }
-dontwarn com.android.billingclient.api.**

# --- audioplayers (ExoPlayer/Media3) ---
-dontwarn com.google.android.exoplayer2.**
-dontwarn androidx.media3.**

# --- Giữ tên exception để stack trace còn đọc được (kết hợp mapping.txt) ---
-keepattributes SourceFile,LineNumberTable
