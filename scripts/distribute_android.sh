#!/usr/bin/env bash
# Build APK release của Nonopix rồi đẩy lên Firebase App Distribution, dùng
# chung project Firebase với app chess (chess-app-chauvb).
#
# Cách dùng:
#   scripts/distribute_android.sh [tuỳ chọn]
#
# Tuỳ chọn:
#   --notes "..."          Ghi chú phát hành (mặc định: commit mới nhất)
#   --notes-file PATH      Đọc ghi chú phát hành từ file
#   --groups a,b           Nhóm tester (alias trong Firebase)
#   --testers x@y,z@w      Email tester
#   --skip-tests           Bỏ qua flutter analyze/test
#   --dry-run              Chỉ build, không upload
#   --yes                  Không hỏi lại (tự tạo app Firebase nếu chưa có,
#                          chấp nhận ký bằng debug key nếu thiếu keystore)
#   -h, --help             Xem hướng dẫn này
#
# Cấu hình mặc định có thể ghi đè bằng biến môi trường hoặc file
# scripts/distribute.env (không commit; xem scripts/distribute.env.example):
#   FIREBASE_PROJECT_ID     mặc định chess-app-chauvb
#   FIREBASE_APP_ID         App ID Android; để trống thì tự tìm theo package
#   FIREBASE_APP_NAME       tên hiển thị khi tự tạo app (mặc định Nonopix)
#   FIREBASE_TESTER_GROUPS  nhóm tester, cách nhau dấu phẩy
#   FIREBASE_TESTERS        email tester, cách nhau dấu phẩy
#   FIREBASE_ACCOUNT        tài khoản Google dùng cho firebase CLI (khi máy
#                           đăng nhập nhiều tài khoản)
#   GOOGLE_APPLICATION_CREDENTIALS  file service account (thay cho đăng nhập)
#   FIREBASE_TOOLS_VERSION  phiên bản firebase-tools khi chạy qua npx
#
# Yêu cầu: Flutter (theo .fvmrc), Android SDK, Node.js (để chạy firebase CLI),
# và đã `firebase login` (hoặc có GOOGLE_APPLICATION_CREDENTIALS).

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f "$ROOT_DIR/scripts/distribute.env" ]]; then
  # shellcheck disable=SC1091
  source "$ROOT_DIR/scripts/distribute.env"
fi

PACKAGE_NAME="com.chauvb.nonogram"
: "${FIREBASE_PROJECT_ID:=chess-app-chauvb}"
: "${FIREBASE_APP_ID:=}"
: "${FIREBASE_APP_NAME:=Nonopix}"
: "${FIREBASE_TESTER_GROUPS:=}"
: "${FIREBASE_TESTERS:=}"
: "${FIREBASE_ACCOUNT:=}"
: "${FIREBASE_TOOLS_VERSION:=15.34.1}"

NOTES=""
NOTES_FILE=""
SKIP_TESTS=0
DRY_RUN=0
ASSUME_YES=0

usage() {
  sed -n '2,/^$/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --notes) NOTES="${2:?--notes cần nội dung}"; shift 2 ;;
    --notes-file) NOTES_FILE="${2:?--notes-file cần đường dẫn}"; shift 2 ;;
    --groups) FIREBASE_TESTER_GROUPS="${2:?--groups cần giá trị}"; shift 2 ;;
    --testers) FIREBASE_TESTERS="${2:?--testers cần giá trị}"; shift 2 ;;
    --skip-tests) SKIP_TESTS=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --yes|-y) ASSUME_YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Tuỳ chọn không hợp lệ: $1 (xem --help)" >&2; exit 64 ;;
  esac
done

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[!] %s\033[0m\n' "$*" >&2; }
die() { printf '\033[1;31m[x] %s\033[0m\n' "$*" >&2; exit 1; }

confirm() {
  [[ "$ASSUME_YES" == 1 ]] && return 0
  [[ -t 0 ]] || return 1
  local answer
  read -r -p "$1 [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

trim_list() { printf '%s' "$1" | tr -d '[:space:]'; }
FIREBASE_TESTER_GROUPS="$(trim_list "$FIREBASE_TESTER_GROUPS")"
FIREBASE_TESTERS="$(trim_list "$FIREBASE_TESTERS")"
FIREBASE_APP_ID="$(trim_list "$FIREBASE_APP_ID")"

if [[ -n "$NOTES_FILE" && ! -f "$NOTES_FILE" ]]; then
  die "Không tìm thấy file ghi chú: $NOTES_FILE"
fi
if [[ "$DRY_RUN" == 0 && -z "$FIREBASE_TESTER_GROUPS" && -z "$FIREBASE_TESTERS" ]]; then
  die "Chưa có người nhận: đặt FIREBASE_TESTER_GROUPS / FIREBASE_TESTERS (trong scripts/distribute.env) hoặc dùng --groups / --testers."
fi

# --- Công cụ ---------------------------------------------------------------

FLUTTER=(flutter)
if [[ -x "$ROOT_DIR/.fvm/flutter_sdk/bin/flutter" ]]; then
  FLUTTER=("$ROOT_DIR/.fvm/flutter_sdk/bin/flutter")
elif ! command -v flutter >/dev/null 2>&1; then
  die "Không tìm thấy flutter. Cài Flutter hoặc chạy 'fvm install' trong thư mục dự án."
fi

expected_flutter="$(sed -n 's/.*"flutter"[^"]*"\([^"]*\)".*/\1/p' .fvmrc 2>/dev/null || true)"
actual_flutter="$("${FLUTTER[@]}" --version 2>/dev/null | sed -n 's/^Flutter \([0-9.]*\).*/\1/p' | head -n 1)"
if [[ -n "$expected_flutter" && -n "$actual_flutter" && "$expected_flutter" != "$actual_flutter" ]]; then
  warn "Flutter đang dùng là $actual_flutter, dự án ghim $expected_flutter (.fvmrc)."
fi

FIREBASE=()
if command -v firebase >/dev/null 2>&1; then
  FIREBASE=(firebase)
elif command -v npx >/dev/null 2>&1; then
  FIREBASE=(npx -y "firebase-tools@${FIREBASE_TOOLS_VERSION}")
elif [[ "$DRY_RUN" == 0 ]]; then
  die "Không tìm thấy firebase CLI hay npx. Cài Node.js rồi 'npm i -g firebase-tools'."
fi
ACCOUNT_ARGS=()
if [[ -n "$FIREBASE_ACCOUNT" ]]; then
  ACCOUNT_ARGS=(--account "$FIREBASE_ACCOUNT")
fi

firebase_cli() {
  "${FIREBASE[@]}" "$@" ${ACCOUNT_ARGS[@]+"${ACCOUNT_ARGS[@]}"}
}

json_field() {
  # Đọc JSON (output --json của firebase CLI) từ stdin, in ra appId của app có
  # package name khớp $1 (để trống: app đầu tiên).
  node -e '
    let raw = "";
    process.stdin.on("data", (c) => (raw += c));
    process.stdin.on("end", () => {
      const start = raw.indexOf("{");
      if (start < 0) process.exit(2);
      const data = JSON.parse(raw.slice(start));
      const list = Array.isArray(data.result) ? data.result : [data.result];
      // apps:list (API searchApps) trả package name trong "namespace";
      // apps:create trả "packageName".
      const want = process.argv[1];
      const hit = list.find(
        (a) => a && (!want || a.packageName === want || a.namespace === want),
      );
      if (!hit || !hit.appId) process.exit(3);
      process.stdout.write(hit.appId);
    });
  ' "${1:-}"
}

# --- Firebase app ----------------------------------------------------------

resolve_app_id() {
  if [[ -n "$FIREBASE_APP_ID" ]]; then
    return
  fi
  step "Tìm app Android $PACKAGE_NAME trong project $FIREBASE_PROJECT_ID"
  local listing
  if ! listing="$(firebase_cli apps:list ANDROID --project "$FIREBASE_PROJECT_ID" --json 2>&1)"; then
    echo "$listing" >&2
    die "Không đọc được danh sách app. Đã 'firebase login' bằng tài khoản có quyền trên $FIREBASE_PROJECT_ID chưa?"
  fi
  if FIREBASE_APP_ID="$(printf '%s' "$listing" | json_field "$PACKAGE_NAME")"; then
    echo "App ID: $FIREBASE_APP_ID"
    return
  fi

  warn "Project $FIREBASE_PROJECT_ID chưa có app Android $PACKAGE_NAME."
  confirm "Tạo app Android '$FIREBASE_APP_NAME' ($PACKAGE_NAME) trong $FIREBASE_PROJECT_ID?" ||
    die "Huỷ. Tạo app trong Firebase Console hoặc chạy lại với --yes."
  local created
  if ! created="$(firebase_cli apps:create ANDROID "$FIREBASE_APP_NAME" \
    --package-name "$PACKAGE_NAME" --project "$FIREBASE_PROJECT_ID" --json 2>&1)"; then
    echo "$created" >&2
    die "Tạo app thất bại."
  fi
  FIREBASE_APP_ID="$(printf '%s' "$created" | json_field "")" || die "Không đọc được App ID của app vừa tạo."
  echo "Đã tạo app. App ID: $FIREBASE_APP_ID"
  echo "Gợi ý: lưu FIREBASE_APP_ID=$FIREBASE_APP_ID vào scripts/distribute.env và biến FIREBASE_APP_ID của GitHub Actions."
}

# --- Ký app ----------------------------------------------------------------

check_signing() {
  if [[ -f "$ROOT_DIR/android/key.properties" ]]; then
    return
  fi
  warn "Không có android/key.properties: APK sẽ ký bằng debug key của máy này."
  warn "Tester sẽ không cài đè được giữa bản build từ máy này và bản build từ CI."
  confirm "Vẫn tiếp tục?" || die "Huỷ. Tạo android/key.properties (cùng keystore với secret ANDROID_KEYSTORE_BASE64 của CI)."
}

# --- Phiên bản -------------------------------------------------------------

VERSION_NAME="$(sed -n 's/^version: *\([^+]*\).*/\1/p' pubspec.yaml)"
# Số build = số commit tính tới HEAD, giống workflow Distribute trên CI: ngắn,
# luôn tăng, và cùng một commit thì build ở đâu cũng ra cùng một số.
BUILD_NUMBER="$(git rev-list --count HEAD 2>/dev/null || true)"
[[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]] || die "Không đếm được số commit (cần chạy trong repo git có đủ lịch sử)."
COMMIT_SHA="$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
DIRTY=""
if [[ -n "$(git status --porcelain --untracked-files=no 2>/dev/null)" ]]; then
  DIRTY=" (có thay đổi chưa commit)"
fi

write_notes() {
  local out="$1"
  {
    if [[ -n "$NOTES_FILE" ]]; then
      cat "$NOTES_FILE"
    elif [[ -n "$NOTES" ]]; then
      printf '%s\n' "$NOTES"
    else
      git log -1 --format=%B 2>/dev/null || echo "Bản build thử"
    fi
    echo
    echo "Version: $VERSION_NAME ($BUILD_NUMBER)"
    echo "Commit: $COMMIT_SHA$DIRTY"
    echo "Build: máy $(hostname -s 2>/dev/null || hostname)"
  } > "$out"
}

# --- Chạy ------------------------------------------------------------------

echo "Nonopix $VERSION_NAME ($BUILD_NUMBER), commit $COMMIT_SHA$DIRTY"
echo "Firebase project: $FIREBASE_PROJECT_ID"
[[ "$DRY_RUN" == 1 ]] && echo "Chế độ --dry-run: chỉ build, không upload."

if [[ "$DRY_RUN" == 0 ]]; then
  resolve_app_id
fi
check_signing

step "flutter pub get"
"${FLUTTER[@]}" pub get --enforce-lockfile

if [[ "$SKIP_TESTS" == 0 ]]; then
  step "flutter analyze"
  "${FLUTTER[@]}" analyze
  step "flutter test"
  "${FLUTTER[@]}" test
fi

step "Build APK release"
"${FLUTTER[@]}" build apk --release --build-number="$BUILD_NUMBER"
APK="$ROOT_DIR/build/app/outputs/flutter-apk/app-release.apk"
[[ -f "$APK" ]] || die "Không thấy APK tại $APK"
echo "APK: $APK"

if [[ "$DRY_RUN" == 1 ]]; then
  echo
  echo "Xong (--dry-run, không upload)."
  exit 0
fi

NOTES_TMP="$(mktemp)"
trap 'rm -f "$NOTES_TMP"' EXIT
write_notes "$NOTES_TMP"

step "Upload lên Firebase App Distribution"
cat "$NOTES_TMP"
ARGS=(
  appdistribution:distribute "$APK"
  --app "$FIREBASE_APP_ID"
  --project "$FIREBASE_PROJECT_ID"
  --release-notes-file "$NOTES_TMP"
)
[[ -n "$FIREBASE_TESTER_GROUPS" ]] && ARGS+=(--groups "$FIREBASE_TESTER_GROUPS")
[[ -n "$FIREBASE_TESTERS" ]] && ARGS+=(--testers "$FIREBASE_TESTERS")
firebase_cli "${ARGS[@]}"

echo
echo "Đã phát hành Nonopix $VERSION_NAME ($BUILD_NUMBER)."
