# OnlineReady

**OnlineReady** es una plataforma para la gestión y distribución de cursos online, diseñada para escuelas técnicas. Utiliza servicios de AWS para automatizar la recepción de materiales, el almacenamiento seguro, la notificación automática y el registro de eventos en la infraestructura.

```mermaid
graph TD
    A[Usuario sube archivo] --> B[S3 Bucket]
    B --> C[Lambda: notifier]
    C --> D[DynamoDB: Registro de evento]
    C --> E[SES: Notificación por correo]
```
-------------------------------------------------
```mermaid
graph TD
    A[Estudiantes/Instructores] -->|Acceden vía| B(CloudFront + S3)
    B -->|Autentican con| C(Cognito)
    C -->|Gestiona roles| D[API Gateway]
    D -->|Procesa lógica| E[Lambda]
    E -->|Consulta datos| F[(DynamoDB + RDS)]
    E -->|Almacena archivos| G[S3]
    D -->|Notificaciones| H[SNS + SES]
    F -->|Caché| I[ElastiCache]
    A -->|Chats técnicos| J[WebSockets]
    K[CloudWatch] -->|Monitorea| L{Toda la Infraestructura}
```
------------------------------------------------
```mermaid
graph TD
    A[Estudiantes/Instructores] -->|Acceden vía| B(CloudFront + S3)
    B -->|Autentican con| C(Cognito)
    C -->|Solicita roles| IAM
    IAM -->|Asigna permisos| C
    IAM -->|Autoriza| D[API Gateway]
    IAM -->|Ejecuta con rol| E[Lambda]
    IAM -->|Accede a| F[(DynamoDB + RDS)]
    IAM -->|Lee/Escribe| G[S3]
    IAM -->|Publica en| H[SNS + SES]
    IAM -->|Usa caché| I[ElastiCache]
    IAM -->|WebSockets| J[API Gateway]
    D -->|Procesa lógica| E
    E -->|Consulta datos| F
    E -->|Almacena archivos| G
    D -->|Notificaciones| H
    F -->|Caché| I
    A -->|Chats técnicos| J
    K[CloudWatch] -->|Monitorea| L{Toda la Infraestructura}
    L --> IAM

    style IAM fill:#ff9900,color:#fff,stroke:#333,stroke-width:2px
```