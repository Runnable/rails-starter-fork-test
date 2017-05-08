max_retries=${MAX_RETRIES:-200}
retries=$max_retries

echo "Start tests..."

while [ $retries -gt 0 ] ; do
  echo "Attempting curl: Retries ${retries}"
  echo "Apphost: $APP_HOST"
  curl -sL -w "%{http_code}\\n" "http://$APP_HOST:3000"
  exit_code=$(curl -sL -w "%{http_code}\\n" "http://$APP_HOST:3000" -o /dev/null)
  echo "Exit code: $exit_code"
  if [[ "$exit_code" == "200" ]]; then
    echo "test pass succsefuly"
    exit 0
  fi
  ((retries--))
  echo "sleep 5"
  sleep 5
done

echo "Out of retries"
exit 1
