#!/bin/bash
# Cloud Decoder health check — verifies the website, the Cloudflare Worker,
# and the Claude API (end to end) are all working. Safe to run anytime.

WEBSITE="https://pilotdecoder.com/cloud-decoder/"
WORKER="https://cloud-decoder.zwubbena.workers.dev/classify"

# a tiny sky-blue test image (48x48 JPEG) so we can exercise the real Claude call
TEST_IMG="/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAoHBwgHBgoICAgLCgoLDhgQDg0NDh0VFhEYIx8lJCIfIiEmKzcvJik0KSEiMEExNDk7Pj4+JS5ESUM8SDc9Pjv/2wBDAQoLCw4NDhwQEBw7KCIoOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozv/wAARCAAwADADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDo6KKK9g8oKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD/2Q=="

green() { printf "\033[32m✓ %s\033[0m\n" "$1"; }
red()   { printf "\033[31m✗ %s\033[0m\n" "$1"; }
fails=0

echo ""
echo "Checking Cloud Decoder…"
echo "─────────────────────────────"

# 1) Website (served by GitHub Pages)
code=$(curl -s -o /dev/null -w "%{http_code}" "$WEBSITE")
if [ "$code" = "200" ]; then green "Website is up  (pilotdecoder.com/cloud-decoder)"
else red "Website problem — got HTTP $code"; fails=$((fails+1)); fi

# 2) Cloudflare Worker reachable (CORS preflight)
code=$(curl -s -o /dev/null -w "%{http_code}" -X OPTIONS "$WORKER")
if [ "$code" = "204" ]; then green "Cloudflare Worker is deployed and reachable"
else red "Worker problem — preflight got HTTP $code"; fails=$((fails+1)); fi

# 3) Full chain: Worker → your API key → Claude → back
resp=$(curl -s -w "\n%{http_code}" -X POST "$WORKER" \
  -H "content-type: application/json" \
  -d "{\"image\":\"$TEST_IMG\",\"mediaType\":\"image/jpeg\"}")
body=$(echo "$resp" | sed '$d')
code=$(echo "$resp" | tail -n1)
if [ "$code" = "200" ] && echo "$body" | grep -q "types"; then
  green "Claude API is answering  (key is valid, billing OK)"
else
  red "Claude API problem — HTTP $code"
  echo "     response: $body"
  echo "     → usually a bad/expired API key or \$0 Anthropic balance"
  fails=$((fails+1))
fi

echo "─────────────────────────────"
if [ "$fails" = "0" ]; then
  printf "\033[32mAll good — everything is working.\033[0m\n\n"
else
  printf "\033[31m%s check(s) failed (see above).\033[0m\n\n" "$fails"
fi