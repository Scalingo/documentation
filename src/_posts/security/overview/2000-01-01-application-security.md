---
title: Application Security
nav: Application
modified_at: 2026-10-14 00:00:00
tags: compliance security measures application
index: 3
---

- [English version](#en)
- [Version française](#fr)

## English {#en}

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

You can add containers or increase their size to handle more traffic. Scaling can add capacity, but it cannot distinguish
malicious traffic from a legitimate increase.

When enabled, autoscaling adjusts the number of containers based on measures such as application CPU usage or request
volume.

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

## Français {#fr}

Le déploiement d'une application sur Scalingo garantit que vous suivez un ensemble de pratiques de sécurité de base dès le départ.

### Infrastructure Immuable

Lorsque vous envoyez votre code sur Scalingo, nous construisons une nouvelle image conteneur avec votre code et vos dépendances. Cela garantit que l'infrastructure est toujours à jour et que les derniers correctifs de sécurité sont appliqués. L'image construite est figée et toute modification apportée au conteneur est perdue lorsque le conteneur est arrêté, mis à l'échelle ou reprogrammé par notre plateforme.

### Isolation des Conteneurs

Chaque application est déployée dans son propre conteneur, qui est isolé des autres conteneurs s'exécutant sur le même hôte. Cela garantit que l'application est protégée des autres applications s'exécutant sur le même hôte. Les conteneurs sont également isolés du système d'exploitation hôte, ce qui fournit une couche supplémentaire de sécurité.

### Scalabilité {#scalabilite}

Ajoutez des conteneurs ou augmentez leur taille pour absorber une hausse du trafic. La mise à l'échelle peut augmenter
la capacité, mais ne distingue pas le trafic malveillant d'une hausse légitime.

Lorsque l'autoscaling est activé, il ajuste le nombre de conteneurs selon des mesures telles que l'utilisation du CPU
ou le nombre de requêtes reçues.

### Gestion des Dépendances {#gestion-des-dependances}

Nous mettons à jour régulièrement les dépendances utilisées par la plateforme pour assurer qu'elles sont à jour et qu'elles ne contiennent aucune vulnérabilité de sécurité connue. Cela inclut les images de base utilisées pour construire les conteneurs, les bibliothèques et outils utilisés par la plateforme, et les dépendances utilisées par les applications déployées sur la plateforme.

### En-têtes de Sécurité {#en-tetes-de-securite}

Nous utilisons des en-têtes de sécurité pour protéger la plateforme des vulnérabilités de sécurité courantes telles que le cross-site scripting (XSS) et le clickjacking. Ces en-têtes sont configurés pour prévenir les attaques courantes et pour protéger la plateforme des vulnérabilités de sécurité connues.

### Chiffrement

Toutes les données transmises entre la plateforme et l'utilisateur sont chiffrées en utilisant TLS (HTTPS). Cela garantit que les données sont protégées contre l'écoute clandestine et la falsification. Les chiffrements autorisés sont régulièrement mis à jour pour assurer que la plateforme est protégée contre les dernières vulnérabilités de sécurité.

Par exemple, nous autorisons uniquement les chiffrements TLS 1.2 et TLS 1.3 et nous désactivons les chiffrements et protocoles faibles tels que SSLv3 et TLS 1.0.
