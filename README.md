# PayMe

## Descripción
**PayMe** es una aplicación móvil desarrollada con Flutter que permite a los usuarios gestionar sus préstamos de manera eficiente y sencilla. La aplicación ofrece una variedad de funcionalidades que facilitan la creación, visualización, eliminación y búsqueda de clientes, así como la gestión de préstamos asociados a cada cliente.

## Características

### Gestión de Clientes
- **Crear Cliente**: Registra nuevos clientes con información detallada, incluyendo nombre, apellidos, teléfono, número de identidad y dirección. También se puede añadir un "contacto de emergencia" que será responsable del préstamo en caso de que surja alguna situación con el cliente.
- **Eliminar Cliente**: Permite eliminar un cliente específico de la base de datos.
- **Ver Cliente**: Muestra la información completa de cada cliente registrado.
- **Buscar Cliente**: Facilita la búsqueda de un cliente específico por su nombre.

### Gestión de Préstamos
- **Crear Préstamo**: Registra nuevos préstamos con detalles como monto, tasa de interés, frecuencia de pago y cantidad de cuotas.
- **Actualizar Préstamo**: Permite actualizar la cantidad de cuotas pagadas de un préstamo existente.
- **Visualizar Préstamo**: Muestra los detalles completos de un préstamo específico.
- **Eliminar Préstamo**: Permite eliminar un préstamo de la base de datos.

### Gestión de Empresas
- **Crear Empresa**: Registra una empresa prestamista, asociando los préstamos a esta entidad.
- **Ver Empresa**: Muestra la información de la empresa registrada.
- **Editar Empresa**: Permite modificar los datos de la empresa, como dirección, nombre, teléfono y RCN (Registro de Contribuyente Nacional).

### Panel de Usuario
- **Información de Cuenta**: Proporciona un resumen de la cuenta del usuario, incluyendo el total de clientes, total de préstamos, cantidad de préstamos terminados y renovados.

### Interfaz Intuitiva
- **Diseño Amigable**: La aplicación cuenta con una interfaz fácil de usar, diseñada para mejorar la experiencia del usuario.

## Tecnologías Utilizadas
- **Flutter**: Framework para construir la interfaz de usuario de la aplicación.
- **Dart**: Lenguaje de programación utilizado para el desarrollo de la aplicación.
- **Firebase**: Plataforma utilizada para la gestión de datos en tiempo real y autenticación de usuarios.
- **Bloc**: Patrón de gestión de estado que ayuda a separar la lógica de negocio de la interfaz de usuario.
