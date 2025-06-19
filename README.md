# OnlineReady

OnlineReady es una plataforma para la gestión, distribución y monitoreo de cursos online, orientada a escuelas técnicas. La infraestructura está desplegada sobre AWS utilizando Terraform, y sigue un enfoque modular, seguro y escalable.

## Componentes Principales

- **Frontend**
  - Distribuido con Amazon CloudFront y contenido estático en un bucket público de S3.
  - Autenticación centralizada mediante Amazon Cognito.
  - IAM Identity Center opcional para usuarios internos o administrativos.

- **Backend**
  - Rutas diferenciadas en Amazon API Gateway (`/api/cursos`, `/api/usuarios`, `/api/archivos`) que dirigen a funciones Lambda específicas.
  - Lambdas separadas por flujo lógico: `Courses`, `Users`, `Files`, `Mensajes`.
  - Operaciones CRUD sobre:
    - **Amazon RDS (PostgreSQL)**: `tabla: CursoDocente`, `tabla: Usuarios`
    - **Amazon DynamoDB**: `tabla: MetadatosCursos`
  - Almacenamiento segmentado en S3:
    - `S3 Público`: distribución de recursos accesibles
    - `S3 Privado`: almacenamiento interno de materiales académicos
  - Acceso a S3 mediante **VPC Gateway Endpoints**, evitando exposición a Internet.

- **Orquestación y Alta Disponibilidad**
  - Procesos desacoplados mediante **Amazon SQS** (colas) y **SNS** (notificaciones).
  - Automatización de subida y procesamiento de archivos a través de `Lambda Files Manager`.

- **Monitoreo**
  - AWS CloudWatch para registros y métricas.
  - Trazabilidad de eventos y alarmas operativas.

---

## Flujo de Carga de Archivos

```mermaid
graph TD
    A[Usuario sube archivo] --> B[S3 Bucket Privado]
    B --> C[Lambda: Files Message Function]
    C --> D[DynamoDB: Registro de evento]
    C --> E[SNS/SES: Notificación automática]
```
------

## Flujo General de Plataforma
```mermaid
graph TD
    A[Estudiantes/Instructores] -->|Acceso| B(CloudFront + S3 Público)
    B -->|Autenticación| C(Cognito)
    C -->|Autorización| D[API Gateway]
    D -->|Invoca lógica| E[Lambda específica]
    E -->|Consulta/Actualiza| F[(DynamoDB + RDS)]
    E -->|Almacena| G[S3 Privado]
    D -->|Desencadena| H[SNS + SES]
    F -->|Optimización opcional| I[DAX / ElastiCache]
    J[CloudWatch] -->|Monitorea| K{Infraestructura completa}
```

----

## Seguridad y Acceso
```mermaid
graph TD
    A[Frontend Cognito] --> B[Roles IAM por usuario]
    B -->|Permisos temporales| C[Lambda]
    C -->|Accede seguro| D[S3 y BD vía VPC Endpoints]
    D -->|Envía eventos| E[SNS/SQS]
    E -->|Informa| F[Administradores / Usuarios]
    G[CloudWatch] -->|Auditoría| H{Logs, errores, trazas}
```