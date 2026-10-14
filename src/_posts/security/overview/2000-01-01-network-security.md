---
title: Network Security
nav: Network
modified_at: 2026-10-14 00:00:00
tags: compliance security measures
index: 2
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

### Public application traffic

Scalingo's public routing forwards web requests to application containers and handles TLS termination and load
balancing. See the [public routing documentation][routing] for supported behavior.

### Application-level protections

Scaling or autoscaling can add application capacity, but it does not determine whether a traffic increase is malicious
or legitimate. Scalingo's [Application Firewall][application-firewall] is currently in Preview and available upon
request. It filters public HTTP and HTTPS traffic to `web` containers based on source IPv4 ranges; TCP add-on traffic
and Private Networks are unaffected. It is not a Web Application Firewall: it does not inspect request content or
provide bot protection. It also does not implement policies for individual users or
application endpoints. Configure those controls in your application or through a proxy or CDN suited to your requirements.

For details about routing, request queues, and client IP headers, see the [public routing documentation][routing].

---

## Français {#fr}

### Trafic public vers les applications

Le routage public de Scalingo transmet les requêtes Web aux conteneurs applicatifs et gère la terminaison TLS ainsi que
l'équilibrage de charge. Consultez la [documentation du routage public (en anglais)][routing] pour connaître les comportements pris
en charge.

### Protections au niveau applicatif

La mise à l'échelle et l'autoscaling peuvent augmenter la capacité d'une application, mais ne déterminent pas si une
hausse du trafic est malveillante ou légitime. Le [pare-feu applicatif (en anglais)][application-firewall] de Scalingo est actuellement
en préversion et accessible sur demande. Il filtre le trafic HTTP et HTTPS public vers les conteneurs `web` selon des
plages d'adresses IPv4 sources ; le trafic des add-ons TCP et les réseaux privés ne sont pas concernés. Ce n'est pas
un pare-feu applicatif Web : il n'inspecte pas le contenu des requêtes et ne fournit pas de protection contre les robots. Il n'applique pas non plus de règles propres aux utilisateurs ou aux points d'accès de
l'application. Configurez ces contrôles dans votre application ou via un proxy ou CDN adapté à vos besoins.

Pour en savoir plus sur le routage, les files de requêtes et les en-têtes d'adresse IP cliente, consultez la
[documentation sur le routage public (en anglais)][routing].

[application-firewall]: {% post_url platform/networking/public/2000-01-01-application-firewall %}
[routing]: {% post_url platform/networking/public/2000-01-01-routing %}
