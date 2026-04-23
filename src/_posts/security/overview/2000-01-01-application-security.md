---
title: Application Security
nav: Application
modified_at: 2026-04-16 00:00:00
tags: compliance security measures application
index: 3
---

- [English version](#en)
- [Version française](#fr)

<a id="en"></a>

## English

Deploying an application on Scalingo ensures that you are following a base set of security practices from the beginning.

### Immutable Infrastructure

As you push your code to Scalingo, we build a new container image with your code and dependencies. This ensures that the
infrastructure is always up-to-date and that the latest security patches are applied. The built image is frozen and any
changes that would be made to the container are lost when the container is stopped, scaled, or rescheduled by our platform.

### Container Isolation

Each application is deployed in its own container, which is isolated from other containers running on the same host.
This ensures that the application is protected from other applications running on the same host. The containers are also
isolated from the host operating system, which provides an additional layer of security.

### Scalability

The platform allows you to scale your application horizontally by adding more containers or vertically by increasing the
size of the containers. This ensures that your application can handle the expected traffic volume and that it is
protected from denial-of-service attacks or simple traffic spikes.

Furthemore, if enabled, the auto-scaling feature will automatically adjust the number of containers based on, for
example, the CPU usage of the application or the number of requests it receives.

### Dependency Management

We regularly update the dependencies used by the platform to ensure that they are up-to-date and that they do not
contain any known security vulnerabilities. This includes the base images used to build the containers, the libraries
and tools used by the platform, and the dependencies used by the applications deployed on the platform.

### Security Headers

We use security headers to protect the platform from common security vulnerabilities such as cross-site scripting (XSS)
and clickjacking. These headers are configured to prevent common attacks and to protect the platform from known security
vulnerabilities.

### Encryption

All data transmitted between the platform and the user is encrypted using TLS (HTTPS). This ensures that the data is protected
from eavesdropping and tampering. The allowed ciphers are regularly updated to ensure that the platform is protected
from the latest security vulnerabilities.

For example, we only allow TLS 1.2 and TLS 1.3 ciphers and we disable weak ciphers and protocols such as SSLv3 and TLS 1.0.

---

<a id="fr"></a>

## Français

Le déploiement d'une application sur Scalingo garantit que vous suivez un ensemble de pratiques de sécurité de base dès le départ.

### Infrastructure Immuable

Lorsque vous envoyez votre code sur Scalingo, nous construisons une nouvelle image conteneur avec votre code et vos dépendances. Cela garantit que l'infrastructure est toujours à jour et que les derniers correctifs de sécurité sont appliqués. L'image construite est figée et toute modification apportée au conteneur est perdue lorsque le conteneur est arrêté, mis à l'échelle ou reprogrammé par notre plateforme.

### Isolation des Conteneurs

Chaque application est déployée dans son propre conteneur, qui est isolé des autres conteneurs s'exécutant sur le même hôte. Cela garantit que l'application est protégée des autres applications s'exécutant sur le même hôte. Les conteneurs sont également isolés du système d'exploitation hôte, ce qui fournit une couche supplémentaire de sécurité.

### Scalabilité

La plateforme vous permet de mettre à l'échelle votre application horizontalement en ajoutant plus de conteneurs ou verticalement en augmentant la taille des conteneurs. Cela garantit que votre application peut gérer le volume de trafic attendu et qu'elle est protégée des attaques par déni de service ou des pics de trafic simples.

De plus, si activée, la fonctionnalité d'auto-scaling ajustera automatiquement le nombre de conteneurs en fonction, par exemple, de l'utilisation du CPU de l'application ou du nombre de requêtes qu'elle reçoit.

### Gestion des Dépendances

Nous mettons à jour régulièrement les dépendances utilisées par la plateforme pour assurer qu'elles sont à jour et qu'elles ne contiennent aucune vulnérabilité de sécurité connue. Cela inclut les images de base utilisées pour construire les conteneurs, les bibliothèques et outils utilisés par la plateforme, et les dépendances utilisées par les applications déployées sur la plateforme.

### En-têtes de Sécurité

Nous utilisons des en-têtes de sécurité pour protéger la plateforme des vulnérabilités de sécurité courantes telles que le cross-site scripting (XSS) et le clickjacking. Ces en-têtes sont configurés pour prévenir les attaques courantes et pour protéger la plateforme des vulnérabilités de sécurité connues.

### Chiffrement

Toutes les données transmises entre la plateforme et l'utilisateur sont chiffrées en utilisant TLS (HTTPS). Cela garantit que les données sont protégées contre l'écoute clandestine et la falsification. Les chiffrements autorisés sont régulièrement mis à jour pour assurer que la plateforme est protégée contre les dernières vulnérabilités de sécurité.

Par exemple, nous autorisons uniquement les chiffrements TLS 1.2 et TLS 1.3 et nous désactivons les chiffrements et protocoles faibles tels que SSLv3 et TLS 1.0.
