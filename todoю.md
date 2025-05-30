29.05

как запускать правильно контейнер

вообще все что связано с докером

сейчса я написала докер и конф для nginx, но я не могу запустить контейнер(хотя я его сбилдила), возможно неправильно вызываю комнаду.

Successfully built f3bbd2826f33
Successfully tagged nginx:latest
sabdulki@debian:~/project/srcs/requirements/nginx$ docker run -d -p 443:443 --name nginx nginx
docker: Error response from daemon: Conflict. The container name "/nginx" is already in use by container "e94e5a4747e7380f0562fb61727a34b4c50f892d0e514e042c297a32343be00e". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.

30.05 
1) я запустила nginx контейнер
2) разобралась со всеми docker командами

Как убедиться, что всё работает:
Ты уже сделал:
Контейнер запущен ✅
Порт 443 проброшен ✅

Теперь попробуй:
curl -k https://sabdulki.42.fr

мой ответ 403 Forbidden 
``` HTML
<html>
<head><title>403 Forbidden</title></head>
<body bgcolor="white">
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.14.2</center>
</body>
```

3) создала mariadb контейнер, в нем создалаcь чистая таблица и юзеры - root и обычный

