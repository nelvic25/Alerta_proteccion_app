# Aplicación móvil para prevenir la violencia contra las mujeres utilizando técnicas de localización :

# Backend:
Código del aplicativo utilizando Python : 
- Conexión SSH con los dispositivos de red que tengan OpenWrt implementado, para envió y recepción de data.
- Agregación, eliminación, verificación y actualización de registros en bases de datos Firestore Firebase.
- Posicionamiento con la técnica de trilateración partiendo del uso de 2 routers con OpenWrt en adelante.
- Generación de alertas dependiendo del tipo de escenario, individuales o globales, haciendo uso de Firebase Cloud Messaging.

# Frontend:
Código de aplicativo utilizando el framework Flutter, para sistemas operativos Android : 
- Interfaz del aplicativo, almacena y muestra al usuario los datos asociados de la base de datos Firestore Firebase.
- Se encarga del manejo de eventos que activan las respectivas alertas dependiendo del escenario en que se trabaje.
- Obtiene y almacena los tokens de cada dispositivo utilizado por el usuario, para recibir correctamente las alertas.

# Autores :
- Priscilla Nicole Uquillas Anguisaca
- Nelson Vicente Vera Méndez
