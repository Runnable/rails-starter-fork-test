max_retries=${MAX_RETRIES:-20}
retries=$max_retries

while [ $retries -gt 0 ] ; do
  echo "Attempting curl: Retries ${retries}"
  exit_code=$(curl -sL -w "%{http_code}\\n" "http://192.168.64.11:3000" -o /dev/null)
  echo "Exit code: $exit_code"
  if [[ "$exit_code" == "200" ]]; then
    echo "test pass succsefuly"
    exit 0
  fi
  ((retries--))
  sleep 1
done

echo "Out of retries"
exit 1
