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

Scalingo routes public HTTP and HTTPS traffic to application `web` containers. The Application Firewall is in Preview
and available upon request. It filters source IPv4 addresses for public HTTP/HTTPS traffic to `web` containers; TCP
add-ons and Private Networks are unaffected. It is not a Web Application Firewall and does not inspect request content.
See the [Application Firewall][application-firewall] and [public routing][routing] documentation for details.

Scaling or autoscaling can add capacity, but does not distinguish malicious traffic from legitimate increases. Configure
application-specific protections in your application or with a suitable proxy or CDN.


---

## Français {#fr}

### Trafic public vers les applications

Scalingo achemine le trafic HTTP et HTTPS public vers les conteneurs applicatifs `web`. Le pare-feu applicatif est en
préversion et accessible sur demande. Il filtre les adresses IPv4 sources du trafic HTTP/HTTPS public vers les conteneurs
`web` ; les add-ons TCP et les réseaux privés ne sont pas concernés. Ce n'est pas un pare-feu applicatif Web et il
n'inspecte pas le contenu des requêtes. Consultez les pages [Pare-feu applicatif (en anglais)][application-firewall] et
[routage public (en anglais)][routing] pour plus de détails.

La mise à l'échelle et l'autoscaling peuvent augmenter la capacité, mais ne distinguent pas le trafic malveillant d'une
hausse légitime. Configurez les protections propres à votre application dans celle-ci ou avec un proxy ou CDN adapté.

[application-firewall]: {% post_url platform/networking/public/2000-01-01-application-firewall %}
[routing]: {% post_url platform/networking/public/2000-01-01-routing %}
