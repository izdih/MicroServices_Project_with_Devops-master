

# Utilisation de l'image Maven officielle pour la compilation
FROM maven AS build

# Définit le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copier le fichier pom.xml et télécharger les dépendances
COPY pom.xml .

# Télécharger les dépendances nécessaires sans construire le projet
RUN mvn dependency:go-offline -B

# Copier le reste du projet dans le répertoire de travail
COPY src ./src

# Construire l'application
RUN mvn clean package -DskipTests

# Utilisation d'une image légère JDK pour exécuter l'application
FROM openjdk:17-jdk-slim

# Crée un répertoire pour l'application
WORKDIR /app

# Copier le fichier jar généré depuis l'étape de build
COPY --from=build /app/target/*.jar discovery.jar

# Expose le port par défaut utilisé par le service Eureka (8761)
EXPOSE 8761

# Commande pour exécuter l'applicationl
ENTRYPOINT ["java", "-jar", "discovery.jar"]
