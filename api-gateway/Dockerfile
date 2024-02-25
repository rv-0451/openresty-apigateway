FROM openresty/openresty:1.21.4.1-0-bullseye-fat

RUN opm get taylorking/lua-resty-jwt

ENTRYPOINT ["/usr/local/openresty/bin/openresty"]
CMD ["-p", "/usr/local/openresty/nginx", "-c", "/usr/local/openresty/nginx/conf/nginx.conf", "-g", "daemon off;"]
