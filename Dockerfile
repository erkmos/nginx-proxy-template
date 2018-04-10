FROM nginx:mainline-alpine

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log && \
	apk add --no-cache openssl && \
	mkdir -p /etc/nginx/ssl && \
	openssl dhparam -out /etc/nginx/ssl/dhparam2048 2048 && \
	openssl req -x509 -sha256 -newkey rsa:4096 -keyout /etc/nginx/ssl/privkey.pem \
		-out /etc/nginx/ssl/cert.pem -days 365 -nodes \
		-subj '/CN=localhost/O=Bananas LTD/C=TH'

COPY dev-ssl.conf /etc/nginx/conf.d/dev.conf
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /etc/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]