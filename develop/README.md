# OnlineReady

**OnlineReady** es una plataforma para la gestión y distribución de cursos online, diseñada para escuelas técnicas. Utiliza servicios de AWS para automatizar la recepción de materiales, el almacenamiento seguro, la notificación automática y el registro de eventos.

```mermaid
graph TD
    A[Usuario sube archivo] --> B[S3 Bucket]
    B --> C[Lambda: notifier]
    C --> D[DynamoDB: Registro de evento]
    C --> E[SES: Notificación por correo]
```