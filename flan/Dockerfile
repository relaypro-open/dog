FROM nginx

RUN mkdir /usr/share/nginx/html/flan_api/
COPY flan_ips /usr/share/nginx/html/flan_api/external/undefined/
COPY flan_ips /usr/share/nginx/html/flan_api/internal/undefined/
COPY vulners_by_hostname /usr/share/nginx/html/flan_api/internal/undefined/
COPY vulners_by_hostname /usr/share/nginx/html/flan_api/external/undefined/
