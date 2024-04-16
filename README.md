# web-app depolyment using terraform

# gocd encription api
curl 'http://54.89.126.47:8153/go/api/admin/encrypt' \
-H 'Accept: application/vnd.go.cd.v1+json' \
-H 'Content-Type: application/json' \
-X POST -d '{
"value": "XXXXXXXXXX"
}'
